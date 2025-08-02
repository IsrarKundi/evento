import 'dart:async';
import 'dart:developer';
import 'dart:io';


import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/supabase_constants.dart';
import '../../models/chatModels/chat_participant_model.dart';
import '../../models/chatModels/chat_thread_model.dart';
import '../../models/chatModels/community_chat_thread.dart';
import '../snackbar_service/snackbar.dart';
import '../supabaseService/supbase_crud_service.dart';

class ChattingService extends SupabaseConstants {
  ChattingService._privateConstructor();

  static ChattingService? _instance;

  static ChattingService get instance {
    _instance ??= ChattingService._privateConstructor();
    return _instance!;
  }

  String currentUserid = Supabase.instance.client.auth.currentUser?.id ?? '';

  Future<ChatThreadModel?> createOrGetOneToOneChat(
      {required String senderId, required String receiverId}) async {
    try {
      final response = await supabase
          .from(chatThreadsTable)
          .select('''
      *,
      sender_model:users!chat_threads_sender_id_fkey(*),
      receiver_model:users!chat_threads_receiver_id_fkey(*)
    ''')
          .or('and(sender_id.eq.$senderId, receiver_id.eq.$receiverId), and(sender_id.eq.$receiverId, receiver_id.eq.$senderId)')
          .eq('is_group_chat', false)
          .maybeSingle(); // Fetch single result if exists

      if (response != null) {
        log("chat already exist = ${response}");

        ChatThreadModel chatThreadModel = ChatThreadModel.fromMap(response);
        // Chat thread already exists, return its ID
        return chatThreadModel;
      }
      Uuid uuid = Uuid();

      final newChat = {
        // 'chat_head_id': uuid.v4(),
        'sender_id': senderId,
        'receiver_id': receiverId,
        'is_group_chat': false,
        'created_at': DateTime.now().toIso8601String(),
      };

      final newChatResponse = await supabase
          .from(chatThreadsTable)
          .insert(newChat)
          .select('''
      *,
      sender_model:users!chat_threads_sender_id_fkey(*),
      receiver_model:users!chat_threads_receiver_id_fkey(*)
    ''')
          .single(); // Insert and return new chat thread
      log("chat already not exist = ${newChatResponse}");
      ChatThreadModel chatThreadModel =
          ChatThreadModel.fromMap(newChatResponse);
      CustomSnackBars.instance
          .showSuccessSnackbar(title: "success", message: "Chat Created");
      return chatThreadModel; // Return new chat thread ID
    } catch (e) {
      print('Error creating chat thread: $e');

      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failed", message: "Error creating chat thread: $e");
      return null;
    }
  }

  Future<ChatThreadModel?> createGroupChat(
      String creatorId, String chatTitle, List<String> participantIds,
      {String? chatImage}) async {
    try {
      if (participantIds.isEmpty) {
        print('Error: A group chat must have at least one other participant.');
        CustomSnackBars.instance.showFailureSnackbar(
            title: "Failed",
            message: "A group chat must have at least one other participant");
        return null;
      }
      ChatThreadModel chatThreadModel = ChatThreadModel(
        id: Uuid().v4(),
        chatImage: chatImage ?? '',
        senderId: creatorId,
        chatTitle: chatTitle,
        isGroupChat: true,
        createdAt: DateTime.now(),
      );

      final chatResponse = await supabase
          .from(SupabaseConstants().chatThreadsTable)
          .insert(chatThreadModel.toMap())
          .select()
          .single();

      final chatThreadId = chatResponse['id'];

      final participants = participantIds
          .map((userId) => {
                'chat_thread_id': chatThreadId,
                'user_id': userId,
              })
          .toList();

      participants.add({'chat_thread_id': chatThreadId, 'user_id': creatorId});

      await supabase.from('chat_participants').insert(participants);

      return chatThreadModel;
    } catch (e) {
      print('Error creating group chat: $e');
      return null;
    }
  }

  Future<bool> joinCommunity({required CommunityChatThread communityChatThread}) async {
    try {

      log("joinCommunity called");
      ChatParticipantModel chatParticipantModel = ChatParticipantModel(
        userId: userModelGlobal.value?.id ?? '',
        chatThreadId: communityChatThread.id,
      );

      // Fetch existing records for this user in the chat thread
      var results = await supabase
          .from(communityChatParticipantsTable)
          .select('id') // Only fetch the 'id' field to optimize query
          .eq('chat_thread_id', communityChatThread.id)
          .eq('user_id', userModelGlobal.value?.id ?? '');

      // If user already exists
      if (results.isNotEmpty) {
        log("results.length = ${results.length}");
        if (results.length > 1) {

          // Keep the first entry and delete others
          var entriesToDelete = results.sublist(1); // All except the first one
          for (var entry in entriesToDelete) {

            log("entriesToDelete = $entry");

            await supabase
                .from(communityChatParticipantsTable)
                .delete()
                .match({'id': entry['id']}); // Deleting one by one
          }
        }
        return true; // User is already part of the community
      }

      // If no record exists, insert the new record
      await supabase.from(communityChatParticipantsTable).insert(chatParticipantModel.toMap());

      return true; // Success
    } catch (e) {
      print(getSupabaseErrorMessage(e)); // Logs user-friendly error message
      return false; // Failure
    }
  }




  Stream<List<ChatThreadModel>> streamChatHeads({required String userId}) {
    return supabase
        .from(chatThreadsTable)
        .stream(primaryKey: ['id'])
        .eq('is_group_chat', false).order('last_message_time',ascending: false)
        .map((data) {
          List<ChatThreadModel> tempList = [];
          for (Map<String, dynamic> model in data) {
            ChatThreadModel chatThreadModel = ChatThreadModel.fromMap(model);
            if (chatThreadModel.senderId == userId ||
                chatThreadModel.receiverId == userId) {
              tempList.add(chatThreadModel);
            }
          }
          return tempList;
        }); // Convert to list of models
  }

  Stream<List<Map<String, dynamic>>> streamGroupChats() {
    final controller = StreamController<List<Map<String, dynamic>>>();

    // Fetch initial group chats before subscribing
    Future<void> fetchInitialData() async {
      final response = await supabase
          .from(chatThreadsTable)
          .select('''
              *, chat_participants!inner(*, users!inner(*)) 
          ''')
          .eq('is_group_chat', true)
          .eq('chat_participants.user_id', currentUserid);

      final allChats = List<Map<String, dynamic>>.from(response);
      controller.add(allChats);
    }

    // Call function to fetch initial data
    fetchInitialData();

    // Subscribe to real-time updates
    supabase
        .channel(chatThreadsTable)
        .onPostgresChanges(
          table: chatThreadsTable,
          schema: 'public',
          event: PostgresChangeEvent.all,
          callback: (payload) async {
            final response = await supabase
                .from(chatThreadsTable)
                .select('''
               *, chat_participants!inner(*, users!inner(*)) 
          ''')
                .eq('is_group_chat', true)
                .eq('chat_participants.user_id', currentUserid);

            final allChats = List<Map<String, dynamic>>.from(response);
            controller.add(allChats); // Emit updated data
          },
        )
        .subscribe();

    return controller.stream;
  }

  Stream<List<Map<String, dynamic>>> streamCommunities() {
    final controller = StreamController<List<Map<String, dynamic>>>();

    // Fetch initial group chats before subscribing
    Future<void> fetchInitialData() async {
      final response = await supabase.from(communityThreadsTable).select('''
              *, community_chat_participants(*, users(*)) 
          ''').eq('is_visible', true);

      final allChats = List<Map<String, dynamic>>.from(response);
      controller.add(allChats);
    }

    // Call function to fetch initial data
    fetchInitialData();

    // Subscribe to real-time updates
    supabase
        .channel(communityChatParticipantsTable)
        .onPostgresChanges(
          table: communityChatParticipantsTable,
          schema: 'public',
          event: PostgresChangeEvent.all,
          callback: (payload) async {
            log("Real-time payload = $payload");

            final response =
                await supabase.from(communityThreadsTable).select('''
              *, community_chat_participants(*, users(*)) 
          ''').eq('is_visible', true);

            log("Updated response = $response");

            final allChats = List<Map<String, dynamic>>.from(response);
            controller.add(allChats); // Emit updated data
          },
        )
        .subscribe();

    return controller.stream;
  }
}

String getSupabaseErrorMessage(dynamic exception) {
  if (exception is PostgrestException) {
    return "Database Error: ${exception.message}";
  } else if (exception is AuthException) {
    return "Authentication Error: ${exception.message}";
  } else if (exception is StorageException) {
    return "Storage Error: ${exception.message}";
  } else if (exception is RealtimeSubscribeException) {
    return "Realtime Error: ${exception.status}";
  } else if (exception is TimeoutException) {
    return "Request Timeout: The request took too long to complete.";
  } else if (exception is SocketException) {
    return "Network Error: Please check your internet connection.";
  } else {
    return "Unexpected Error: ${exception.toString()}";
  }
}
