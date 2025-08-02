import 'package:event_connect/controllers/authControllers/auth_controller.dart';
import 'package:event_connect/views/widget/appBars/custom_app_bar.dart';
import 'package:event_connect/views/widget/custom_textfield.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/l10n/app_localizations.dart';

import '../../../../main_packages.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBar(
        title: "Reset Password",
        // showBackButton: false, // Prevent going back to OTP screen
      ),
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
                  Icons.lock_reset_outlined,
                  size: 40,
                  color: kPrimaryColor,
                ),
              ),
              
              SizedBox(height: 32),
              
              // Title
              Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kBlackColor1,
                ),
              ),
              
              SizedBox(height: 16),
              
              // Description
              Text(
                "Your new password must be different from\npreviously used passwords",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: kBlackColor1.withOpacity(0.7),
                  height: 1.5,
                ),
              ),
              
              SizedBox(height: 40),
              
              // New Password Field
              Obx(() => CustomTextField(
                isRequired: true,
                labelText: "New Password",
                hintText: "Enter new password",
                controller: authController.newPasswordController,
                outlineBorderColor: kPrimaryColor,
                radius: 100,
                // isPassword: true,
                // obscureText: authController..value,
                // suffixIcon: IconButton(
                //   onPressed: () {
                //     authController.isNewPasswordObsecure.value = 
                //         !authController.isNewPasswordObsecure.value;
                //   },
                //   icon: Icon(
                //     authController.isNewPasswordObsecure.value
                //         ? Icons.visibility_off
                //         : Icons.visibility,
                //     color: kPrimaryColor,
                //   ),
                ),
              ),
              
              SizedBox(height: 20),
              
              // Confirm Password Field
              Obx(() => CustomTextField(
                isRequired: true,
                labelText: "Confirm Password",
                hintText: "Confirm new password",
                controller: authController.confirmPasswordController,
                outlineBorderColor: kPrimaryColor,
                radius: 100,
                // isPassword: true,
                // obscureText: authController.isConfirmPasswordObsecure.value,
                // suffixIcon: IconButton(
                //   onPressed: () {
                //     authController.isConfirmPasswordObsecure.value = 
                //         !authController.isConfirmPasswordObsecure.value;
                //   },
                //   icon: Icon(
                //     authController.isConfirmPasswordObsecure.value
                //         ? Icons.visibility_off
                //         : Icons.visibility,
                //     color: kPrimaryColor,
                //   ),
                // ),
              )),
              
              SizedBox(height: 32),
              
              // Password Requirements
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: kPrimaryColor.withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Password must contain:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: kBlackColor1,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildPasswordRequirement("At least 6 characters"),
                    _buildPasswordRequirement("At least one uppercase letter"),
                    _buildPasswordRequirement("At least one lowercase letter"),
                    _buildPasswordRequirement("At least one number"),
                  ],
                ),
              ),
              
              SizedBox(height: 100),
              
              // Reset Password Button
              MyButton(
                onTap: () {
                  authController.resetPassword();
                },
                buttonText: "Reset Password",
                fontColor: kWhiteColor,
                radius: 100,
                backgroundColor: kPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPasswordRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: kPrimaryColor.withOpacity(0.7),
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: kBlackColor1.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}