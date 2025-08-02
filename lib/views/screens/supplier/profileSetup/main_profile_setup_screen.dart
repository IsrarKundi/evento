import 'package:event_connect/controllers/suppierControllers/profile_setup_controler.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/add_bio_screen.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/add_portfolio_screen.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/add_profile_Screen.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/add_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/bindings/bindings.dart';
import '../../../../main_packages.dart';
import '../homeScreen/portfolio_screen.dart';

class MainProfileSetupScreen extends StatefulWidget {
  const MainProfileSetupScreen({super.key});

  @override
  State<MainProfileSetupScreen> createState() => _MainProfileSetupScreenState();
}

class _MainProfileSetupScreenState extends State<MainProfileSetupScreen> {
  int totalSteps = 4;

  ProfileSetupController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: Obx(
                      () => CircularProgressIndicator(
                        value: controller.currentIndex.value / totalSteps,
                        strokeWidth: 5,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${controller.currentIndex.value}/$totalSteps",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context)!.boostEarningPotential,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.increaseEarningDescription,
                style: const TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Custom steps
              _optionTile(Icons.camera_alt_outlined, AppLocalizations.of(context)!.addProfile,
                  onTap: () {
                Get.to(() => AddProfileScreen());
              }),
              _optionTile(Icons.edit_outlined, AppLocalizations.of(context)!.addBio, onTap: () {
                Get.to(() => AddBioScreen());
              }),
              _optionTile(Icons.work_outline, AppLocalizations.of(context)!.services, onTap: () {
                Get.to(() => AddServiceScreen());
              }),
              _optionTile(
                Icons.folder_open_outlined,
                AppLocalizations.of(context)!.portfolio,
                onTap: () {
                  Get.to(()=>PortfolioScreen(isProfileSetup: true,),binding: PortfolioBinding());

                  // Get.to(() => AddPortfolioScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionTile(IconData icon, String title, {Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
