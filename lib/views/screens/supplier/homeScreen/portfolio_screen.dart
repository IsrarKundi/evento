import 'dart:developer';

import 'package:event_connect/controllers/suppierControllers/portfolio_controller.dart';
import 'package:event_connect/controllers/suppierControllers/profile_setup_controler.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/image_view.dart';
import 'package:event_connect/views/widget/appBars/custom_app_bar.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';

import '../../../../controllers/suppierControllers/add_service_controller.dart';
import '../../../../core/bindings/bindings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/supabase_constants.dart';
import '../../../../services/snackbar_service/snackbar.dart';
import 'home_screen.dart';

class PortfolioScreen extends StatelessWidget {
  final bool isProfileSetup;
  PortfolioScreen({super.key, this.isProfileSetup=false});

  final PortfolioController controller = Get.find<PortfolioController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(title: AppLocalizations.of(context)!.portfolio),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                height: 120,
                color: Colors.white,
                child: Obx(()=>
                    ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.images.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(()=>ImageView(imageUrl: controller.images[index]));
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          clipBehavior: Clip.antiAlias,
                          height: 100,
                          width: 100,
                          // margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CommonImageView(
                            height: 100,
                            width: 100,
                            url: controller.images[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                ImagePickerService.instance.openProfilePickerBottomSheet(
                  context: context,
                  onCameraPick: () {
                    controller.pickImage(
                    );
                  },
                  onGalleryPick: () {
                    controller.pickImage(isCamera: false);
                  },
                );
              },
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xFFDFF6DA),
                    border: DashedBorder.fromBorderSide(
                        side: BorderSide(color: kPrimaryColor), dashLength: 3)),
                child: Center(
                  child: Icon(Icons.upload, color: Colors.green.shade400),
                ),
              ),
            ),
            Spacer(),
            if(isProfileSetup)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyButton(
                  onTap: () {
                    if(controller.images.isNotEmpty){
                      final ProfileSetupController profileSetupController = Get.find();

                      log("profileSetupController.currentIndex.value = ${profileSetupController.currentIndex.value}");
                      SupabaseCRUDService.instance.updateDocument(
                          tableName: SupabaseConstants().usersTable,
                          id: userModelGlobal.value?.id ?? "",
                          data: {
                            'is_profile_setup':true
                          });
                      Get.offAll(() => const HomeScreen(),binding: SupplierHomeBindings());


                      // if (profileSetupController.currentIndex.value == 4 || profileSetupController.currentIndex.value == 3) {
                      //   SupabaseCRUDService.instance.updateDocument(
                      //       tableName: SupabaseConstants().usersTable,
                      //       id: userModelGlobal.value?.id ?? "",
                      //       data: {
                      //         'is_profile_setup':true
                      //       });
                      //   Get.to(() => const HomeScreen(),binding: SupplierHomeBindings());
                      //
                      // }else{
                      //   CustomSnackBars.instance.showFailureSnackbar(title: "Complete All Steps", message: '');
                      // }
                    }else{
                      CustomSnackBars.instance.showInfoSnackbar(title: AppLocalizations.of(context)!.pleaseAddPortfolio, message: "",);
                    }

                  },
                  buttonText: AppLocalizations.of(context)!.next,
                  radius: 100,
                  fontColor: Colors.black,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
