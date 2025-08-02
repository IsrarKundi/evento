import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.termsAndConditions),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.termsAndConditions,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                '${AppLocalizations.of(context)!.lastUpdated}: June 4, 2025',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                '1. ${AppLocalizations.of(context)!.acceptanceOfTerms}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'By accessing or using our app, you agree to be bound by these Terms and all applicable laws and regulations.',
              ),
              SizedBox(height: 16),
              Text(
                '2. ${AppLocalizations.of(context)!.useOfApp}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'You agree not to misuse the app in any way, including but not limited to attempting to gain unauthorized access, distributing malware, or violating local laws.',
              ),
              SizedBox(height: 16),
              Text(
                '3. ${AppLocalizations.of(context)!.userAccounts}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account.',
              ),
              SizedBox(height: 16),
              Text(
                '4. ${AppLocalizations.of(context)!.intellectualProperty}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'All content within the app is the property of the app owner or its licensors. Unauthorized use may violate copyright laws.',
              ),
              SizedBox(height: 16),
              Text(
                '5. ${AppLocalizations.of(context)!.termination}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'We reserve the right to suspend or terminate your access to the app at our discretion, with or without notice.',
              ),
              SizedBox(height: 16),
              Text(
                '6. ${AppLocalizations.of(context)!.disclaimerOfWarranty}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'The app is provided on an "as is" and "as available" basis. We do not guarantee it will be error-free or uninterrupted.',
              ),
              SizedBox(height: 16),
              Text(
                '7. ${AppLocalizations.of(context)!.limitationOfLiability}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'We shall not be held liable for any damages resulting from your use of the app, including lost profits or data loss.',
              ),
              SizedBox(height: 16),
              Text(
                '8. ${AppLocalizations.of(context)!.governingLaw}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'These Terms shall be governed and construed in accordance with the laws of your jurisdiction.',
              ),
              SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.contactUs,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions or concerns about these Terms, contact us at support@example.com.',
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
