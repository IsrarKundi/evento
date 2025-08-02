import '../userModel/user_model.dart';

class ChatThreadModel {
  String? id;
  String? lastMessage;
  DateTime? lastMessageTime;
  String? receiverId;
  String? senderId;
  String? chatTitle;
  String? chatImage;
  int? receiverUnreadCount;
  int? senderUnreadCount;
  String? receiverName;
  String? senderName;
  String? receiverProfileImage;
  String? senderProfileImage;
  bool? seenMessagesBySender;
  bool? seenMessagesByReceiver;
  bool? hide;
  bool? isGroupChat;
  bool? block; // ✅ new field
  String? blockBy; // ✅ new field
  DateTime? createdAt;
  UserModel? otherUserDetail;
  UserModel? senderModel;
  UserModel? receiverModel;

  ChatThreadModel({
    this.id,
    this.lastMessage,
    this.lastMessageTime,
    this.receiverId,
    this.senderId,
    this.chatTitle,
    this.chatImage,
    this.receiverUnreadCount,
    this.senderUnreadCount,
    this.receiverName,
    this.senderName,
    this.receiverProfileImage,
    this.senderProfileImage,
    this.seenMessagesBySender = false,
    this.seenMessagesByReceiver = false,
    this.hide = false,
    this.isGroupChat = false,
    this.block,
    this.blockBy,
    this.createdAt,
    this.otherUserDetail,
    this.senderModel,
    this.receiverModel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime?.toIso8601String(),
      'receiver_id': receiverId,
      'sender_id': senderId,
      'chat_title': chatTitle,
      'chat_image': chatImage,
      'receiver_unread_count': receiverUnreadCount ?? 0,
      'sender_unread_count': senderUnreadCount ?? 0,
      'receiver_name': receiverName,
      'sender_name': senderName,
      'receiver_profile_image': receiverProfileImage,
      'sender_profile_image': senderProfileImage,
      'seen_messages_by_sender': seenMessagesBySender ?? false,
      'seen_messages_by_receiver': seenMessagesByReceiver ?? false,
      'hide': hide ?? false,
      'is_group_chat': isGroupChat ?? false,
      'block': block,
      'block_by': blockBy,
      'created_at': createdAt?.toIso8601String(),
      if (otherUserDetail != null) 'other_user_detail': otherUserDetail?.toJson(),
    };
  }

  factory ChatThreadModel.fromMap(Map<String, dynamic> map) {
    return ChatThreadModel(
      id: map['id'],
      lastMessage: map['last_message'],
      lastMessageTime: map['last_message_time'] != null
          ? DateTime.parse(map['last_message_time'])
          : null,
      receiverId: map['receiver_id'],
      senderId: map['sender_id'],
      chatTitle: map['chat_title'],
      chatImage: map['chat_image'],
      receiverUnreadCount: map['receiver_unread_count'] ?? 0,
      senderUnreadCount: map['sender_unread_count'] ?? 0,
      receiverName: map['receiver_name'],
      senderName: map['sender_name'],
      receiverProfileImage: map['receiver_profile_image'],
      senderProfileImage: map['sender_profile_image'],
      seenMessagesBySender: map['seen_messages_by_sender'] ?? false,
      seenMessagesByReceiver: map['seen_messages_by_receiver'] ?? false,
      hide: map['hide'] ?? false,
      isGroupChat: map['is_group_chat'] ?? false,
      block: map['block'],
      blockBy: map['block_by'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      otherUserDetail: map['other_user_detail'] != null
          ? UserModel.fromJson(map['other_user_detail'])
          : null,
      senderModel: map['sender_model'] != null ? UserModel.fromJson(map['sender_model']) : null,
      receiverModel: map['receiver_model'] != null ? UserModel.fromJson(map['receiver_model']) : null,
    );
  }

  ChatThreadModel copyWith({
    String? id,
    String? lastMessage,
    DateTime? lastMessageTime,
    String? receiverId,
    String? senderId,
    String? chatTitle,
    String? chatImage,
    int? receiverUnreadCount,
    int? senderUnreadCount,
    String? receiverName,
    String? senderName,
    String? receiverProfileImage,
    String? senderProfileImage,
    bool? seenMessagesBySender,
    bool? seenMessagesByReceiver,
    bool? hide,
    bool? isGroupChat,
    bool? block, // ✅ added
    String? blockBy, // ✅ added
    DateTime? createdAt,
    UserModel? otherUserDetail,
  }) {
    return ChatThreadModel(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      receiverId: receiverId ?? this.receiverId,
      senderId: senderId ?? this.senderId,
      chatTitle: chatTitle ?? this.chatTitle,
      chatImage: chatImage ?? this.chatImage,
      receiverUnreadCount: receiverUnreadCount ?? this.receiverUnreadCount,
      senderUnreadCount: senderUnreadCount ?? this.senderUnreadCount,
      receiverName: receiverName ?? this.receiverName,
      senderName: senderName ?? this.senderName,
      receiverProfileImage: receiverProfileImage ?? this.receiverProfileImage,
      senderProfileImage: senderProfileImage ?? this.senderProfileImage,
      seenMessagesBySender: seenMessagesBySender ?? this.seenMessagesBySender,
      seenMessagesByReceiver: seenMessagesByReceiver ?? this.seenMessagesByReceiver,
      hide: hide ?? this.hide,
      isGroupChat: isGroupChat ?? this.isGroupChat,
      block: block ?? this.block,
      blockBy: blockBy ?? this.blockBy,
      createdAt: createdAt ?? this.createdAt,
      otherUserDetail: otherUserDetail ?? this.otherUserDetail,
    );
  }
}
