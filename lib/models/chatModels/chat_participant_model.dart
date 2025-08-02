

import '../userModel/user_model.dart';

class ChatParticipantModel {
  String? id; // UUID for the chat participant record
  String? chatThreadId; // Foreign key to chat_threads
  String? userId; // Foreign key to users
  DateTime? joinedAt;
  UserModel? users;

  ChatParticipantModel({
    this.id,
    this.chatThreadId,
    this.userId,
    this.joinedAt,
    this.users,
  });

  /// Convert model to a map for inserting/updating in Supabase
  Map<String, dynamic> toMap() {
    return {
      if(id!=null)'id': id,
      'chat_thread_id': chatThreadId,
      'user_id': userId,
      if(joinedAt!=null) 'joined_at': joinedAt?.toIso8601String(),
      if(users!=null) 'users': users?.toJson(),
    };
  }



  /// Convert a map (from Supabase) into a ChatParticipantModel object
  factory ChatParticipantModel.fromMap(Map<String, dynamic> map) {
    return ChatParticipantModel(
      id: map['id'],
      chatThreadId: map['chat_thread_id'],
      userId: map['user_id'],
      joinedAt: map['joined_at'] != null ? DateTime.parse(map['joined_at']) : null,
      users: map.containsKey('users')?UserModel.fromJson(map['users']):null
    );
  }
}
