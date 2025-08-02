// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:event_connect/services/shared_preferences_services.dart';
// import 'package:event_connect/core/constants/shared_preference_keys.dart';

// class LanguageSwitcher extends StatelessWidget {
//   const LanguageSwitcher({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<Locale>(
//       icon: Icon(Icons.language),
//       onSelected: (Locale locale) async {
//         // Save selected language to shared preferences
//         await SharedPreferenceService.instance.saveSharedPreferenceString(
//           key: SharedPrefKeys.selectedLanguage,
//           value: locale.languageCode,
//         );
        
//         // Update app locale
//         Get.updateLocale(locale);
//       },
//       itemBuilder: (BuildContext context) => [
//         PopupMenuItem<Locale>(
//           value: Locale('en'),
//           child: Row(
//             children: [
//               Text('🇺🇸'),
//               SizedBox(width: 8),
//               Text('English'),
//             ],
//           ),
//         ),
//         PopupMenuItem<Locale>(
//           value: Locale('ro'),
//           child: Row(
//             children: [
//               Text('🇷🇴'),
//               SizedBox(width: 8),
//               Text('Română'),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// } 