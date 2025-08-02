import 'dart:developer';

import 'package:event_connect/core/bindings/bindings.dart';
import 'package:event_connect/core/constants/shared_preference_keys.dart';
import 'package:event_connect/core/utils/dialogs.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/services/shared_preferences_services.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:event_connect/views/screens/auth/login_screen.dart';
import 'package:event_connect/views/screens/notifications_screen.dart';
import 'package:event_connect/views/screens/supplier/homeScreen/appointment_screen.dart';
import 'package:event_connect/views/screens/supplier/homeScreen/manage_availabilty.dart';
import 'package:event_connect/views/screens/supplier/homeScreen/portfolio_screen.dart';
import 'package:event_connect/views/screens/supplier/homeScreen/supplier_services.dart';
import 'package:event_connect/views/screens/supplier/membership/memborship_screen.dart';
import 'package:event_connect/views/widget/appBars/profile_appbar.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:event_connect/views/widget/language_selector_tile.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'advirtising_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const ProfileAppBar(),
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.05,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(() => const MembershipScreen());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    border: Border.all(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 50,
                  width: Get.width,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      MyText(
                        text: AppLocalizations.of(context)!.membership,
                        size: 20,
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(100)),
                        height: 30,
                        width: 60,
                        child: Center(child: MyText(text: AppLocalizations.of(context)!.active)),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InfoCardTile(
                onTap: () {
                  Get.to(() => const AppointmentsScreen(),binding: AppointmentsBindings());
                },
                imagePath: Assets.imagesTask,
                title: AppLocalizations.of(context)!.bookings,
                subtitle: AppLocalizations.of(context)!.upcomingCompletedCancel,
              ),
              InfoCardTile(
                onTap: () {
                  Get.to(() => const ManageAvailabilityScreen());
                },
                imagePath: Assets.imagesTask,
                title: AppLocalizations.of(context)!.manageAvailability,
                subtitle: AppLocalizations.of(context)!.setYourSchedule,
                borderColor: kLightBlueColor,
              ),

              InfoCardTile(
                onTap: () {
                  Get.to(()=>PortfolioScreen(),binding: PortfolioBinding());
                },
                imagePath: Assets.imagesTask,
                title: AppLocalizations.of(context)!.portfolio,
                subtitle: AppLocalizations.of(context)!.manageYourPortfolio,
                borderColor: kGreyColor3,
              ),
              InfoCardTile(
                onTap: () {
                  Get.to(() =>  SupplierServices());
                },
                imagePath: Assets.imagesTicketPercent,
                title: AppLocalizations.of(context)!.services,
                subtitle: AppLocalizations.of(context)!.advertiseYourService,
                borderColor: kDarkGreenColor,
                isSubtitle: true,
              ),
              // Language selector container
              Container(
                        height: Get.height*0.09,

                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(8),
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    border: Border.all(color: kBlueColor.withOpacity(0.7))),
                child: const LanguageSelectorTile(),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  log("Logout called");
                  DialogService.instance.showConfirmationDialog(
                    message: AppLocalizations.of(context)!.doYouWantLogout,
                    onNo: () {
                      Get.back();
                    },
                    onYes: () async {

                       SupabaseCRUDService.instance.signOut();
                       GoogleSignIn google  = GoogleSignIn();
                       google.signOut();
                      SupabaseCRUDService.instance.stopUserStream();
                       SharedPreferenceService.instance.removeSharedPreferenceBool(SharedPrefKeys.loggedIn);
                      Get.offAll(()=>LoginScreen());

                    },
                    title: AppLocalizations.of(context)!.logout,
                    context: context,
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    MyText(
                      text: AppLocalizations.of(context)!.logout,
                      size: 16,
                      weight: FontWeight.w700,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCardTile extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final Color borderColor;
  final bool isSubtitle;
  final Function()? onTap;

  const InfoCardTile({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.isSubtitle = true,
    this.borderColor = kDarkBlueColor,
    this.onTap, // default if not passed
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        height: Get.height*0.09,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: borderColor,
                radius: 25,
                child: Image.asset(imagePath),
              ),
              const SizedBox(width: 20),
            Expanded(child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    text: title,
                    size: 19,
                    weight: FontWeight.w400,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  if (isSubtitle)
                    MyText(
                      text: subtitle,
                      weight: FontWeight.w400,
                      size: 10,
                    //  maxLines: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
          )
             
            ],
          ),
        ),
      ),
    );
  }
}
