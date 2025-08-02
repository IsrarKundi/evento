import 'package:event_connect/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/services/shared_preferences_services.dart';
import 'package:event_connect/core/constants/shared_preference_keys.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';

class LanguageSelectorTile extends StatefulWidget {
  const LanguageSelectorTile({super.key});

  @override
  State<LanguageSelectorTile> createState() => _LanguageSelectorTileState();
}

class _LanguageSelectorTileState extends State<LanguageSelectorTile> {
  String currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
  }

  Future<void> _loadCurrentLanguage() async {
    final savedLanguage = await SharedPreferenceService.instance
        .getSharedPreferenceString(SharedPrefKeys.selectedLanguage);
    setState(() {
      currentLanguage = savedLanguage ?? 'en';
    });
  }

  String _getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ro':
        return 'Română';
      default:
        return 'English';
    }
  }

  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'ro':
        return '🇷🇴';
      default:
        return '🇺🇸';
    }
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.selectLanguage ?? "Select Language",
              size: 18,
              weight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            _buildLanguageOption('en', '🇺🇸', 'English'),
            const SizedBox(height: 10),
            _buildLanguageOption('ro', '🇷🇴', 'Română'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String code, String flag, String name) {
    bool isSelected = currentLanguage == code;
    
    return GestureDetector(
      onTap: () async {
        // Save selected language to shared preferences
        await SharedPreferenceService.instance.saveSharedPreferenceString(
          key: SharedPrefKeys.selectedLanguage,
          value: code,
        );
        
        // Update app locale
        Get.updateLocale(Locale(code));
        
        // Update local state
        setState(() {
          currentLanguage = code;
        });
        
        // Close bottom sheet
        Get.back();
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
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: MyText(
                text: name,
                
                size: 16,
                weight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: kPrimaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
  onTap: _showLanguageSelector, // same tap method
  child: Padding(
    padding: EdgeInsets.zero, // same as ListTile contentPadding: EdgeInsets.zero
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Leading Icon
        // SizedBox(width: 8,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: CircleAvatar(
            backgroundColor: kBlueColor.withOpacity(0.7),
            radius: 24,
            child: Icon(Icons.language, color: Colors.white.withOpacity(0.9), size: 34),),
        ),

        const SizedBox(width: 12),

        // Title + Subtitle (Column)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              MyText(
                text: AppLocalizations.of(context)!.language,
                size: 19,
                weight: FontWeight.w400,
              ),
              const SizedBox(height: 4),

              // Subtitle Row
              Row(
                children: [
                  Text(
                    _getLanguageFlag(currentLanguage),
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(width: 8),
                  MyText(
                    text: _getLanguageDisplayName(currentLanguage),
                    size: 10,
                    color: Colors.black,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Trailing Icon
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    ),
  ),
);

  }
} 