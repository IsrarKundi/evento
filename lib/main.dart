import 'package:event_connect/core/bindings/bindings.dart';
import 'package:event_connect/core/constants/app_colors.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/services/onesignalNotificationService/one_signal_notification_service.dart';
import 'package:event_connect/views/screens/launch/splash_screen.dart';
import 'package:event_connect/views/screens/language_selection_screen.dart';
import 'package:event_connect/services/shared_preferences_services.dart';
import 'package:event_connect/core/constants/shared_preference_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zuiodtsmpjjmjqqwkgvf.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp1aW9kdHNtcGpqbWpxcXdrZ3ZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NDk1NTcsImV4cCI6MjA2MzMyNTU1N30.x-wzN7LSuSuNtjjco-Zyz2CdUqHUnbulGJKK1L4IfvU',
  );
  OneSignalNotificationService.instance.initializeOneSignal();

  // Check for saved language
  String? savedLanguage = await SharedPreferenceService.instance.getSharedPreferenceString(SharedPrefKeys.selectedLanguage);
  
  runApp(MyApp(initialLanguage: savedLanguage));
}

String dummyAvatar = 'https://i.pravatar.cc/100';
const dummyProfileUrl =
    'https://www.cornwallbusinessawards.co.uk/wp-content/uploads/2017/11/dummy450x450.jpg';

final GlobalKey<NavigatorState> globalNavKey = GlobalKey();

class MyApp extends StatelessWidget {
  final String? initialLanguage;
  
  const MyApp({super.key, this.initialLanguage});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: globalNavKey,
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBindings(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('ro'), // Romanian
        ],
        locale: initialLanguage != null ? Locale(initialLanguage!) : const Locale('en'),
        theme: ThemeData(
          scaffoldBackgroundColor: kWhiteColor,
          appBarTheme: AppBarTheme(color: kWhiteColor),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: initialLanguage != null ? const SplashScreen() : const LanguageSelectionScreen());
  }
}


///FLUTTER VERSION
///3.24.3