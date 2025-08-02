import 'dart:developer';

import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/constants/supabase_constants.dart';
import '../snackbar_service/snackbar.dart';


class SupabaseAuthService extends SupabaseConstants {
  // Private constructor

  SupabaseAuthService.protected();

  static final SupabaseAuthService _instance = SupabaseAuthService.protected();

  static SupabaseAuthService get instance => _instance;
  /// Sign Up with Email and Password
  Future<AuthResponse?> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {

      log("signUp called");
      final response = await supabase.auth.signUp(email: email, password: password);
      if (response.user != null) {
        log("signUp called $response ${response.user?.id}");

        await supabase.from('users').insert({
          'id': response.user!.id,
          ...userData,
        });
      }
      return response;
    } on AuthException catch (e) {

      log("Exception e ${e.message}");
      throw Exception(e.message);
    } catch (e) {
      log("Exception e ${e.toString()}");
      throw Exception('Unexpected error: $e');
    }
  }

  ///  with Email and Password
  Future<(bool, AuthResponse?, String?)> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      log(" successful: ${response.user}");
      return (true, response, null);
    } on AuthException catch (e) {
      showFailureSnackbar(title: "Sign In Failed", message: e.message);
      log("AuthException during sign-in: $e");
      return (false, null, e.message);
    } catch (e, stackTrace) {
      log("Unexpected exception during sign-in: $e", stackTrace: stackTrace);
      return (false, null, e.toString());
    }
  }

  Future<(AuthResponse?,bool isExist)> googleSignIn() async {
   try{

     const webClientId = '156492362514-g2ddf304g6ise7gn1stam38q4i8gpi5k.apps.googleusercontent.com';


     const iosClientId = '156492362514-k49ob28n1fj7bv62sf9nuqmaug3a6geg.apps.googleusercontent.com';

     // Google sign in on Android will work without providing the Android
     // Client ID registered on Google Cloud.

     final GoogleSignIn googleSignIn = GoogleSignIn(
       scopes: ['email','profile'],
       clientId: iosClientId,
       serverClientId: webClientId,
     );
     final googleUser = await googleSignIn.signIn();
     final googleAuth = await googleUser!.authentication;
     final accessToken = googleAuth.accessToken;
     final idToken = googleAuth.idToken;

     if (accessToken == null) {
       throw 'No Access Token found.';
     }
     if (idToken == null) {
       throw 'No ID Token found.';
     }

     AuthResponse response = await SupabaseAuthService.instance.supabase.auth.signInWithIdToken(
       provider: OAuthProvider.google,
       idToken: idToken,
       accessToken: accessToken,
     );
     bool isExist = await SupabaseCRUDService.instance.isDocumentExist(tableName: usersTable, id: response.user!.id);
     return (response,isExist);
   }on AuthException catch (e) {
     showFailureSnackbar(title: "Sign In Failed", message: e.message);
     log("AuthException during sign-in: $e");
     return (null,false);
   } catch (e, stackTrace) {
     log("Unexpected exception during sign-in: $e", stackTrace: stackTrace);
     return (null,false);
   }
  }
Future<(AuthResponse?, bool isExist)> appleSignIn() async {
  try {
    final response = await Supabase.instance.client.auth.signInWithOAuth(
      OAuthProvider.apple,
    );

    // Check auth session
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      throw 'Apple sign-in failed or canceled';
    }

    bool isExist = await SupabaseCRUDService.instance.isDocumentExist(
      tableName: usersTable,
      id: Supabase.instance.client.auth.currentUser!.id,
    );

    return (AuthResponse(session: session), isExist);
  } catch (e) {
    log("Apple Sign-In error: $e");
    return (null, false);
  }
}
  // Future<(AuthResponse?, bool isExist)> appleSignIn() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     final idToken = credential.identityToken;
  //     if (idToken == null) {
  //       throw 'No ID Token found.';
  //     }

  //     AuthResponse response = await SupabaseAuthService.instance.supabase.auth.signInWithIdToken(
  //       provider: OAuthProvider.apple,
  //       idToken: idToken,
  //     );
      
  //     bool isExist = await SupabaseCRUDService.instance.isDocumentExist(tableName: usersTable, id: response.user!.id);
  //     return (response, isExist);
  //   } on AuthException catch (e) {
  //     showFailureSnackbar(title: "Apple Sign In Failed", message: e.message);
  //     log("AuthException during Apple sign-in: $e");
  //     return (null, false);
  //   } catch (e, stackTrace) {
  //     log("Unexpected exception during Apple sign-in: $e", stackTrace: stackTrace);
  //     return (null, false);
  //   }
  // }

  /// Sign Out
  Future<bool> signOut() async {
    try {
      await supabase.auth.signOut();
      log("Sign out successful");
      return true;
    } on AuthException catch (e) {
      showFailureSnackbar(title: "Sign Out Failed", message: e.message);
      log("AuthException during sign-out: $e");
      return false;
    } catch (e, stackTrace) {
      log("Unexpected exception during sign-out: $e", stackTrace: stackTrace);
      return false;
    }
  }

  /// Send Password Reset Email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      log("Password reset email sent to $email");
      return true;
    } on AuthException catch (e) {
      showFailureSnackbar(title: "Password Reset Failed", message: e.message);
      log("AuthException during password reset: $e");
      return false;
    } catch (e, stackTrace) {
      log("Unexpected exception during password reset: $e", stackTrace: stackTrace);
      return false;
    }
  }

  /// Update User Password
  Future<bool> updatePassword(String newPassword) async {
    try {
      await supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      log("Password updated successfully");
      return true;
    } on AuthException catch (e) {
      showFailureSnackbar(title: "Update Password Failed", message: e.message);
      log("AuthException during password update: $e");
      return false;
    } catch (e, stackTrace) {
      log("Unexpected exception during password update: $e", stackTrace: stackTrace);
      return false;
    }
  }

  /// Get Current User
  User? getCurrentUser() {
    try {
      return supabase.auth.currentUser;
    } catch (e, stackTrace) {
      log("Error retrieving current user: $e", stackTrace: stackTrace);
      return null;
    }
  }

  /// Listen to Authentication Changes
  Stream<AuthState> authStateChanges() {
    return supabase.auth.onAuthStateChange;
  }

  /// Delete User Account
  Future<bool> deleteUser() async {
    try {
      await supabase.auth.admin.deleteUser(
        supabase.auth.currentUser?.id ?? "",
      );
      log("User account deleted successfully");
      return true;
    } on AuthException catch (e) {
      showFailureSnackbar(title: "Delete User Failed", message: e.message);
      log("AuthException during delete user: $e");
      return false;
    } catch (e, stackTrace) {
      log("Unexpected exception during delete user: $e", stackTrace: stackTrace);
      return false;
    }
  }

  void showFailureSnackbar({
    required String title,
    required String message,
    int duration = 3,
  }) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      backgroundColor: Colors.black,
      colorText: Colors.white,
      leftBarIndicatorColor: Colors.red,
      progressIndicatorBackgroundColor: Colors.red,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 800),
      snackPosition: SnackPosition.BOTTOM,
      borderRadius: 5.0,
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: const Text('Dismiss'),
      ),
      icon: const Icon(Icons.warning, color: Colors.red),
    );
  }
}
