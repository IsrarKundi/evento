import 'dart:developer';

import 'package:event_connect/core/bindings/bindings.dart';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/main.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/services/onesignalNotificationService/one_signal_notification_service.dart';
import 'package:event_connect/views/screens/notifications_screen.dart';
import 'package:event_connect/views/screens/supplier/profileSetup/add_profile_Screen.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../screens/bottomNavBar/chatsTab/chats_tab.dart';
import '../common_image_view_widget.dart';
import '../my_text_widget.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      title: Row(
        children: [
          Obx(
            () => GestureDetector(
              onTap: () {
                Get.to(() => AddProfileScreen(
                      isEdit: true,
                    ));
              },
              child: CommonImageView(
                radius: 100,
                height: 50,
                width: 50,
                fit: BoxFit.fill,
                url: userModelGlobal.value?.profileImage ?? dummyProfileUrl,
                // imagePath: Assets.imagesAvatar,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => MyText(
                  text: userModelGlobal.value?.fullName ?? "",
                  size: 16,
                  weight: FontWeight.w400,
                ),
              ),
              Obx(
                () => MyText(
                  text: userModelGlobal.value?.location ?? "",
                  color: kBlackColor1.withOpacity(0.9),
                  size: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
              onTap: () {
                Get.to(() => NotificationsScreen(),
                    binding: NotificationsBinding());
              },
              child:
                  Obx(() => userModelGlobal.value?.unreadNotification == false
                      ? Icon(
                          Icons.notifications_none,
                          color: kPrimaryColor,
                          size: 28,
                        )
                      : Stack(
                          children: [
                            Icon(
                              Icons.notifications_none,
                              color: kPrimaryColor,
                              size: 28,
                            ),
                            Positioned(
                                top: 3,
                                right: 3,
                                child: Container(
                                  height: 8,
                                  width: 8,
                                  decoration: ShapeDecoration(
                                      shape: CircleBorder(), color: Colors.red),
                                ))
                          ],
                        ))),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => ChatsTab(
                    isSupplier: true,
                  ));
            },
            child: Obx(
              () => Stack(
                children: [
                  CommonImageView(
                    imagePath: Assets.imagesChat1,
                    height: 25,
                    width: 25,
                    imageColor: kPrimaryColor,
                  ),
                  userModelGlobal.value?.unreadMessage == true
                      ? Positioned(
                          top: 2,
                          right: 3,
                          child: Container(
                            height: 8,
                            width: 8,
                            decoration: ShapeDecoration(
                                shape: CircleBorder(), color: Colors.red),
                          ))
                      : SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
