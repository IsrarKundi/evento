import 'package:event_connect/controllers/authControllers/auth_controller.dart';
import 'package:event_connect/core/utils/validators.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/views/screens/auth/login_screen.dart';
import 'package:event_connect/views/screens/auth/select_role_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import '../../widget/common_image_view_widget.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/my_button.dart';


class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  AuthController controller = Get.find<AuthController>();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesEventoLogo,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: controller.fullNameController,
                      validator: (value) => ValidationService.instance.emptyValidator(value, context),
                      isRequired: true,
                      labelText: AppLocalizations.of(context)!.fullName,
                      hintText: AppLocalizations.of(context)!.enterName,
                      radius: 100,
                      outlineBorderColor: kPrimaryColor,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      controller: controller.emailController,
                      validator: (value) => ValidationService.instance.emailValidator(value, context),
                      isRequired: true,
                      labelText: AppLocalizations.of(context)!.email,
                      hintText: AppLocalizations.of(context)!.enterEmail,
                      radius: 100,
                      outlineBorderColor: kPrimaryColor,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(()=>
                        CustomTextField(
                          obscureText: controller.isPasswordObsecure.value ,
                        haveSuffixIcon: true,
                        suffixWidget:GestureDetector(
                            onTap: () {
                              controller.isPasswordObsecure.value = !controller.isPasswordObsecure.value;
                            },
                            child: Icon(controller.isPasswordObsecure.value?Icons.visibility_off:Icons.visibility,color: Colors.black,)),
                        controller: controller.passwordController,
                        validator: (value) => ValidationService.instance.validatePassword(value, context),
                        isRequired: true,
                        labelText: AppLocalizations.of(context)!.password,
                        hintText: AppLocalizations.of(context)!.enterPassword,
                        radius: 100,
                        outlineBorderColor: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(()=>
                        CustomTextField(
                          obscureText: controller.isPasswordAObsecure.value,
                        haveSuffixIcon: true,
                        suffixWidget:GestureDetector(
                            onTap: () {
                              controller.isPasswordAObsecure.value = !controller.isPasswordAObsecure.value;
                            },
                            child: Icon(controller.isPasswordAObsecure.value?Icons.visibility_off:Icons.visibility,color: Colors.black,)),
                        controller: controller.againPasswordController,
                        validator: (value) {
                         return  ValidationService.instance.validateMatchPassword(value!, controller.passwordController.text, context);
                        },
                        isRequired: true,
                        labelText: AppLocalizations.of(context)!.confirmPassword,
                        hintText: AppLocalizations.of(context)!.enterPassword,
                        radius: 100,
                        outlineBorderColor: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    MyButton(
                        fontColor: Colors.black,
                        radius: 100,
                        onTap: () {

                          if(_formKey.currentState!.validate()){
                            controller.signup();
                          }

                        },
                        buttonText: AppLocalizations.of(context)!.signup),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(
                            style: const TextStyle(
                                color: kBlackColor1,
                                fontFamily: AppFonts.Poppins,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                            children: [
                          TextSpan(text: AppLocalizations.of(context)!.alreadyHaveAccount),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.off(() => LoginScreen());
                                },
                              text: " ${AppLocalizations.of(context)!.signin}",
                              style: const TextStyle(color: kPrimaryColor))
                        ]))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
