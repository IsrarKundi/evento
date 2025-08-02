class NotificationModel {
  final String? id; // optional
  final String sentBy;
  final String sentTo;
  final String title;
  final String body;
  final String type;
  final DateTime? sentAt;

  NotificationModel({
    this.id,
    required this.sentBy,
    required this.sentTo,
    required this.title,
    required this.body,
    required this.type,
     this.sentAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String?,
      sentBy: json['sent_by'] as String,
      sentTo: json['sent_to'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      sentAt: DateTime.parse(json['sent_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sent_by': sentBy,
      'sent_to': sentTo,
      'title': title,
      'body': body,
      'type': type,
      // 'sent_at': sentAt.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? sentBy,
    String? sentTo,
    String? title,
    String? body,
    String? type,
    DateTime? sentAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      sentBy: sentBy ?? this.sentBy,
      sentTo: sentTo ?? this.sentTo,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}
