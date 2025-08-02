import 'dart:developer';

import 'package:event_connect/controllers/authControllers/auth_controller.dart';
import 'package:event_connect/core/constants/shared_preference_keys.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/models/userModel/user_model.dart';
import 'package:event_connect/services/shared_preferences_services.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/auth/login_screen.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../generated/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    handleNavigation();
    super.initState();
  }

  handleNavigation() async {
    Get.find<AuthController>().clearFields();
    await Future.delayed(Duration(seconds: 2));
    bool isLoggedIn = await SharedPreferenceService.instance
            .getSharedPreferenceBool(SharedPrefKeys.loggedIn) ??
        false;

    User? user = SupabaseCRUDService.instance.getCurrentUser();
    log("isLoggedIn = $isLoggedIn $user");
    if (user != null && isLoggedIn) {
     Map<String,dynamic>? document =await SupabaseCRUDService.instance.readSingleDocument(
          tableName: SupabaseConstants().usersTable, id: user.id);
      if(document!=null){
        UserModel userModel = UserModel.fromJson(document);

        Get.find<AuthController>().handleNavigation(userModel: userModel);

      }else{
        Get.off(() => LoginScreen());
      }

    }else{
      Get.off(() => LoginScreen());
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CommonImageView(imagePath: Assets.imagesEventoLogo),
            )
          ],
        ),
      ),
    );
  }
}
