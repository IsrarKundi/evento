import 'package:event_connect/views/screens/bottomNavBar/bookingTab/booking_tab.dart';
import 'package:event_connect/views/screens/bottomNavBar/chatsTab/chats_tab.dart';
import 'package:event_connect/views/screens/bottomNavBar/profileTab/profile_tab.dart';
import 'package:event_connect/views/widget/common_image_view_widget.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/constants/app_constants.dart';
import '../../../main_packages.dart';
import 'homeScreen/homeTab.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeTab(),
    BookingTab(),
    ChatsTab(),
   ProfileTab()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        onTap: _onItemTapped,
        items: [

          BottomNavigationBarItem(icon: Image.asset(Assets.imagesHome,height: 18,width: 18,color: _selectedIndex==0?kPrimaryColor:kBlackColor1.withOpacity(0.8),), label: AppLocalizations.of(context)!.home),
          BottomNavigationBarItem(icon: Image.asset(Assets.imagesBookingIcon,height: 18,width: 18,color: _selectedIndex==1?kPrimaryColor:kBlackColor1.withOpacity(0.8),), label: AppLocalizations.of(context)!.bookings),
          BottomNavigationBarItem(icon: Obx(()=>
              Stack(
              children: [
                Image.asset(Assets.imagesChat1,height: 18,width: 18,color: _selectedIndex==2?kPrimaryColor:kBlackColor1.withOpacity(0.8),),
                userModelGlobal.value?.unreadMessage == true
                    ? Positioned(
                    top: -1,
                    right: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: ShapeDecoration(
                          shape: CircleBorder(), color: Colors.red),
                    ))
                    : SizedBox()
              ],
            ),
          ), label: AppLocalizations.of(context)!.chat),
          BottomNavigationBarItem(icon: Image.asset(Assets.imagesProfile,height: 18,width: 18,color: _selectedIndex==3?kPrimaryColor:kBlackColor1.withOpacity(0.8),), label: AppLocalizations.of(context)!.profile),

        ],
      ),
    );
  }


}

