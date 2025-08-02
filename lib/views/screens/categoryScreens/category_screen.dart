import 'dart:developer';

import 'package:event_connect/controllers/categoryControllers/category_controller.dart';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/utils/localization_helper.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/views/screens/categoryScreens/category_detail_screen.dart';
import 'package:event_connect/views/widget/bookingCards/booking_card.dart';
import 'package:event_connect/views/widget/bottomSheets/city_selector_bottom_sheet.dart';
import 'package:event_connect/views/widget/bottomSheets/date_filter_bottomsheet.dart';
import 'package:event_connect/views/widget/bottomSheets/price_bottom_sheet.dart';
import 'package:event_connect/views/widget/carousel/base_carousel.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';

import '../../../main.dart';
import '../../../main_packages.dart';
import '../../widget/buttons/filter_button.dart';
import '../../widget/common_image_view_widget.dart';

class CategoryScreen extends StatelessWidget {
  final String title;

  CategoryScreen({super.key, required this.title});

  final CategoryController controller = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: LocalizationHelper.getLocalizedServiceName(context, title)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    // buildSearchFilters(context: context),
                    SizedBox(height: 20),
                    Expanded( // Wrap the content in Expanded
                      child: Obx(
                        () => controller.serviceModels.isNotEmpty
                            ? Column(
                                children: [
                                  // Carousel section (fixed height)
                                  if (controller.advertisedModels.isNotEmpty)
                                    Column(
                                      children: [
                                        BaseCarousel(
                                          height: 136,
                                          items: List.generate(
                                            controller.advertisedModels.length,
                                            (index) {
                                              ServiceModel serviceModel = controller.advertisedModels[index];
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
                                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                CommonImageView(
                                                                  radius: 100,
                                                                  height: 30,
                                                                  width: 30,
                                                                  url: serviceModel.user?.profileImage ?? dummyProfileUrl,
                                                                ),
                                                                SizedBox(width: 5),
                                                                Expanded(
                                                                  child: MyText(
                                                                    text: serviceModel.user?.fullName ?? '',
                                                                    size: 13,
                                                                    weight: FontWeight.w600,
                                                                    textOverflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
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
                                                                    serviceModel: serviceModel,
                                                                    isBooking: true));
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
                                                    SizedBox(width: 10),
                                                    CommonImageView(
                                                        radius: 10,
                                                        height: 124,
                                                        width: 124,
                                                        url: serviceModel.serviceImage ?? dummyProfileUrl,
                                                        fit: BoxFit.fill)
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(height: 16), // Add spacing after carousel
                                      ],
                                    ),
                                  
                                  // ListView section (takes remaining space)
                                  Expanded( // This makes ListView take remaining space
                                    child: ListView.builder(
                                      itemCount: controller.filterApplied.value
                                          ? controller.filteredModels.length
                                          : controller.serviceModels.length,
                                      itemBuilder: (context, index) {
                                        ServiceModel serviceModel;

                                        if (controller.filterApplied.value) {
                                          serviceModel = controller.filteredModels[index];
                                        } else {
                                          serviceModel = controller.serviceModels[index];
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(() => CategoryDetailScreen(
                                                isBooking: true, serviceModel: serviceModel));
                                          },
                                          child: buildBookingCard(
                                              isPerhour: serviceModel.perHour ?? false,
                                              showBook: false,
                                              context: context,
                                              title: LocalizationHelper.getLocalizedServiceName(
                                                  context, serviceModel.serviceName ?? ""),
                                              location: serviceModel.user?.fullName ?? "",
                                              url: serviceModel.serviceImage,
                                              price: serviceModel.amount ?? ""),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: MyText(text: AppLocalizations.of(context)!.noServicesFound),
                              ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

Widget buildSearchFilters({required BuildContext context}) {
  final CategoryController controller = Get.find<CategoryController>();
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
              label: AppLocalizations.of(context)!.price,
              onTap: () {
                showPriceFilterBottomSheet(
                  context: context,
                  minPrice: 0,
                  maxPrice: 1000,
                  onApply: (min, max) {
                    controller.priceFilter.value = true;
                    controller.minPrice.value = min;
                    controller.maxPrice.value = max;
                    controller.applyFilters();
                  },
                );
              },
            ),
            FilterButton(
              svgPath: Assets.imagesCalendar,
              label: AppLocalizations.of(context)!.date,
              onTap: () {
                showDateFilterSheet(
                  context,
                  onApply: (start, end) {
                    log("Start Date = $start , endDate = $end");
                    controller.initialDate.value =
                        start ?? DateTime.now().subtract(Duration(days: 365));
                    controller.endDate.value =
                        end ?? DateTime.now().add(Duration(days: 365));
                    controller.applyFilters();
                  },
                );
              },
            ),
            FilterButton(
              svgPath: Assets.imagesCity,
              label: AppLocalizations.of(context)!.city,
              onTap: () {
                showCityPicker(
                  context,
                  ['all', ...romaniaCities],
                  (city) {
                    controller.selectedCity.value = city;
                    controller.applyFilters();
                  },
                );
              },
            )
          ],
        ),
      ),
    ],
  );
}