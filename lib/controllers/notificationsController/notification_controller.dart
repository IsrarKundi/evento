import 'dart:developer';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/main_packages.dart';
import 'package:event_connect/models/notificationsModel/notification_model.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
@override
  void onInit() {
    getAllNotifications();
    super.onInit();
  }
  getAllNotifications() async {

    List<Map<String, dynamic>>? docs = await SupabaseCRUDService.instance.readAllDocumentsWithJoin(
      orderByField: 'sent_at',
      fieldName: 'sent_to',
        fieldValue: userModelGlobal.value?.id??'',
        tableName: SupabaseConstants().notificationsTable,
        joinQuery: '*,user_model:users!sent_by(*)',);

    log("Notifications = ${docs?.length}");

    if(docs!=null){
      for(var doc in docs){

       NotificationModel notificationModel =  NotificationModel.fromJson(doc);

       notifications.add(notificationModel);
      }
    }

    SupabaseCRUDService.instance.updateDocument(tableName: SupabaseConstants().usersTable, id: userModelGlobal.value?.id??"", data: {
      "unread_notification":false
    });

}
}
