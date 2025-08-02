import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/services/shared_preferences_services.dart';
import 'package:event_connect/core/constants/shared_preference_keys.dart';
import 'package:event_connect/views/screens/launch/splash_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = 'en'; // Default to English

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(),
              // App Logo
              CommonImageView(
                imagePath: Assets.imagesEventoLogo,
                height: 120,
              ),
              const SizedBox(height: 40),
              
              // Welcome text
              MyText(
                text: "Welcome to EventConnect",
                size: 24,
                weight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              MyText(
                text: "Please select your preferred language",
                size: 16,
                color: Colors.grey[600],
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Language options
              _buildLanguageOption(
                flag: '🇺🇸',
                language: 'English',
                code: 'en',
              ),
              const SizedBox(height: 16),
              
              _buildLanguageOption(
                flag: '🇷🇴',
                language: 'Română',
                code: 'ro',
              ),
              
              const Spacer(),
              
              // Continue button
              MyButton(
                onTap: _onContinue,
                buttonText: "Continue",
                radius: 100,
                fontColor: Colors.black,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required String flag,
    required String language,
    required String code,
  }) {
    bool isSelected = selectedLanguage == code;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = code;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor.withOpacity(0.1) : Colors.white,
          border: Border.all(
            color: isSelected ? kPrimaryColor : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MyText(
                text: language,
                size: 18,
                weight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: kPrimaryColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _onContinue() async {
    // Save selected language to shared preferences
    await SharedPreferenceService.instance.saveSharedPreferenceString(
      key: SharedPrefKeys.selectedLanguage,
      value: selectedLanguage,
    );
    
    // Update app locale
    Get.updateLocale(Locale(selectedLanguage));
    
    // Navigate to splash screen
    Get.offAll(() => const SplashScreen());
  }
} 