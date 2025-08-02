import 'package:event_connect/main_packages.dart';

import '../common_image_view_widget.dart';
import '../my_text_widget.dart';

class SocialButton extends StatelessWidget {
  final Function()? onTap;
  final String iconPath;
  final String buttonText;
  const SocialButton({super.key, this.onTap,this.iconPath=Assets.imagesFacebook,this.buttonText="Facebook"});

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        height: 57,
        width: Get.width*0.4,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(color: kBorderColor)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonImageView(
              imagePath: iconPath,
            ),
            SizedBox(width: 10,),
            MyText(text: buttonText,size: 16,weight: FontWeight.w600,)
          ],
        ),
      ),
    );
  }
}