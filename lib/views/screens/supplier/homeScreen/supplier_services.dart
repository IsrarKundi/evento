import 'dart:developer';

import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/views/screens/categoryScreens/category_detail_screen.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/add_portfolio_screen.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/add_service_screen.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../controllers/suppierControllers/add_service_controller.dart';
import '../../../../main_packages.dart';

class SupplierServices extends StatelessWidget {
  SupplierServices({super.key});

  final AddServiceController controller = Get.find<AddServiceController>();

  Widget _buildGeneralService() {
    return Obx(
      () => Expanded(
        child: ListView.separated(
          itemCount: controller.generalServices.length,
          itemBuilder: (context, index) {
            log("_buildGeneralService general $index");
            ServiceModel serviceModel = controller.generalServices[index];
            return GestureDetector(
                onTap: () {
                  Get.to(
                      () => CategoryDetailScreen(
                        isAdvertisedButton: true,
                          isSupplierView: true,
                          serviceModel: serviceModel));
                },
                child: ServiceWidget(serviceModel: serviceModel));
          },
          separatorBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 3,
            color: kBorderColor,
          ),
        ),
      ),
    );
  }

  Widget _buildAdvertisedService() {
    return Obx(
      () => Expanded(
        child: ListView.separated(
          itemCount: controller.advertisedServices.length,
          itemBuilder: (context, index) {
            log("_buildGeneralService advertised $index");
            ServiceModel serviceModel = controller.advertisedServices[index];
            return GestureDetector(
                onTap: () {
                  Get.to(() => CategoryDetailScreen(
                        serviceModel: serviceModel,
                    isAdvertisedButton: true,
                        isSupplierView: true,
                      ));
                },
                child: ServiceWidget(serviceModel: serviceModel));
          },
          separatorBuilder: (context, index) => Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 3,
            color: kBorderColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: AppLocalizations.of(context)!.services),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 25, vertical: 25),
        child: MyButton(
            onTap: () {
              controller.clearFields();
              Get.to(() => AddServiceScreen());
            },
            fontColor: kBlackColor1,
            buttonText: AppLocalizations.of(context)!.addNewService),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Column(
          children: [
            ServicesToggle(
              onToggle: (isAdvertised) {
                controller.isAdvertisedSelected.value = isAdvertised;
              },
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() => controller.isAdvertisedSelected.value == true
                ? _buildAdvertisedService()
                : _buildGeneralService())
          ],
        ),
      ),
    );
  }
}

class ServicesToggle extends StatefulWidget {
  final Function(bool isAdvertised) onToggle;

  const ServicesToggle({super.key, required this.onToggle});

  @override
  State<ServicesToggle> createState() => _ServicesToggleState();
}

class _ServicesToggleState extends State<ServicesToggle> {
  bool isAdvertisedSelected = false;

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
                  isAdvertisedSelected = false;
                });
                widget.onToggle(false);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color:
                      isAdvertisedSelected ? Colors.transparent : kPrimaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.general,
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
                  isAdvertisedSelected = true;
                });
                widget.onToggle(true);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color:
                      isAdvertisedSelected ? kPrimaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context)!.advertised,
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
