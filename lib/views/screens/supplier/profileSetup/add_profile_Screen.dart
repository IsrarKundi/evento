import 'dart:io';

import 'package:event_connect/controllers/suppierControllers/profile_setup_controler.dart';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/core/utils/validators.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/custom_textfield.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProfileScreen extends StatefulWidget {

  final bool isEdit;
  AddProfileScreen({super.key, this.isEdit=false});

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {

  final ProfileSetupController controller = Get.find<ProfileSetupController>();

  @override
  void initState() {
    if(widget.isEdit){
      controller.nameController.text = userModelGlobal.value?.fullName??"";
    }
    super.initState();
  }


  final GlobalKey<FormState> _formKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Obx(()=>

                        controller.imagePath.isNotEmpty?
                        CommonImageView(
                          radius: 100,
                          height: 110,
                          width: 115,
                          file: File(controller.imagePath.value),
                          // imagePath: Assets.imagesAvatar,
                        ):
                        CommonImageView(
                        radius: 100,
                        height: 110,
                        width: 115,
                        url: controller.profileImageUrl.value,
                        // imagePath: Assets.imagesAvatar,
                      ),
                    ),
                    Positioned(
                        bottom: -10,
                        right: 0,
                        child: GestureDetector(
                            onTap: () {
                              ImagePickerService.instance
                                  .openProfilePickerBottomSheet(
                                context: context,
                                onCameraPick: () {
                                  controller.selectImage(isCamera: true);
                                },
                                onGalleryPick: () {
                                  controller.selectImage();
                                },
                              );
                              print("Button pressed");
                            },
                            child:
                                CircleAvatar(child: Icon(Icons.add_a_photo))))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: controller.nameController,
                  validator: (value) => ValidationService.instance.emptyValidator(value, context),
                  labelText: AppLocalizations.of(context)!.fullName,
                  hintText: AppLocalizations.of(context)!.enterName,
                  radius: 100,
                  bottom: 10,
                ),
                CustomTextField(
                  controller: controller.emailController,
                  readOnly: true,
                  labelText: AppLocalizations.of(context)!.email,
                  hintText: AppLocalizations.of(context)!.enterEmail,
                  radius: 100,
                  bottom: 10,
                ),
                CustomTextField(
                  controller: controller.phoneNoController,
                   validator: (value) => ValidationService.instance.emptyValidator(value, context),
                  keyboardType: TextInputType.numberWithOptions(),
                  labelText: AppLocalizations.of(context)!.phoneNumber,
                  hintText: AppLocalizations.of(context)!.enterPhoneNumber,
                  radius: 100,
                  bottom: 10,
                ),
                CustomTextField(
                  controller: controller.locationController,
                   validator: (value) => ValidationService.instance.emptyValidator(value, context),
                  labelText: AppLocalizations.of(context)!.address,
                  hintText: AppLocalizations.of(context)!.enterAddress,
                  radius: 100,
                  bottom: 10,
                ),
                CustomTextField(
                  controller: controller.languageController,
                validator: (value) => ValidationService.instance.emptyValidator(value, context),
                  labelText: AppLocalizations.of(context)!.language,
                  hintText: AppLocalizations.of(context)!.enterLanguage,
                  radius: 100,
                ),
                const SizedBox(
                  height: 30,
                ),
                MyButton(
                  onTap: () {

                    if (_formKey.currentState!.validate()) {

                      controller.addProfile(context: context);
                    }
                  },
                  buttonText: AppLocalizations.of(context)!.save,
                  radius: 100,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
