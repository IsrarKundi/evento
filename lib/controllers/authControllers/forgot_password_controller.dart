import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgetPasswordController extends ChangeNotifier {
  final emailController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<bool> sendResetEmail() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final email = emailController.text.trim();
    if (email.isEmpty) {
      errorMessage = "Email cannot be empty";
      isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final res = await Supabase.instance.client.auth.resetPasswordForEmail(email);
      isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = "An unexpected error occurred";
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}