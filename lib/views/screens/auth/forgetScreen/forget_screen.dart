import 'package:event_connect/controllers/authControllers/auth_controller.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/views/widget/appBars/custom_app_bar.dart';
import 'package:event_connect/views/widget/custom_textfield.dart';
import 'package:event_connect/views/widget/my_button.dart';

import '../../../../main_packages.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.forgetPassword),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Header Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 40,
                  color: kPrimaryColor,
                ),
              ),
              
              SizedBox(height: 32),
              
              // Title
              Text(
                "Forgot Password?",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kBlackColor1,
                ),
              ),
              
              SizedBox(height: 16),
              
              // Description
              Text(
                "Don't worry! It happens. Please enter the email associated with your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: kBlackColor1.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
              
              SizedBox(height: 40),
              
              // Email Input Field with Error Handling
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    isRequired: true,
                    labelText: AppLocalizations.of(context)!.email,
                    radius: 100,
                    hintText: AppLocalizations.of(context)!.enterEmail,
                    controller: authController.forgotPasswordEmailController,
                    outlineBorderColor: authController.hasEmailError.value 
                        ? Colors.red 
                        : kPrimaryColor,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      // Clear error when user starts typing
                      if (authController.hasEmailError.value) {
                        authController.hasEmailError.value = false;
                        authController.emailErrorMessage.value = '';
                      }
                    },
                  ),
                  
                  // Error Message
                  if (authController.hasEmailError.value)
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 16),
                      child: Text(
                        authController.emailErrorMessage.value,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              )),
              
              SizedBox(height: 150),
              
              // Continue Button
              MyButton(
                onTap: () {
                  authController.sendForgotPasswordEmail();
                },
                buttonText: AppLocalizations.of(context)!.continueButton,
                fontColor: kWhiteColor,
                radius: 100,
                backgroundColor: kPrimaryColor,
              ),
              
              SizedBox(height: 20),
              
              // Back to Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remember your password? ",
                    style: TextStyle(
                      fontSize: 14,
                      color: kBlackColor1.withOpacity(0.7),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 14,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}