import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/utils.dart';
import '../../core/bindings/bindings.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/supabase_constants.dart';

import '../../models/chatModels/chat_thread_model.dart';
import '../../models/userModel/user_model.dart';
import '../../services/chattingService/chatting_service.dart';
import '../../services/supabaseService/supbase_crud_service.dart';

class ChatController extends GetxController {

  RxList<ChatThreadModel> allChats = <ChatThreadModel>[].obs;




  @override
  void onInit() {
    super.onInit();

    fetchChats();
    Utils.loadRomanianCitiesFromCSV().then((cities) {
      romaniaCities.assignAll(cities);
      print('Loaded ${cities.length} cities');
    });

  }



  fetchChats() {
    Future.delayed(
      Duration(seconds: 1),
          () => ChattingService.instance
          .streamChatHeads(
          userId: Supabase.instance.client.auth.currentUser!.id)
          .listen((models) async {

            log("streamChatHeads called");

        allChats.clear();
        for (var model in models) {
          Map<String, dynamic>? otherUser;
          if (model.senderId == userModelGlobal.value!.id!) {
            otherUser = await SupabaseCRUDService.instance.readSingleDocument(
                tableName: SupabaseConstants().usersTable,
                id: model.receiverId ?? '');
          } else {
            otherUser = await SupabaseCRUDService.instance.readSingleDocument(
                tableName: SupabaseConstants().usersTable,
                id: model.senderId ?? '');
          }
          if (otherUser != null) {
            log("fetchChats OtherUser ${otherUser}");
            model =
                model.copyWith(otherUserDetail: UserModel.fromJson(otherUser));
          }
          log("fetchChats Other ${model.toMap()}");
          allChats.add(model);
        }
        // allChats.assignAll(models);
        log("fetchChats = ${allChats.length}");
      }),
    );

    SupabaseCRUDService.instance.updateDocument(
        tableName: SupabaseConstants().usersTable,
        id: userModelGlobal.value?.id ?? "",
        data: {"unread_message": false});
  }

}
