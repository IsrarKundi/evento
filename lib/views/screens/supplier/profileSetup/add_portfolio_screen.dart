import 'dart:developer';

import 'package:event_connect/controllers/suppierControllers/add_service_controller.dart';
import 'package:event_connect/controllers/suppierControllers/profile_setup_controler.dart';
import 'package:event_connect/core/bindings/bindings.dart';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/models/userModel/user_model.dart';
import 'package:event_connect/services/snackbar_service/snackbar.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/supplier/homeScreen/home_screen.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/add_profile_Screen.dart';
import 'package:event_connect/views/widget/bookingCards/booking_card.dart';
import 'package:event_connect/views/widget/my_button.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';

import 'add_service_screen.dart';

class AddPortfolioScreen extends StatelessWidget {
  AddPortfolioScreen({super.key});

  final AddServiceController controller = Get.find<AddServiceController>();
  final ProfileSetupController profileSetupController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MyButton(
          onTap: () {
            log("profileSetupController.currentIndex.value = ${profileSetupController.currentIndex.value}");
            if (profileSetupController.currentIndex.value == 4 || profileSetupController.currentIndex.value == 3) {
              SupabaseCRUDService.instance.updateDocument(
                  tableName: SupabaseConstants().usersTable,
                  id: userModelGlobal.value?.id ?? "",
                  data: {
                    'is_profile_setup':true
                  });
              Get.to(() => const HomeScreen(),binding: SupplierHomeBindings());
            }else{
              CustomSnackBars.instance.showFailureSnackbar(title: "Complete All Steps", message: '');
            }
          },
          buttonText: "Next",
          radius: 100,
          fontColor: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.userServices.length,
                  itemBuilder: (context, index) {
                    ServiceModel serviceModel = controller.userServices[index];
                    return ServiceWidget(serviceModel: serviceModel);
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              MyButton(
                fontColor: Colors.black,
                onTap: () {
                  Get.to(() => const AddServiceScreen());
                },
                buttonText: "Add Service",
                backgroundColor: Colors.white,
                outlineColor: Colors.black,
                radius: 100,
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceWidget extends StatelessWidget {
  final ServiceModel serviceModel;

  const ServiceWidget({super.key, required this.serviceModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBookingCard(
              isPerhour: serviceModel.perHour??false,
              showBook: false,
              price: serviceModel.amount ?? "50",
              context: context,
              url: serviceModel.serviceImage ?? dummyProfileUrl,
              title: "${serviceModel.serviceName}",
              location: "${serviceModel.location??""}"),
          const SizedBox(
            height: 30,
          ),
          MyText(
            text: "About",
            weight: FontWeight.w600,
            size: 16,
          ),
          const SizedBox(
            height: 10,
          ),
          MyText(
            text: "${serviceModel.about}",
            size: 12,
            weight: FontWeight.w400,
          ),

        ],
      ),
    );
  }
}
