import 'dart:developer';

import 'package:event_connect/controllers/userControllers/bookings_controller.dart';
import 'package:event_connect/core/bindings/bindings.dart';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/models/bookingModel/booking_model.dart';
import 'package:event_connect/models/chatModels/chat_thread_model.dart';
import 'package:event_connect/services/chattingService/chatting_service.dart';
import 'package:event_connect/views/screens/bottomNavBar/chatsTab/message_Screen.dart';
import 'package:event_connect/views/screens/categoryScreens/category_detail_screen.dart';
import 'package:event_connect/l10n/app_localizations.dart';

import '../../../../generated/assets.dart';
import '../../../../main_packages.dart';
import '../../../widget/bookingCards/booking_card.dart';

class BookingTab extends StatefulWidget {
  const BookingTab({super.key});

  @override
  State<BookingTab> createState() => _BookingTabState();
}

class _BookingTabState extends State<BookingTab> {
  bool isPastSelected = false;
  BookingsController controller = Get.find<BookingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.booking),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BookingToggle(
              onToggle: (isPast) {
                setState(() {
                  isPastSelected = isPast;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: isPastSelected
                  ? _buildPastBookings()
                  : _buildUpcomingBookings(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildUpcomingBookings() {
    return Column(
      children: [
        Expanded(
            child: ListView.separated(
          itemCount: controller.upcomingBookings.length,
          itemBuilder: (context, index) {
            BookingModel bookingModel = controller.upcomingBookings[index];

            return GestureDetector(
              onTap: () => Get.to(() => CategoryDetailScreen(
                bookingModel:bookingModel,
                    serviceModel: bookingModel.serviceModel!,
                    isUserView: true,
                  )),
              child: buildBookingCard(
                  isPerhour: bookingModel.serviceModel?.perHour??false,
                  context: context,
                  showChat: true,
                  onChatTap: () async {
                    log("bookingModel.supplierModel?.id = ${bookingModel.serviceModel?.createdBy}");

                    ChatThreadModel? chatThreadModel =
                        await ChattingService.instance.createOrGetOneToOneChat(
                            senderId: userModelGlobal.value?.id ?? "",
                            receiverId:
                                bookingModel.serviceModel?.createdBy ?? "");
                    if (chatThreadModel != null) {
                      if (chatThreadModel.senderId ==
                          userModelGlobal.value?.id) {
                        chatThreadModel = chatThreadModel.copyWith(
                            otherUserDetail: chatThreadModel.receiverModel);
                      } else {
                        chatThreadModel = chatThreadModel.copyWith(
                            otherUserDetail: chatThreadModel.senderModel);
                      }
                      Get.to(
                          () => MessageScreen(chatThreadModel: chatThreadModel),
                          binding: ChatBinding(),
                          arguments: chatThreadModel);
                    }
                  },
                  title: bookingModel.serviceModel?.serviceName ?? "",
                  showBook: false,
                  price: bookingModel.serviceModel?.amount ?? "0",
                  location: '',
                  url: bookingModel.serviceModel?.serviceImage ??
                      dummyProfileUrl),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 20,
            );
          },

          // ListView(
          //
          //   children: [
          //     _buildDateHeader("Yesterday, March 25 2022"),
          //     buildBookingCard(
          //       imagePath: Assets.imagesEvent1,
          //       title: "Corporate Event Managers",
          //       location: "Manchester Central Complex",
          //     ),
          //     const SizedBox(height: 16),
          //     _buildDateHeader("Monday, March 24 2022"),
          //     buildBookingCard(
          //       imagePath: Assets.imagesEvent1,
          //       title: "Catering",
          //       location: "Manchester Central Complex",
          //     ),
          //     const SizedBox(height: 12),
          //     buildBookingCard(
          //       imagePath: Assets.imagesEvent1,
          //       title: "Corporate Event Managers",
          //       location: "Manchester Central Complex",
          //     ),
          //   ],
          // ),
        ))
      ],
    );
  }

  Widget _buildPastBookings() {
    return Column(
      children: [
        Expanded(
            child: ListView.separated(
          itemCount: controller.otherBookings.length,
          itemBuilder: (context, index) {
            BookingModel bookingModel = controller.otherBookings[index];
        
            return GestureDetector(
              onTap: () => Get.to(() => CategoryDetailScreen(
                    serviceModel: bookingModel.serviceModel!,
                    isUserView: true,
                  )),
              child: buildBookingCard(
                  isPerhour: bookingModel.serviceModel?.perHour??false,
                  title: bookingModel.serviceModel?.serviceName ?? "",
                  context: context,
                  showBook: false,
                  price: bookingModel.serviceModel?.amount ?? "0",
                  location: '',
                  url: bookingModel.serviceModel?.serviceImage ?? dummyProfileUrl),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10,
            );
          },
        
          // ListView(
          //
          //   children: [
          //     _buildDateHeader("Yesterday, March 25 2022"),
          //     buildBookingCard(
          //       imagePath: Assets.imagesEvent1,
          //       title: "Corporate Event Managers",
          //       location: "Manchester Central Complex",
          //     ),
          //     const SizedBox(height: 16),
          //     _buildDateHeader("Monday, March 24 2022"),
          //     buildBookingCard(
          //       imagePath: Assets.imagesEvent1,
          //       title: "Catering",
          //       location: "Manchester Central Complex",
          //     ),
          //     const SizedBox(height: 12),
          //     buildBookingCard(
          //       imagePath: Assets.imagesEvent1,
          //       title: "Corporate Event Managers",
          //       location: "Manchester Central Complex",
          //     ),
          //   ],
          // ),
        )),
      ],
    );
  }
}

class BookingToggle extends StatefulWidget {
  final Function(bool isPast) onToggle;

  const BookingToggle({super.key, required this.onToggle});

  @override
  State<BookingToggle> createState() => _BookingToggleState();
}

class _BookingToggleState extends State<BookingToggle> {
  bool isPastSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Upcoming
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isPastSelected = false;
                });
                widget.onToggle(false);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isPastSelected ? Colors.transparent : kPrimaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.upcoming,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),

          // Past
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isPastSelected = true;
                });
                widget.onToggle(true);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isPastSelected ? kPrimaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.past,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
