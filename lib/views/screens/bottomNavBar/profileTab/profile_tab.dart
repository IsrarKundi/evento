import 'dart:developer';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/l10n/app_localizations.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/bookingModel/booking_model.dart';
import 'package:event_connect/views/screens/bottomNavBar/profileTab/privacy_policy_screen.dart';
import 'package:event_connect/views/screens/bottomNavBar/profileTab/terms_and_condition_Screen.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/add_profile_Screen.dart';
import 'package:event_connect/views/widget/bookingCards/booking_card.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:event_connect/views/widget/language_selector_tile.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../controllers/userControllers/bookings_controller.dart';
import '../../../../core/constants/shared_preference_keys.dart';
import '../../../../core/utils/dialogs.dart';
import '../../../../services/shared_preferences_services.dart';
import '../../../../services/supabaseService/supbase_crud_service.dart';
import '../../auth/login_screen.dart';
import '../../categoryScreens/category_detail_screen.dart';

class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  final BookingsController controller = Get.find<BookingsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: MyText(text: AppLocalizations.of(context)!.profile),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx( ()=> GestureDetector(
                      onTap: () {
                        Get.to(()=>AddProfileScreen());
                      },
                      child: CommonImageView(
                        radius: 100,
                        height: 80,
                        width: 85,
                        url: userModelGlobal.value?.profileImage ?? dummyProfileUrl,
                        // imagePath: Assets.imagesAvatar,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Obx(
                            () => MyText(
                              text: "${userModelGlobal.value?.fullName}",
                              size: 16,
                              weight: FontWeight.w700,
                            ),
                          ),
                          Obx(() =>
                              MyText(text: userModelGlobal.value?.email ?? ""))
                        ],
                      ),

                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    border: Border.all(color: kBorderColor)),
                child: Column(
                  children: [
                    const LanguageSelectorTile(),
                    ListTile(
                      onTap: () {
                        Get.to(() => PrivacyPolicyScreen());
                      },
                      leading: Image.asset(Assets.imagesShield),
                      title: MyText(text: AppLocalizations.of(context)!.privacyPolicy),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      onTap: () {
                        Get.to(() => TermsAndConditionsScreen());
                      },
                      leading: Image.asset(Assets.imagesInfoCircle),
                      title: MyText(text: AppLocalizations.of(context)!.termsAndConditions),
                      contentPadding: EdgeInsets.zero,
                    ),
                    ListTile(
                      onTap: () {
                        log("Logout called");
                        DialogService.instance.showConfirmationDialog(
                          message: AppLocalizations.of(context)!.doYouWantLogout,
                          onNo: () {
                            Get.back();
                          },
                          onYes: () async {

                            SupabaseCRUDService.instance.signOut();
                            GoogleSignIn google = GoogleSignIn();
                            google.signOut();
                            SupabaseCRUDService.instance.stopUserStream();

                            SharedPreferenceService.instance
                                .removeSharedPreferenceBool(
                                    SharedPrefKeys.loggedIn);

                            Get.offAll(() => LoginScreen());
                          },
                          title: AppLocalizations.of(context)!.logout,
                          context: context,
                        );
                      },
                      leading: Image.asset(Assets.imagesLogout),
                      title: MyText(text: AppLocalizations.of(context)!.logout),
                      contentPadding: EdgeInsets.zero,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              MyText(text: AppLocalizations.of(context)!.history),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.otherBookings.length,
                  itemBuilder: (context, index) {
                    BookingModel bookingModel = controller.otherBookings[index];
                    return buildBookingCard(
                      context: context,
                      onBookTap: () {
                        Get.to(() => CategoryDetailScreen(
                          // bookingModel:bookingModel,
                          serviceModel: bookingModel.serviceModel!,

                        ));
                      },
                        isPerhour: bookingModel.serviceModel?.perHour??false,
                        url: bookingModel.serviceModel?.serviceImage ??
                            dummyProfileUrl,
                        title: "${bookingModel.serviceModel?.serviceName}",
                        location: "${bookingModel.serviceModel?.location ?? ''}");
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
