

import 'chat_participant_model.dart';
import 'chat_thread_model.dart';
import 'community_chat_thread.dart';

class GroupChatModel {
  final ChatThreadModel chatThreadModel;
  final List<ChatParticipantModel> chatParticipantModel;

  GroupChatModel({
    required this.chatThreadModel,
    required this.chatParticipantModel,
  });

  factory GroupChatModel.fromJson(Map<String, dynamic> json) {
    return GroupChatModel(
      chatThreadModel: ChatThreadModel.fromMap(json),
      chatParticipantModel: (json['chat_participants'] as List)
          .map((e) => ChatParticipantModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...chatThreadModel.toMap(), // Spreading chatThreadModel fields into the main object
      'chat_participants': chatParticipantModel.map((e) => e.toMap()).toList(),
    };
  }
}



class CommunityChatModel {
  final CommunityChatThread chatThreadModel;
  final List<ChatParticipantModel> chatParticipantModel;

  CommunityChatModel({
    required this.chatThreadModel,
    required this.chatParticipantModel,
  });

  factory CommunityChatModel.fromJson(Map<String, dynamic> json) {
    return CommunityChatModel(
      chatThreadModel: CommunityChatThread.fromJson(json),
      chatParticipantModel: (json['community_chat_participants'] as List)
          .map((e) => ChatParticipantModel.fromMap(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...chatThreadModel.toJson(),
      'community_chat_participants': chatParticipantModel.map((e) => e.toMap()).toList(),
    };
  }
}
