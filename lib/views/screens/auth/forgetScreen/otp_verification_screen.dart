import 'package:event_connect/controllers/authControllers/auth_controller.dart';
import 'package:event_connect/views/widget/appBars/custom_app_bar.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

import '../../../../main_packages.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 20,
        color: kBlackColor1,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
        color: kWhiteColor,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: kPrimaryColor, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: kPrimaryColor.withOpacity(0.1),
        border: Border.all(color: kPrimaryColor),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.red, width: 2),
      borderRadius: BorderRadius.circular(12),
    );

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBar(
        title: "Verify Email",
        // showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
                Icons.email_outlined,
                size: 40,
                color: kPrimaryColor,
              ),
            ),
            
            SizedBox(height: 32),
            
            // Title
            Text(
              "Enter Verification Code",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kBlackColor1,
              ),
            ),
            
            SizedBox(height: 16),
            
            // Description
            Obx(() => Text(
              "We've sent a 6-digit verification code to\n${authController.userEmail.value}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: kBlackColor1.withOpacity(0.7),
                height: 1.5,
              ),
            )),
            
            SizedBox(height: 40),
            
            // OTP Input
            Pinput(
              controller: authController.otpController,
              length: 6,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              submittedPinTheme: submittedPinTheme,
              errorPinTheme: errorPinTheme,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              cursor: Container(
                width: 2,
                height: 24,
                color: kPrimaryColor,
              ),
              onCompleted: (pin) {
                // Auto verify when all digits are entered
                authController.verifyOtp();
              },
              validator: (value) {
                if (value == null || value.length != 6) {
                  return 'Please enter a valid 6-digit code';
                }
                return null;
              },
            ),
            
            SizedBox(height: 32),
            
            // Resend Code
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive the code? ",
                  style: TextStyle(
                    fontSize: 14,
                    color: kBlackColor1.withOpacity(0.7),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Resend OTP
                    authController.sendForgotPasswordEmail();
                  },
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      fontSize: 14,
                      color: kPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 150),
            
            // Verify Button
            MyButton(
              onTap: () {
                authController.verifyOtp();
              },
              buttonText: "Verify Code",
              fontColor: kWhiteColor,
              radius: 100,
              backgroundColor: kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}