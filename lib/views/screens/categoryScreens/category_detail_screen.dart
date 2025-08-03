import 'dart:developer';

import 'package:event_connect/controllers/suppierControllers/add_service_controller.dart';
import 'package:event_connect/core/bindings/bindings.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/enums/enums.dart';
import 'package:event_connect/core/enums/user_role.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/localization_helper.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/bookingModel/booking_model.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/models/userModel/user_model.dart';
import 'package:event_connect/services/onesignalNotificationService/one_signal_notification_service.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/auth/select_role_screen.dart';
import 'package:event_connect/views/screens/categoryScreens/schedule_booking.dart';
import 'package:event_connect/views/widget/bookingCards/booking_card.dart';
import 'package:event_connect/views/widget/carousel/base_carousel.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:event_connect/views/widget/reviewStar/custom_review_star.dart';


import '../../../controllers/userControllers/bookings_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/chatModels/chat_thread_model.dart';
import '../../../models/portfolioModel/portfolio_model.dart';
import '../../../services/chattingService/chatting_service.dart';
import '../bottomNavBar/chatsTab/message_Screen.dart';
import '../image_view.dart';
import '../supplier/homeScreen/chechout_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final ServiceModel serviceModel;
  final bool isSupplierView, isAdvertisedButton;
  final bool isUserView;
  final bool isBooking;
  final BookingModel? bookingModel;

  const CategoryDetailScreen(
      {super.key,
      this.bookingModel,
      required this.serviceModel,
      this.isSupplierView = false,
      this.isAdvertisedButton = false,
      this.isBooking = false,
      this.isUserView = false});

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  RxList<String> images = <String>[].obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void initState() {
    super.initState();
    readPortfolio(userId: widget.serviceModel.createdBy ?? '');

    readUser();
 
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final loc = AppLocalizations.of(context);
    if (loc == null) {
     print("loc is null");
    }
  });

  }

  readPortfolio({required String userId}) async {
    log("readPortfolio called userView = ${widget.isUserView}");
    List<Map<String, dynamic>>? docs = await SupabaseCRUDService.instance
        .readAllDocumentsWithFilters(
            tableName: SupabaseConstants().portfolioTable,
            filters: {'created_by': userId});

    if (docs != null) {
      PortfolioModel portfolioModel = PortfolioModel.fromJson(docs.first);
      images.value = portfolioModel.images ?? [];
    }
  }

  readUser() async {
    Map<String, dynamic>? doc;

    if (widget.isUserView) {
      doc = await SupabaseCRUDService.instance.readSingleDocument(
          tableName: SupabaseConstants().usersTable,
          id: widget.serviceModel.createdBy ?? '');
    } else {
      doc = await SupabaseCRUDService.instance.readSingleDocument(
          tableName: SupabaseConstants().usersTable,
          id: widget.bookingModel?.bookedBy ?? '');
    }

    if (doc != null) {
      userModel.value = UserModel.fromJson(doc);
    }
  }

  @override
  Widget build(BuildContext context) {
    log("Service Model = ${widget.serviceModel.toMap()}");
     final localizations = AppLocalizations.of(context);
     if (localizations == null) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: MyText(
            text: LocalizationHelper.getLocalizedServiceName(
                context, widget.serviceModel.serviceName ?? "")),
        actions: [
          if (widget.isSupplierView)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    DialogService.instance.showConfirmationDialog(
                      context: context,
                      title: AppLocalizations.of(context)!.deleteService,
                      message:
                          AppLocalizations.of(context)!.doYouWantDeleteService,
                      onYes: () async {
                        DialogService.instance
                            .showProgressDialog(context: context);
                        await SupabaseCRUDService.instance.deleteDocument(
                            tableName: SupabaseConstants().serviceTable,
                            id: widget.serviceModel.id ?? "");

                        if (widget.serviceModel.advertised == true) {
                          Get.find<AddServiceController>()
                              .advertisedServices
                              .removeWhere(
                            (element) {
                              return element.id == widget.serviceModel.id;
                            },
                          );
                        } else {
                          Get.find<AddServiceController>()
                              .generalServices
                              .removeWhere(
                            (element) {
                              return element.id == widget.serviceModel.id;
                            },
                          );
                        }

                        DialogService.instance
                            .hideProgressDialog(context: context);
                        Get.close(2);
                      },
                    );
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 10),
                          Text(AppLocalizations.of(context)!.delete),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            )
        ],
      ),
      bottomNavigationBar: widget.isBooking
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                  mBottom: 30,
                  radius: 100,
                  onTap: () {
                    Get.to(
                        () =>
                            ScheduleBooking(serviceModel: widget.serviceModel),
                        binding: ScheduleBookingBinding(),
                        arguments: widget.serviceModel);
                  },
                  buttonText: AppLocalizations.of(context)!.bookNow),
            )
          : widget.isAdvertisedButton
              ? (widget.serviceModel.advertised == true)
                  ? SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyButton(
                          mBottom: 30,
                          radius: 100,
                          onTap: () {
                            Get.to(() => CheckoutScreen(
                                  serviceModel: widget.serviceModel,
                                ));
                          },
                          buttonText:
                              localizations?.advertisedNow ??
                                  "Advertised Now"),
                    )
              : SizedBox(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              buildBookingCard(
                  isPerhour: widget.serviceModel.perHour ?? false,
                  price: widget.serviceModel.amount ?? "0",
                  url: widget.serviceModel.serviceImage ?? dummyProfileUrl,
                  showBook: false,
                  title: widget.serviceModel.serviceName ?? "",
                  location: widget.serviceModel.location ?? "",
                  context: context),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  MyText(
                    text: localizations?.about ?? "About",
                    color: kPrimaryColor,
                    weight: FontWeight.w600,
                    size: 16,
                  ),
                  Spacer(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              MyText(text: "${widget.serviceModel.about}"),
              const SizedBox(
                height: 20,
              ),
              MyText(
                text: AppLocalizations.of(context)?.service ?? "Service",
                color: kPrimaryColor,
                weight: FontWeight.w600,
                size: 16,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kBorderColor),
                  color: Colors.white,
                ),
                child: Center(
                    child: MyText(
                        text: LocalizationHelper.getLocalizedServiceName(
                            context, widget.serviceModel.serviceName ?? ""))),
              ),
              const SizedBox(
                height: 20,
              ),
              if (widget.isUserView == false && widget.isSupplierView == false)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)!.portfolio,
                      color: kPrimaryColor,
                      weight: FontWeight.w600,
                      size: 16,
                    ),
                    Card(
                      elevation: 10,
                      child: Container(
                        height: 120,
                        color: Colors.white,
                        child: Obx(
                          () => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: images.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                      () => ImageView(imageUrl: images[index]));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  clipBehavior: Clip.antiAlias,
                                  height: 100,
                                  width: 100,
                                  // margin: EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: CommonImageView(
                                    height: 100,
                                    width: 100,
                                    url: images[index],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (widget.bookingModel != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: AppLocalizations.of(context)?.bookingDetails ??
                          "Booking Details",
                      weight: FontWeight.w700,
                      size: 18,
                      color: kPrimaryColor,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kGreyColor3.withOpacity(0.6),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 18),
                            leading: MyText(
                              text:
                                  AppLocalizations.of(context)?.date ?? "Date",
                              weight: FontWeight.w600,
                              size: 16,
                            ),
                            trailing: MyText(
                              text:
                                  "${Utils.formatDateTime(widget.bookingModel!.selectedDate, context)}",
                              weight: FontWeight.w600,
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 18),
                            leading: MyText(
                              text:
                                  AppLocalizations.of(context)?.time ?? "Time",
                              weight: FontWeight.w600,
                              size: 16,
                            ),
                            trailing: MyText(
                              text: Utils.convertTo24Hour(
                                  widget.bookingModel!.selectedTime),
                              weight: FontWeight.w600,
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 18),
                            leading: MyText(
                              text: widget.isUserView
                                  ? AppLocalizations.of(context)?.supplier ??
                                      "Supplier"
                                  : AppLocalizations.of(context)?.bookedBy ??
                                      "Booked By",
                              weight: FontWeight.w600,
                              size: 16,
                            ),
                            trailing: Obx(
                              () => MyText(
                                text: "${userModel.value.fullName}",
                                weight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 18),
                            leading: MyText(
                              text: AppLocalizations.of(context)?.contactNo ??
                                  "Contact No",
                              weight: FontWeight.w600,
                              size: 16,
                            ),
                            trailing: Obx(
                              () => MyText(
                                text:
                                    "${userModel.value.completePhoneNo ?? "..."}",
                                weight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),

              SizedBox(
                height: 20,
              ),
              if (widget.bookingModel != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          log("whatsapp tapped");
                          DialogService.instance
                              .showProgressDialog(context: context);
                          Map<String, dynamic>? document =
                              await SupabaseCRUDService
                                  .instance
                                  .readSingleDocument(
                                      tableName: SupabaseConstants().usersTable,
                                      id: widget.serviceModel.createdBy ?? '');

                          DialogService.instance
                              .hideProgressDialog(context: context);
                          if (document != null) {
                            UserModel userModel = UserModel.fromJson(document);

                            Utils.openWhatsApp(
                                "${userModel.completePhoneNo ?? ''}");
                          }
                          log("Document = ${document}");
                        },
                        child: CommonImageView(
                          imagePath: Assets.imagesWhatsapp,
                          height: 35,
                          width: 35,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () async {
                          ChatThreadModel? chatThreadModel =
                              await ChattingService.instance
                                  .createOrGetOneToOneChat(
                                      senderId: userModelGlobal.value?.id ?? "",
                                      receiverId: widget.isUserView == false
                                          ? widget.bookingModel?.bookedBy ?? ""
                                          : widget.serviceModel.createdBy ??
                                              '');
                          if (chatThreadModel != null) {
                            log("userModel chatThreadModel = ${chatThreadModel.otherUserDetail?.toJson()}");
                            if (chatThreadModel.senderId ==
                                userModelGlobal.value?.id) {
                              chatThreadModel = chatThreadModel.copyWith(
                                  otherUserDetail:
                                      chatThreadModel.receiverModel);
                            } else {
                              chatThreadModel = chatThreadModel.copyWith(
                                  otherUserDetail: chatThreadModel.senderModel);
                            }
                            Get.to(
                                () => MessageScreen(
                                    chatThreadModel: chatThreadModel),
                                binding: ChatBinding(),
                                arguments: chatThreadModel);
                          }
                        },
                        child: Icon(
                          size: 35,
                          Icons.chat,
                          color: kPrimaryColor,
                        ))
                  ],
                ),
              SizedBox(
                height: 30,
              ),
              if (widget.bookingModel != null &&
                  widget.bookingModel?.bookingStatus ==
                      BookingStatus.upcoming.name)
                MyButton(
                    backgroundColor: Colors.redAccent,
                    onTap: () {
                      DialogService.instance.showConfirmationDialog(
                        context: context,
                        title: AppLocalizations.of(context)!.cancelBooking,
                        message: AppLocalizations.of(context)!
                            .doYouWantCancelBooking,
                        onYes: () async {
                          DialogService.instance
                              .showProgressDialog(context: context);
                          await SupabaseCRUDService.instance.updateDocument(
                              tableName: SupabaseConstants().bookingsTable,
                              id: widget.bookingModel?.id ?? "",
                              data: {
                                "booking_status": BookingStatus.cancel.name
                              });

                          DialogService.instance
                              .hideProgressDialog(context: context);
                          if (userModelGlobal.value!.userType ==
                              UserRole.user.name) {
                            log("userModelGlobal.value!.userType == user");
                            Get.find<BookingsController>()
                                .upcomingBookings
                                .removeWhere(
                                  (element) =>
                                      element.id == widget.bookingModel!.id,
                                );
                            Get.find<BookingsController>().otherBookings.add(
                                widget.bookingModel!.copyWith(
                                    bookingStatus: BookingStatus.cancel.name));
                            OneSignalNotificationService.instance
                                .sendOneSignalNotificationToUser(
                                    isSaved: true,
                                    externalId:
                                        widget.bookingModel?.supplierId ?? "",
                                    title: AppLocalizations.of(context)!
                                        .cancelBooking,
                                    message:
                                        "${userModelGlobal.value?.fullName} ${AppLocalizations.of(context)!.bookingCancelledNotification}");
                          } else {}

                          Get.close(1);

                          await Future.delayed(Duration(milliseconds: 100));
                          CustomSnackBars.instance.showSuccessSnackbar(
                              title: AppLocalizations.of(context)!.success,
                              message: AppLocalizations.of(context)!
                                  .bookingCancelled);
                        },
                      );
                    },
                    buttonText: AppLocalizations.of(context)?.cancelBooking ??
                        "Cancel Booking"),
              // if (isSupplierView == false)
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       MyText(
              //         text: "Reviews",
              //         color: kPrimaryColor,
              //         weight: FontWeight.w600,
              //         size: 16,
              //       ),
              //       const SizedBox(
              //         height: 20,
              //       ),
              //       BaseCarousel(
              //         items: const [
              //           ReviewWidget(),
              //           ReviewWidget(),
              //           ReviewWidget(),
              //         ],
              //         viewportFraction: 1,
              //       )
              //     ],
              //   ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: kBorderColor),
          ),
          color: Colors.white,
          shadows: const [
            BoxShadow(
                spreadRadius: 0.5, offset: Offset(4, 10), color: kBorderColor)
          ]),
      child: Column(
        children: [
          MyText(text: "Review ad sad asdas dasd asd asd sadasd asdasd"),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              CommonImageView(
                url: dummyProfileUrl,
                height: 20,
                width: 25,
                radius: 100,
              ),
              const SizedBox(
                width: 5,
              ),
              MyText(text: "User full name"),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const StarRating(rating: 4.5)
        ],
      ),
    );
  }
}
