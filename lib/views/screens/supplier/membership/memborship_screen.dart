
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/views/screens/supplier/membership/select_advertisement_screen.dart';
import 'package:event_connect/views/widget/appBars/custom_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../bottomNavBar/bottom_nav_screen.dart';

class MembershipScreen extends StatefulWidget {

  final String title;
  const MembershipScreen({super.key, this.title='Upgrades your plan'});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  String _selectedPeriod = 'monthly';
  bool _autoRenew = false;

  @override
  Widget build(BuildContext context) {
    // Get the localized title
    final localizedTitle = widget.title == 'Upgrades your plan' 
        ? AppLocalizations.of(context)!.upgradesPlan 
        : widget.title;
        
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: localizedTitle),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.upgradePeriodMembership,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Monthly option
            Text(
              AppLocalizations.of(context)!.monthly,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            _buildPeriodOption(
              period: 'monthly',
              price: '99 LEI',
              additionalInfo: '',
            ),

            const SizedBox(height: 20),

            // Yearly option
            Text(
              AppLocalizations.of(context)!.yearly,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            _buildPeriodOption(
              period: 'yearly',
              price: '1,088 LEI',
              additionalInfo: AppLocalizations.of(context)!.oneMonthFree,
            ),

            const SizedBox(height: 30),

            // Auto-renewal option
            Text(
              AppLocalizations.of(context)!.renewAutomatically,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildRenewalOption(label: AppLocalizations.of(context)!.yes, value: true),
                const SizedBox(width: 30),
                _buildRenewalOption(label: AppLocalizations.of(context)!.no, value: false),
              ],
            ),

            const Spacer(),

            // Bottom button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(widget.title!='Upgrades your plan'){
                    Get.to(() => const SelectAdvertisementScreen());
                  }
                  // Handle continue to pay
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  elevation: 0,
                ),
                child: Text(
                  AppLocalizations.of(context)!.continueToPay,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodOption({
    required String period,
    required String price,
    required String additionalInfo,
  }) {
    final isSelected = _selectedPeriod == period;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                if (additionalInfo.isNotEmpty)
                  Text(
                    additionalInfo,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                const SizedBox(width: 10),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected ? null : Border.all(color: Colors.grey.shade400),
                    color: isSelected ? kPrimaryColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.white,
                  )
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRenewalOption({required String label, required bool value}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _autoRenew = value;
        });
      },
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade400,
              ),
              color: _autoRenew == value ? kPrimaryColor : Colors.transparent,
            ),
            child: _autoRenew == value
                ? const Icon(
              Icons.check,
              size: 12,
              color: Colors.white,
            )
                : null,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}