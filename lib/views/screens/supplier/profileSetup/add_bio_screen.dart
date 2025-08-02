import 'package:event_connect/controllers/suppierControllers/profile_setup_controler.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';

import 'package:event_connect/views/widget/my_button.dart';


import '../../../../main_packages.dart';

class AddBioScreen extends StatelessWidget {


  AddBioScreen({super.key});
  final ProfileSetupController controller = Get.find<ProfileSetupController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.addBio,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            // const Text(
            //   "lorem ispum..........................................",
            //   style: TextStyle(color: Colors.black54),
            // ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade100,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: controller.bioController,
                maxLines: 8,
                decoration: InputDecoration.collapsed(
                  hintText: AppLocalizations.of(context)!.pleaseDescribeYourself,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const Spacer(),
            MyButton(onTap: (){

              if(controller.bioController.text.isNotEmpty){
                controller.addBio();
              }else{
                CustomSnackBars.instance.showFailureSnackbar(title: AppLocalizations.of(context)!.failed, message: AppLocalizations.of(context)!.pleaseAddBio);
              }
            }, buttonText: AppLocalizations.of(context)!.save,radius: 100,fontColor: kBlackColor1,),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
