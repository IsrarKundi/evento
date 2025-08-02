import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/views/screens/auth/login_screen.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../main_packages.dart';

class CongratsScreen extends StatelessWidget {
  const CongratsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
            ),
            CommonImageView(
              svgPath: Assets.imagesCongrats,
            ),
            SizedBox(
              height: 20,
            ),
            MyText(
              text: AppLocalizations.of(context)!.congrats,
              size: 32,
              weight: FontWeight.w600,
              color: kPrimaryColor,
            ),
            SizedBox(
              height: 10,
            ),
            MyText(text: AppLocalizations.of(context)!.yourBookingDone),
            SizedBox(height: Get.height*0.3,),
            MyButton(onTap: (){
              Get.back();
            }, buttonText: AppLocalizations.of(context)!.goToHomepage,fontColor: Colors.black,radius: 100,)

          ],
        ),
      )),
    );
  }
}
