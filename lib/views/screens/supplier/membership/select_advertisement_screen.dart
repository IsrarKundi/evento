import 'package:event_connect/views/widget/appBars/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/bindings/bindings.dart';
import '../../../../main_packages.dart';
import '../../../widget/my_button.dart';
import '../../bottomNavBar/bottom_nav_screen.dart';
import '../profileSetup/main_profile_setup_screen.dart';

class SelectAdvertisementScreen extends StatefulWidget {
  const SelectAdvertisementScreen({super.key});

  @override
  State<SelectAdvertisementScreen> createState() => _SelectAdvertisementScreenState();
}

class _SelectAdvertisementScreenState extends State<SelectAdvertisementScreen> {
  String selectedType = 'Yes';
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Signup"),

       body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.doYouWantBoost,
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Radio<String>(
                  value: 'Yes',
                  groupValue: selectedType,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
                Text(AppLocalizations.of(context)!.yes),
                const SizedBox(width: 20),
                Radio<String>(
                  value: 'No',
                  groupValue: selectedType,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
                Text(AppLocalizations.of(context)!.no),
              ],
            ),
            const Spacer(),
            MyButton(
                radius: 100,
                height: 55,
                fontColor: kBlackColor1,
                onTap: () {
                  Get.offAll(() => MainProfileSetupScreen(),binding: ProfileSetupBinding());


                },
                buttonText: AppLocalizations.of(context)!.payPerMonth),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
