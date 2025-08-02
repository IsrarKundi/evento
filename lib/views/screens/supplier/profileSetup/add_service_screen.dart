import 'dart:io';

import 'package:event_connect/controllers/suppierControllers/add_service_controller.dart';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/core/utils/validators.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/views/widget/bottomSheets/city_selector_bottom_sheet.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/custom_textfield.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:event_connect/main_packages.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../../../core/utils/app_lists.dart';
import '../../../../core/utils/localization_helper.dart';
import '../../../widget/my_button.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final AddServiceController controller = Get.find<AddServiceController>();
  final GlobalKey<FormState> serviceFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Form(
          key: serviceFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload box
              GestureDetector(
                onTap: () {
                  ImagePickerService.instance.openProfilePickerBottomSheet(
                    context: context,
                    onCameraPick: () {
                      controller.pickImage(isCamera: true);
                    },
                    onGalleryPick: () {
                      controller.pickImage();
                    },
                  );
                },
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color(0xFFDFF6DA),
                      border: DashedBorder.fromBorderSide(
                          side: BorderSide(color: kPrimaryColor),
                          dashLength: 3)),
                  child: Obx(
                    () => controller.imagePath.isNotEmpty
                        ? CommonImageView(
                            fit: BoxFit.contain,
                            file: File(controller.imagePath.value),
                          )
                        : Center(
                            child: Icon(Icons.upload,
                                color: Colors.green.shade400),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Services & Amount
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                            text: AppLocalizations.of(context)!.services, size: 14, color: Colors.black87),
                        const SizedBox(height: 8),
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: PopupMenuButton<String>(
                              // borderRadius: BorderRadius.circular(42),
                              initialValue: controller.selectedService.value,
                              onSelected: (String value) {
                                controller.updateService(value: value);
                              },
                              color: kWhiteColor,
                              padding: EdgeInsets.zero,
                              // offset: const Offset(0, -2-0),
                              itemBuilder: (BuildContext context) {
                                return services.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  String service = entry.value;
                                  return PopupMenuItem<String>(
                                    value: service,
                                    
                                    height: 26, // Reduced height from default 48
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16, 
                                      vertical: 4, // Reduced vertical padding
                                    ),
                                    child: Text(
                                      LocalizationHelper.getLocalizedServices(context)[index],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  );
                                }).toList();
                              },
                              child: Container(
                                height: 48,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.selectedService.value.isNotEmpty
                                            ? LocalizationHelper.getLocalizedServices(context)[
                                                services.indexOf(controller.selectedService.value)]
                                            : AppLocalizations.of(context)!.services,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: controller.selectedService.value.isNotEmpty
                                              ? Colors.black87
                                              : Colors.grey.shade600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(text: AppLocalizations.of(context)!.amount, size: 14, color: Colors.black87),
                        const SizedBox(height: 8),
                        Column(
                          children: [
                            Container(
                              height: 55,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                children: [
                                  MyText(
                                    paddingBottom: 3,
                                    text: "LEI",
                                    size: 18,
                                    weight: FontWeight.w700,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      // validator: ValidationService
                                      //     .instance.emptyValidator,
                                      controller: controller.amountController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "0",
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(children: [
                Spacer(),
                MyText(
                  text: AppLocalizations.of(context)!.perHour,
                ),
                SizedBox(
                  width: 10,
                ),
                Obx(
                  () => CupertinoCheckbox(
                    activeColor: kPrimaryColor,
                    value: controller.perHour.value,
                    onChanged: (value) {
                      controller.perHour.value=value??false;

                    },
                  ),
                )
              ]),

              Obx(
                () => CustomTextField(
                  hintText: AppLocalizations.of(context)!.selectCity,
                  controller: controller.locationController.value,
                  onTextFieldTap: () {
                    showCityPicker(
                      context,
                      romaniaCities,
                      (city) {
                        controller.locationController.value.text = city;
                      },
                    );
                  },
                  readOnly: true,
                  isUseLebelText: true,
                  labelText: AppLocalizations.of(context)!.location,
                ),
              ),
              const SizedBox(height: 24),

              // Write about service
              MyText(
                  text: AppLocalizations.of(context)!.writeAboutServices,
                  size: 14,
                  color: Colors.black87),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  validator: (value) => ValidationService.instance.emptyValidator(value, context),
                  controller: controller.serviceDescController,
                  maxLines: 8,
                  decoration: InputDecoration.collapsed(
                    hintText: AppLocalizations.of(context)!.describeService,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  onTap: () {
                    if (serviceFormKey.currentState!.validate()) {

                      // if(controller.amountController.text.isEmpty){
                      //   CustomSnackBars.instance.showInfoSnackbar(title: "Failed", message: "Please add amount");
                      // }
                      // else{
                        controller.uploadService();

                      // }
                    }
                  },
                  buttonText: AppLocalizations.of(context)!.save,
                  radius: 100,
                  fontColor: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}