import 'dart:developer';

import 'package:event_connect/controllers/userControllers/user_home_controller.dart';
import 'package:event_connect/core/bindings/bindings.dart';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/utils/app_lists.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/core/utils/localization_helper.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/models/userModel/user_model.dart';
import 'package:event_connect/views/screens/bottomNavBar/homeScreen/select_category.dart';
import 'package:event_connect/views/screens/categoryScreens/category_screen.dart';
import 'package:event_connect/views/screens/notifications_screen.dart';
import 'package:event_connect/views/widget/bottomSheets/home_filter_bottom_sheet.dart';
import 'package:event_connect/views/widget/carousel/base_carousel.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';

import '../../../widget/buttons/filter_button.dart';
import '../../../widget/my_text_widget.dart';
import '../../../widget/gallery/category_gallery_widget.dart';
import '../../categoryScreens/category_detail_screen.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  UserHomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _buildProfileHeader(userModelGlobal: userModelGlobal, context: context)),
            const SizedBox(height: 20),
            _buildSearchFilters(context: context),
            const SizedBox(height: 20),
            _buildSection(AppLocalizations.of(context)!.events, _buildEventCards(context), context: context, showViewAll: true),
            const SizedBox(height: 20),
            Obx(
              () => ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: controller.advertisedServices.length,
                itemBuilder: (context, index) {
                  final key =
                      controller.advertisedServices.keys.elementAt(index);
                  final value = controller.advertisedServices[key];

                  log("service =${key}");
                  return Column(
                    children: [
                      _buildSection(
                          key, Obx(() => _buildPromoCard(serviceType: key, context: context)), context: context),
                      SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CategoryGalleryWidget(
                          categoryName: key,
                          height: 100,
                          showTitle: true,
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader({required Rx<UserModel?> userModelGlobal, required BuildContext context}) {
    log("userModelGlobal.value?.fullName = ${userModelGlobal.value?.fullName}");
    return Row(
      children: [
        Obx(
          () => CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                  userModelGlobal.value?.profileImage ?? dummyProfileUrl)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.profile, style: TextStyle(color: Colors.grey)),
            Obx(
              () => Text("${AppLocalizations.of(context)!.hi}, ${userModelGlobal.value?.fullName ?? ""}",
                  style: TextStyle(color: Colors.green ,fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {
            Get.to(() => NotificationsScreen(),binding: NotificationsBinding(),);
          },
        ),
      ],
    );
  }


  Widget _buildSection(String title, Widget content, {required BuildContext context,
      bool showViewAll = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocalizationHelper.getLocalizedServiceName(context, title),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (showViewAll)
              GestureDetector(
                  onTap: () {
                    Get.to(() => SelectCategoryScreen());
                  },
                  child: Text(AppLocalizations.of(context)!.viewAll,
                      style: TextStyle(color: Colors.green))),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildEventCards(context) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: services.length > 3 ? 3 : services.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Get.to(() => CategoryScreen(title: services[index]),
                    binding: CategoryBindings(), arguments: services[index]);
              },
              child: _buildEventCard(services[index],context));
        },
      ),
    );
  }

  Widget _buildEventCard(String title,context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kBorderColor),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonImageView(
            imagePath: Assets.imagesEvent1,
            fit: BoxFit.fill,
            height: 80,
            width: double.maxFinite,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(  LocalizationHelper.getLocalizedServiceName(context, title),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
             textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }

  Widget _buildSearchFilters({required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        showFilterBottomSheet(
          context,
          onApply: (selectedCity, selectedEvent, selectedDate) {
            controller.selectedCity = selectedCity;
            controller.selectedEvent = selectedEvent;
            controller.selectedDate = selectedDate;

            controller.onApplyFilter(context);
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.only(left: 12, right: 20),
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: kBorderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FilterButton(
              svgPath: Assets.imagesMenu,
              label: AppLocalizations.of(context)!.event,
            ),
            FilterButton(
              svgPath: Assets.imagesCalendar,
              label: AppLocalizations.of(context)!.date,
            ),
            FilterButton(
              svgPath: Assets.imagesCity,
              label: AppLocalizations.of(context)!.city,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard({required String serviceType, required BuildContext context}) {
    return (controller.advertisedServices.containsKey(serviceType) &&
            controller.advertisedServices[serviceType] != null)
        ? BaseCarousel(
                    
          height: 136,
            items: List.generate(
              
            (controller.advertisedServices[serviceType] as List).length,
            (index) {
              ServiceModel serviceModel =
                  controller.advertisedServices[serviceType][index];

              return Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFFE8F5E9),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                CommonImageView(
                                  radius: 100,
                                  height: 30,
                                  width: 30,
                                  url: serviceModel.user?.profileImage ??
                                      dummyProfileUrl,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text: serviceModel.user?.fullName ?? '',
                                      size: 13,
                                      weight: FontWeight.w600,
                                      textOverflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    // MyText(
                                    //   text: serviceModel.user?.location ?? '',
                                    //   size: 12,
                                    //   color: kGreyColor1,
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            MyText(
                              text: "${serviceModel.about}",
                              textOverflow: TextOverflow.ellipsis,
                              size: 12,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 6),
                            ElevatedButton(
                              
                              onPressed: () {
                                Get.to(() => CategoryDetailScreen(
                                    serviceModel: serviceModel,isBooking: true,));
                              },
                              style: ElevatedButton.styleFrom(
                              
                                  backgroundColor: Colors.green.shade300),
                              child: Text(
                                AppLocalizations.of(context)!.bookNow,
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: CommonImageView(
                          radius: 10,
                          height: 124,
                          width: 124,
                          url: serviceModel.serviceImage ?? dummyProfileUrl,
                          fit: BoxFit.fill),
                    )
                  ],
                ),
              );
            },
          ))
        : Container(
            height: 150,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xFFE8F5E9),
            ),
            padding: const EdgeInsets.all(12),
            child: Center(
              child: MyText(text: AppLocalizations.of(context)!.noAdvertisedServiceAvailable),
            ));
  }
}
