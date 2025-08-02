import 'package:event_connect/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.privacyPolicy),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:  [
              Text(
                AppLocalizations.of(context)!.privacyPolicy,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                "${AppLocalizations.of(context)!.lastUpdated}: ${Utils.formatDate(DateTime.now())}",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                "1. ${AppLocalizations.of(context)!.introduction}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "We value your privacy and are committed to protecting your personal information. "
                    "This policy outlines how we collect, use, and protect your data when you use our app.",
              ),
              SizedBox(height: 16),
              Text(
                "2. ${AppLocalizations.of(context)!.informationWeCollect}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "- Personal data (name, email, etc.)\n"
                    "- Usage data (how you use the app)\n"
                    "- Location data (if you allow access)",
              ),
              SizedBox(height: 16),
              Text(
                "3. ${AppLocalizations.of(context)!.howWeUseInformation}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "We use your data to:\n"
                    "- Provide and improve our services\n"
                    "- Personalize your experience\n"
                    "- Communicate updates and offers",
              ),
              SizedBox(height: 16),
              Text(
                "4. ${AppLocalizations.of(context)!.dataSecurity}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "We implement reasonable security measures to protect your data from unauthorized access.",
              ),
              SizedBox(height: 16),
              Text(
                "5. ${AppLocalizations.of(context)!.yourRights}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "You have the right to access, modify, or delete your personal data. "
                    "Contact us if you have any questions or requests.",
              ),
              SizedBox(height: 16),
              Text(
                "6. ${AppLocalizations.of(context)!.changesToPolicy}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "We may update this policy from time to time. Please review it periodically.",
              ),
              SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.contactUs,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                "If you have any questions about this policy, please contact support@example.com",
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
