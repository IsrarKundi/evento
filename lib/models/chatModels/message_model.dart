class MessageModel {
  final String id;
  final String chatThreadId;
  final String senderId;
  final DateTime sentAt;
  final String messageType,message;

  MessageModel({
    required this.id,
    required this.chatThreadId,
    required this.senderId,
    required this.sentAt,
    this.messageType = 'text',
    required this.message,
  });

  /// Convert model to a map (for inserting/updating in Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_thread_id': chatThreadId,
      'sender_id': senderId,
      'sent_at': sentAt.toIso8601String(),
      'message_type': messageType,
      'message': message,
    };
  }

  /// Convert a map (from Supabase) into a MessageModel object
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      chatThreadId: map['chat_thread_id'],
      senderId: map['sender_id'],
      sentAt: DateTime.parse(map['sent_at']),
      messageType: map['message_type'] ?? 'text',
      message: map['message'] ?? '',
    );
  }
}
