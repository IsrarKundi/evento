class CommunityChatThread {
  final String id;
  final String? lastMessage;
  final DateTime lastMessageTime;
  final String createrId;
  final String? chatTitle;
  final String? chatImage;
  final String? description;
  final bool isVisible;
  final bool isPrivate;
  final DateTime createdAt;

  CommunityChatThread({
    required this.id,
    this.lastMessage,
    required this.lastMessageTime,
    required this.createrId,
    this.chatTitle,
    this.chatImage,
    this.description,
    this.isVisible = true,
    this.isPrivate = false,
    required this.createdAt,
  });

  // Factory method to create an object from JSON
  factory CommunityChatThread.fromJson(Map<String, dynamic> json) {
    return CommunityChatThread(
      id: json['id'] as String,
      lastMessage: json['last_message'] as String?,
      lastMessageTime: DateTime.parse(json['last_message_time']),
      createrId: json['creater_id'] as String,
      chatTitle: json['chat_title'] as String?,
      chatImage: json['chat_image'] as String?,
      description: json['description'] as String?,
      isVisible: json['is_visible'] ?? true,
      isPrivate: json['is_private'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Method to convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime.toIso8601String(),
      'creater_id': createrId,
      'chat_title': chatTitle,
      'chat_image': chatImage,
      'description': description,
      'is_visible': isVisible,
      'is_private': isPrivate,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
