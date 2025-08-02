import 'dart:convert';
import 'dart:developer';
import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/constants/supabase_constants.dart';
import 'package:event_connect/models/notificationsModel/notification_model.dart';
import 'package:event_connect/services/supabaseService/supbase_crud_service.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OneSignalNotificationService {
  OneSignalNotificationService._privateConstructor();

  static OneSignalNotificationService? _instance;

  static OneSignalNotificationService get instance {
    _instance ??= OneSignalNotificationService._privateConstructor();
    return _instance!;
  }

  String _oneSignalAppId = 'c29b2453-997a-4031-9e5e-7bd86008e58b';

  initializeOneSignal() {
    OneSignal.initialize(_oneSignalAppId);

    // Use this method to prompt for push notifications.
    // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
    OneSignal.Notifications.requestPermission(true);

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault(); // Prevent default popup
      OneSignal.Notifications.displayNotification(
          event.notification.notificationId); // Show manually
    });

    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      print('Clicked notification with data: $data');
    });
  }

  loginOneSignal() {
    String? userId = Supabase.instance.client.auth.currentUser?.id;

    log("loginOneSignal = ${userId}");
    OneSignal.login(userId!);
    addTags();
  }

  Future<void> sendOneSignalNotificationToUser(
      {required bool isSaved,
      required String externalId,
      required String title,
      required String message,
      String type = 'general'}) async {

    log("sendOneSignalNotificationToUser called externalId = ${externalId}");
    const String restApiKey =
        'os_v2_app_yknsiu4zpjaddhs6ppmgachfrmcg5vjxqdxeaonds6zd4sfbc2l34cm6ikfaekm3xpzp3c7qmexr7qfc67encps3zqyz33y3yu2wgei'; // from OneSignal dashboard

    final url = Uri.parse('https://onesignal.com/api/v1/notifications');

    final body = {
      "app_id": _oneSignalAppId,

      ///For Segments
      // "included_segments": [
      //   "Test Users"
      // ],

      /// Tags
      // "filters": [
      //     { "field": "tag", "key": "role", "relation": "=", "value": "user" }
      //   ],

      /// Specific User
      "include_aliases": {
        "external_id": [
          externalId,
        ]
      },

      /// only need with include_aliases
      "target_channel": "push",

      "headings": {"en": title},
      "contents": {"en": message},
      "priority": 10,
      "android_priority": 10,
      "android_visibility": 1,

      /// data
      "data": {
        "screen": "BookingDetails",
        "bookingId": "abc123",
        "userType": "cleaner"
      },

      ///Create Through One Signal Dashboard => Settings>Android Notification Channel => set to urgent
      "android_channel_id": "adda3680-b944-43ba-b056-165dc72a3de2",
    };

    final headers = {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Basic $restApiKey"
    };

    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));


    log("sendOneSignalNotificationToUser response = ${response.body}");
    if(isSaved){
      SupabaseCRUDService.instance.createDocument(
          tableName: SupabaseConstants().notificationsTable,
          data: NotificationModel(
            sentBy: userModelGlobal.value?.id ?? '',
            sentTo: externalId,
            title: title,
            body: message,
            type: type,
          ).toJson());

      SupabaseCRUDService.instance.updateDocument(tableName: SupabaseConstants().usersTable, id: externalId, data: {
        "unread_notification":true
      });
    }




    print("Status code: ${response.statusCode}");
    print("Response: ${response.body}");
  }

  addTags() {
    OneSignal.User.addTags({"role": "user"});
  }

  Future<String?> getExternalId() async {
    String? externalId = await OneSignal.User.getExternalId();
    return externalId;
  }
}
