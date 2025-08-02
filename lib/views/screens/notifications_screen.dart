import 'package:event_connect/controllers/notificationsController/notification_controller.dart';
import 'package:event_connect/core/utils/utils.dart';
import 'package:event_connect/models/notificationsModel/notification_model.dart';
import 'package:event_connect/views/widget/my_text_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../main_packages.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final NotificationController controller = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(text: AppLocalizations.of(context)!.notifications),
      ),
      body: Obx(
        () => controller.notifications.isEmpty
            ? Container(
                height: Get.height,
                width: Get.width,
                child: Center(
                  child: MyText(
                    text: AppLocalizations.of(context)!.noNotificationsYet,
                    color: kGreyColor1,
                  ),
                ),
              )
            : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: ListView.builder(
                        shrinkWrap: true,
                  itemCount: controller.notifications.length,
                  itemBuilder: (context, index) {
                    NotificationModel notificationModel =
                        controller.notifications[index];
                    return ListTile(
                      title: MyText(text: notificationModel.title,size: 18,weight: FontWeight.w700,),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          MyText(text: notificationModel.body),
                          Row(
                            children: [
                              Spacer(),
                              MyText(
                                  text: Utils.formatDate(
                                      notificationModel.sentAt ?? DateTime.now()),color: Colors.grey,)
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
            ),
      ),
    );
  }
}
