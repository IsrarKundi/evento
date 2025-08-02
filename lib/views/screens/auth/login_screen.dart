import 'package:event_connect/controllers/authControllers/auth_controller.dart';
import 'package:event_connect/core/utils/validators.dart';
import  'package:event_connect/main_packages.dart';
import 'package:event_connect/views/screens/auth/forgetScreen/forget_screen.dart';
import 'package:event_connect/views/screens/auth/signup_screen.dart';
import 'package:event_connect/views/screens/bottomNavBar/bottom_nav_screen.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/custom_textfield.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widget/buttons/social_button.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthController controller = Get.find<AuthController>();

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {

    super.initState();
    controller.clearFields();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [ 
                    CommonImageView(
                      imagePath: Assets.imagesEventoLogo,
                    ),
                    const SizedBox(height: 20,),
                    CustomTextField(
                      controller: controller.emailController,
                      validator: (value) => ValidationService.instance.emailValidator(value, context),
                      isRequired: true,
                      labelText: AppLocalizations.of(context)!.email,
                      hintText: AppLocalizations.of(context)!.enterEmail,
                      radius: 100,
                     outlineBorderColor: kPrimaryColor,
                    ),
                    const SizedBox(height: 20,),
                    Obx(()=>
                        CustomTextField(
                          haveSuffixIcon: true,
                          suffixWidget:GestureDetector(
                              onTap: () {
                                controller.isPasswordObsecure.value = !controller.isPasswordObsecure.value;
                              },
                              child: Icon(controller.isPasswordObsecure.value?Icons.visibility_off:Icons.visibility,color: Colors.black,)),
                        obscureText: controller.isPasswordObsecure.value,
                        controller: controller.passwordController,
                        validator: (value) => ValidationService.instance.emptyValidator(value, context),
                        isRequired: true,
                        labelText: AppLocalizations.of(context)!.password,
                        hintText: AppLocalizations.of(context)!.enterPassword,
                        radius: 100,
                        outlineBorderColor: kPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: (){
                            Get.to(()=>ForgetScreen());
                          },

                          child: MyText(text: AppLocalizations.of(context)!.forgetPasswordQuestion,weight: FontWeight.w600,size: 14,)),
                    ),
                    const SizedBox(height: 20,),
                    MyButton(
                      fontColor: Colors.black,
                        radius: 100,
                        onTap: () {

                        if(_formKey.currentState!.validate()){
                            controller.signIn();
                        }

                    }, buttonText: AppLocalizations.of(context)!.signin),
                    const SizedBox(height: 20,),
                    MyText(text: AppLocalizations.of(context)!.orContinueWith),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SocialButton(),
                        SizedBox(width: Get.width*0.05,),
                         SocialButton(buttonText: AppLocalizations.of(context)!.google,iconPath: Assets.imagesGoogle,
                        onTap: () async {
                           await controller.googleSignIn();
                          // print("Response google = ${response?.user!.email}");
                        },

                        )
                      ],
                    ),
                    const SizedBox(height: 20,),
                    RichText(text:  TextSpan(
                      style: const TextStyle(
                        color: kBlackColor1,
                        fontFamily: AppFonts.Poppins,
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
                      children:[
                        TextSpan(text: AppLocalizations.of(context)!.dontHaveAccount),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap=(){
                            Get.find<AuthController>().clearFields();
                            Get.to(()=>SignupScreen());
                        },
                            text: " ${AppLocalizations.of(context)!.registerNow}",style: const TextStyle(
                          color: kPrimaryColor
                        ))
                      ]
                    ))
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



