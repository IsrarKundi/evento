import 'dart:developer';

import 'package:event_connect/core/bindings/bindings.dart';
import 'package:event_connect/core/constants/shared_preference_keys.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/core/enums/user_role.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/userModel/user_model.dart';
import 'package:event_connect/services/onesignalNotificationService/one_signal_notification_service.dart';
import 'package:event_connect/services/shared_preferences_services.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supabase_auth_service.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/auth/forgetScreen/congrats_screen.dart';
import 'package:event_connect/views/screens/auth/forgetScreen/otp_verification_screen.dart';
import 'package:event_connect/views/screens/auth/forgetScreen/reset_password_screen.dart';
import 'package:event_connect/views/screens/bottomNavBar/bottom_nav_screen.dart';
import 'package:event_connect/views/screens/supplier/homeScreen/home_screen.dart';
import 'package:event_connect/views/widget/custom_dialog_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../views/screens/auth/select_role_screen.dart';
import '../../views/screens/supplier/membership/memborship_screen.dart';
import '../../views/screens/supplier/profileSetup/main_profile_setup_screen.dart';

class AuthController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController againPasswordController = TextEditingController();
  TextEditingController forgotPasswordEmailController = TextEditingController();
  
  RxBool isPasswordObsecure = true.obs;
  RxBool isPasswordAObsecure = true.obs;
  signup() async {
    DialogService.instance
        .showProgressDialog(context: globalNavKey.currentState!.context);
    AuthResponse? response = await SupabaseAuthService.instance.signUp(
        email: emailController.text,
        password: passwordController.text,
        userData: UserModel(
          isRoleSelected: false,
          email: emailController.text,
          fullName: fullNameController.text,
          signupType: "email",
          profileImage: dummyProfileUrl
        ).toJson());

    DialogService.instance
        .hideProgressDialog(context: globalNavKey.currentState!.context);
    if (response != null) {
      SupabaseCRUDService.instance.getUserDataStream(
          userId: SupabaseCRUDService.instance.supabase.auth.currentUser!.id);
      Get.to(() => SelectUserTypeScreen());
    }
  }

  signIn() async {
    BuildContext context = globalNavKey.currentState!.context;
    DialogService.instance.showProgressDialog(context: context);
    var result = await SupabaseCRUDService.instance
        .signIn(email: emailController.text, password: passwordController.text.trim());
    if (result.$1 == true) {
      Map<String, dynamic>? document = await SupabaseCRUDService.instance
          .readSingleDocument(
              tableName: SupabaseConstants().usersTable,
              id: result.$2!.user!.id);
      DialogService.instance.hideProgressDialog(context: context);
      if (document != null) {
        UserModel userModel = UserModel.fromJson(document);

        handleNavigation(userModel: userModel);
      }
    } else {
      log("Else called = ${result.$3}");
      DialogService.instance.hideProgressDialog(context: context);

      // CustomSnackBars.instance
      //     .showFailureSnackbar(title: "Failed", message: "${result.$3}");
      //
    }
  }
  Future googleSignIn() async {

    BuildContext context = globalNavKey.currentState!.context;
    DialogService.instance
        .showProgressDialog(context: globalNavKey.currentState!.context);

    var response = await SupabaseAuthService.instance.googleSignIn();
  print("GoogleSignin isExist = ${response.$2}");
DialogService.instance.hideProgressDialog(context: context);
  if(response.$1!=null){

 if(response.$2==true){
   Map<String, dynamic>? document = await SupabaseCRUDService.instance
       .readSingleDocument(
       tableName: SupabaseConstants().usersTable,
       id: response.$1!.user!.id);
   DialogService.instance.hideProgressDialog(context: context);
   if (document != null) {
     UserModel userModel = UserModel.fromJson(document);

     handleNavigation(userModel: userModel);
   }
 }else{
   DialogService.instance
       .showProgressDialog(context: globalNavKey.currentState!.context);

   var userData = UserModel(
       isRoleSelected: false,
       email: response.$1!.user!.email,
       signupType: "google",
       profileImage: dummyProfileUrl
   ).toJson();

   await SupabaseAuthService.instance.supabase.from('users').insert({
     'id': response.$1!.user!.id,
     ...userData,
   });

   DialogService.instance
       .hideProgressDialog(context: globalNavKey.currentState!.context);
   SupabaseCRUDService.instance.getUserDataStream(
       userId: SupabaseCRUDService.instance.supabase.auth.currentUser!.id);
   Get.to(() => const SelectUserTypeScreen(isSocial: true,));
 }


  }else{
    CustomSnackBars.instance.showFailureSnackbar(title: "Failed", message: "Error While Google Signin");
  }

  }

  Future appleSignIn() async {
    BuildContext context = globalNavKey.currentState!.context;
    DialogService.instance
        .showProgressDialog(context: globalNavKey.currentState!.context);

    var response = await SupabaseAuthService.instance.appleSignIn();
    print("AppleSignin isExist = ${response.$2}");
    DialogService.instance.hideProgressDialog(context: context);
    
    if(response.$1 != null) {
      if(response.$2 == true) {
        Map<String, dynamic>? document = await SupabaseCRUDService.instance
            .readSingleDocument(
            tableName: SupabaseConstants().usersTable,
            id: response.$1!.user!.id);
        DialogService.instance.hideProgressDialog(context: context);
        if (document != null) {
          UserModel userModel = UserModel.fromJson(document);
          handleNavigation(userModel: userModel);
        }
      } else {
        DialogService.instance
            .showProgressDialog(context: globalNavKey.currentState!.context);

        var userData = UserModel(
            isRoleSelected: false,
            email: response.$1!.user!.email,
            signupType: "apple",
            profileImage: dummyProfileUrl
        ).toJson();

        await SupabaseAuthService.instance.supabase.from('users').insert({
          'id': response.$1!.user!.id,
          ...userData,
        });

        DialogService.instance
            .hideProgressDialog(context: globalNavKey.currentState!.context);
        SupabaseCRUDService.instance.getUserDataStream(
            userId: SupabaseCRUDService.instance.supabase.auth.currentUser!.id);
        Get.to(() => const SelectUserTypeScreen(isSocial: true,));
      }
    } else {
      CustomSnackBars.instance.showFailureSnackbar(title: "Failed", message: "Error While Apple Signin");
    }
  }

  updateUserRole({required UserRole userRole,bool isSocial =false}) async {
    BuildContext context = globalNavKey.currentState!.context;
    User? currentUser = SupabaseCRUDService.instance.getCurrentUser();
    DialogService.instance.showProgressDialog(context: context);
    if (currentUser != null) {
      await SupabaseCRUDService.instance.updateDocument(
          tableName: SupabaseConstants().usersTable,
          id: currentUser.id,
          data: {
            'is_role_selected': true,
            'user_type': userRole.name,
            if(isSocial) 'full_name': fullNameController.text
          });
      DialogService.instance.hideProgressDialog(context: context);
      SharedPreferenceService.instance.saveSharedPreferenceBool(
          key: SharedPrefKeys.loggedIn, value: true);

      if (userRole == UserRole.user) {

        Get.offAll(() => BottomNavScreen(),binding: UserHomeBindings());


      } else {

        Get.offAll(() => MembershipScreen(
          title: "Signup",
        ));

      }
    }
  }

  handleNavigation({required UserModel userModel}) {

    log("handleNavigation called");
    OneSignalNotificationService.instance.loginOneSignal();

    if (userModel.isRoleSelected == true) {
      SharedPreferenceService.instance.saveSharedPreferenceBool(
          key: SharedPrefKeys.loggedIn, value: true);

      SupabaseCRUDService.instance
          .getUserDataStream(userId: userModel.id ?? "");

      if (userModel.userType == UserRole.user.name) {
        Get.offAll(() => BottomNavScreen(),binding: UserHomeBindings());
      } else {
        if (userModel.isProfileSetup == true) {
          Get.offAll(() => HomeScreen(),binding: SupplierHomeBindings());
        } else {
          Get.offAll(() => MainProfileSetupScreen(),binding: ProfileSetupBinding());
        }
      }
    } else {
      Get.to(() => SelectUserTypeScreen(isSocial: userModel.signupType=='google',));
    }
  }


// Forgot Password Method


  Future<void> forgotPassword() async {
    if (forgotPasswordEmailController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please enter your email address",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!GetUtils.isEmail(forgotPasswordEmailController.text.trim())) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    BuildContext context = globalNavKey.currentState!.context;
    DialogService.instance.showProgressDialog(context: context);

    try {
      await SupabaseAuthService.instance.supabase.auth.resetPasswordForEmail(
        forgotPasswordEmailController.text.trim(),
        redirectTo: 'your-app://reset-password', // Replace with your app's deep link
      );

      DialogService.instance.hideProgressDialog(context: context);
      
      // Navigate to congrats screen on success
      Get.to(() => CongratsScreen());
      
      // Clear the email field
      forgotPasswordEmailController.clear();
      
    } catch (error) {
      DialogService.instance.hideProgressDialog(context: context);
      
      Get.snackbar(
        "Error",
        "Failed to send reset email. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
      
      log("Forgot password error: $error");
    }
  }
  


  // Forgot Password Methods

  Future<void> sendForgotPasswordEmail() async {
    // Reset error state
    hasEmailError.value = false;
    emailErrorMessage.value = '';

    if (forgotPasswordEmailController.text.trim().isEmpty) {
      hasEmailError.value = true;
      emailErrorMessage.value = "Please enter your email address";
      return;
    }

    if (!GetUtils.isEmail(forgotPasswordEmailController.text.trim())) {
      hasEmailError.value = true;
      emailErrorMessage.value = "Please enter a valid email address";
      return;
    }

    BuildContext context = globalNavKey.currentState!.context;
    DialogService.instance.showProgressDialog(context: context);

    try {
      // Check if email exists in database
      final response = await SupabaseCRUDService.instance.supabase
          .from(SupabaseConstants().usersTable)
          .select('email')
          .eq('email', forgotPasswordEmailController.text.trim())
          .maybeSingle();

      if (response == null) {
        DialogService.instance.hideProgressDialog(context: context);
        hasEmailError.value = true;
        emailErrorMessage.value = "Email not found in our records";
        return;
      }

      // Send reset password email
      await SupabaseAuthService.instance.supabase.auth.resetPasswordForEmail(
        forgotPasswordEmailController.text.trim(),
        // redirectTo: 'your-app://reset-password',
      );

      DialogService.instance.hideProgressDialog(context: context);
      
      // Store email for later use
      userEmail.value = forgotPasswordEmailController.text.trim();
      
      // Show success dialog
      showEmailSentDialog(context);
      
    } catch (error) {
      DialogService.instance.hideProgressDialog(context: context);
      hasEmailError.value = true;
      emailErrorMessage.value = "Failed to send reset email. Please try again.";
      log("Forgot password error: $error");
    }
  }

  void showEmailSentDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              Icon(
                Icons.email_outlined,
                size: 64,
                color: kPrimaryColor,
              ),
              SizedBox(height: 16),
              Text(
                "Email Sent!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kBlackColor1,
                ),
              ),
            ],
          ),
          content: Text(
            "We've sent a verification code to your email. Please check your inbox and enter the code to continue.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: kBlackColor1.withOpacity(0.7),
            ),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.to(() => OtpVerificationScreen());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> verifyOtp() async {
    if (otpController.text.trim().length != 6) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Invalid OTP",
        message: "Please enter a valid 6-digit OTP",
      );
      return;
    }

    BuildContext context = globalNavKey.currentState!.context;
    DialogService.instance.showProgressDialog(context: context);

    try {
      // Verify OTP with Supabase
      final response = await SupabaseAuthService.instance.supabase.auth.verifyOTP(
        email: userEmail.value,
        token: otpController.text.trim(),
        type: OtpType.recovery,
      );

      DialogService.instance.hideProgressDialog(context: context);

      if (response.user != null) {
        // OTP verified successfully
        CustomSnackBars.instance.showSuccessSnackbar(
          title: "Success",
          message: "OTP verified successfully",
        );
        
        // Clear OTP field
        otpController.clear();
        
        // Navigate to reset password screen
        Get.to(() => ResetPasswordScreen());
      } else {
        CustomSnackBars.instance.showFailureSnackbar(
          title: "Invalid OTP",
          message: "The OTP you entered is incorrect or expired",
        );
      }
    } catch (error) {
      DialogService.instance.hideProgressDialog(context: context);
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Verification Failed",
        message: "Invalid or expired OTP. Please try again.",
      );
      log("OTP verification error: $error");
    }
  }

  Future<void> resetPassword() async {
    if (newPasswordController.text.trim().isEmpty) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "Please enter a new password",
      );
      return;
    }

    if (newPasswordController.text.trim().length < 6) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "Password must be at least 6 characters long",
      );
      return;
    }

    if (newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "Passwords do not match",
      );
      return;
    }

    BuildContext context = globalNavKey.currentState!.context;
    DialogService.instance.showProgressDialog(context: context);

    try {
      // Update password
      await SupabaseAuthService.instance.supabase.auth.updateUser(
        UserAttributes(password: newPasswordController.text.trim()),
      );

      DialogService.instance.hideProgressDialog(context: context);

      // Clear all fields
      clearForgotPasswordFields();

      // Show success message and navigate to login
      CustomSnackBars.instance.showSuccessSnackbar(
        title: "Success",
        message: "Password reset successfully",
      );

      // Navigate back to login screen
      Get.offAllNamed('/login'); // Adjust route as needed
      
    } catch (error) {
      DialogService.instance.hideProgressDialog(context: context);
      CustomSnackBars.instance.showFailureSnackbar(
        title: "Error",
        message: "Failed to reset password. Please try again.",
      );
      log("Reset password error: $error");
    }
  }
  // TextEditingController forgotPasswordEmailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  
   // Forgot password flow variables
  RxBool hasEmailError = false.obs;
  RxString emailErrorMessage = ''.obs;
  RxString userEmail = ''.obs;
  void clearForgotPasswordFields() {
    forgotPasswordEmailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    hasEmailError.value = false;
    emailErrorMessage.value = '';
    userEmail.value = '';
  }

  clearFields() {
    fullNameController.clear();
    emailController.clear();
    passwordController.clear();
    againPasswordController.clear();
  }

  disposeFields() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    againPasswordController.dispose();
  }
}
