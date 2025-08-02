import 'dart:async';
import 'dart:developer';

import 'package:event_connect/core/constants/app_constants.dart';
import 'package:event_connect/core/enums/enums.dart';
import 'package:event_connect/core/utils/image_picker_service.dart';
import 'package:event_connect/services/onesignalNotificationService/one_signal_notification_service.dart';
import 'package:event_connect/services/supabaseService/supabase_storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/supabase_constants.dart';
import '../../core/utils/dialogs.dart';
import '../../main_packages.dart';
import '../../models/chatModels/chat_thread_model.dart';
import '../../models/chatModels/message_model.dart';
import '../../services/supabaseService/supbase_crud_service.dart';

class MessageController extends GetxController {
  RxList<MessageModel> messages = <MessageModel>[].obs;
  final TextEditingController messageController = TextEditingController();

  Rx<ChatThreadModel> chatThread = ChatThreadModel().obs;
  late StreamSubscription<List<Map<String, dynamic>>>
      chatThreadStreamSubscription;

  @override
  void onInit() {
    super.onInit();

    ChatThreadModel chatThreadModel = Get.arguments;

    chatThread.value = Get.arguments;

    log("chatThreadModel = ${chatThreadModel.toMap()}");

    resetUnreadCount(chatThread.value);
    chatThreadStreamSubscription = Supabase.instance.client
        .from(SupabaseConstants().chatThreadsTable)
        .stream(primaryKey: ['id'])
        .eq('id', chatThreadModel.id ?? '')
        .listen(
          (event) {
            log("chatThreadStreamSubscription called");

            chatThread.value = ChatThreadModel.fromMap(event.first);
          },
        );

    fetchMessages(chatThreadModel: chatThreadModel)
        .listen((messagesList) => messages.assignAll(messagesList));
    log("Messages Controller Init = ${chatThreadModel.toMap()}");
  }


  Future<void> resetUnreadCount(ChatThreadModel chatThread) async {
    final currentUserId = userModelGlobal.value?.id;

    if (currentUserId == null) return;

    final isSender = currentUserId == chatThread.senderId;

    await SupabaseCRUDService.instance.updateDocument(
      tableName: SupabaseConstants().chatThreadsTable,
      id: chatThread.id ?? '',
      data: {
        if (isSender)
          'sender_unread_count': 0
        else
          'receiver_unread_count': 0,
      },
    );

    // Optional: update in memory if using controller.chatThread.value
    chatThread = chatThread.copyWith(
      senderUnreadCount: isSender ? 0 : chatThread.senderUnreadCount,
      receiverUnreadCount: isSender ? chatThread.receiverUnreadCount : 0,
    );
  }


  selectImage({bool isCamera = true,required BuildContext context}) async {
    Get.back();
    XFile? file;
    if (isCamera) {
      file = await ImagePickerService.instance.pickImageFromCamera();
    } else {
      file = await ImagePickerService.instance.pickSingleImageFromGallery();
    }
    if (file != null) {
      Uuid uuid = Uuid();
      DialogService.instance.showProgressDialog(context: context);


      String? url = await SupabaseStorageService.instance.uploadSingleImage(
          imgFilePath: file.path,
          storageRef: "messages",
          storagePath: "images");

      DialogService.instance.hideProgressDialog(context: context);


      if (url != null) {
        MessageModel messageModel = MessageModel(
            messageType: "image",
            message: url,
            id: uuid.v4(),
            chatThreadId: chatThread.value.id ?? '',
            senderId: userModelGlobal.value?.id ?? '',
            sentAt: DateTime.now());

        sendMessage(messageModel: messageModel);
      }
    }
  }

  Stream<List<MessageModel>> fetchMessages(
      {required ChatThreadModel chatThreadModel}) {
    return Supabase.instance.client
        .from(SupabaseConstants().messagesTable)
        .stream(primaryKey: ['id'])
        .eq('chat_thread_id', chatThreadModel.id ?? '')
        .order('sent_at', ascending: true)
        .map((messages) =>
            messages.map((message) => MessageModel.fromMap(message)).toList());
  }

  sendMessage({required MessageModel messageModel}) async {
    final isSent = await SupabaseCRUDService.instance.createDocument(
      tableName: SupabaseConstants().messagesTable,
      data: messageModel.toMap(),
    );

    if (!isSent) return;

    final chatThreadId = messageModel.chatThreadId;

    // Step 1: Get the current thread to know current unread counts and users
    final threadResponse = await Supabase.instance.client
        .from(SupabaseConstants().chatThreadsTable)
        .select()
        .eq('id', chatThreadId)
        .maybeSingle();

    if (threadResponse == null) {
      log("Thread not found when trying to update unread count.");
      return;
    }

    final threadModel = ChatThreadModel.fromMap(threadResponse);

    // Step 2: Determine which count to increase
    final currentUserId = userModelGlobal.value?.id ?? '';
    final isSender = currentUserId == threadModel.senderId;
    final updatedReceiverCount = (threadModel.receiverUnreadCount ?? 0) + (isSender ? 1 : 0);
    final updatedSenderCount = (threadModel.senderUnreadCount ?? 0) + (!isSender ? 1 : 0);

    // Step 3: Update thread in Supabase
    await SupabaseCRUDService.instance.updateDocument(
      tableName: SupabaseConstants().chatThreadsTable,
      id: chatThreadId,
      data: {
        'last_message': messageModel.message,
        'last_message_time': DateTime.now().toIso8601String(),
        'receiver_unread_count': updatedReceiverCount,
        'sender_unread_count': updatedSenderCount,
      },
    );

    // Step 4: Mark the other user's unread flag and send push
    final chatThreadModel = Get.arguments as ChatThreadModel;

    await SupabaseCRUDService.instance.updateDocument(
      tableName: SupabaseConstants().usersTable,
      id: chatThreadModel.otherUserDetail?.id ?? "",
      data: {"unread_message": true},
    );

    OneSignalNotificationService.instance.sendOneSignalNotificationToUser(
      isSaved: false,
      type: NotificationType.message.name,
      externalId: chatThreadModel.otherUserDetail?.id ?? '',
      title: "${userModelGlobal.value?.fullName ?? ''}",
      message: "${messageModel.message}",
    );
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    chatThreadStreamSubscription.cancel();
  }
}
