

class PortfolioModel {
  final int? id;
  final String createdBy;  // User ID (assuming it's a string like UUID)
  final List<String> images;
  final List<String> videos;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? description;
  final int? duration;  // Duration of the video in seconds
  final String? title;
  final String status;

  // Constructor
  PortfolioModel({
     this.id,
    required this.createdBy,
    required this.images,
    required this.videos,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.duration,
    this.title,
    this.status = 'active',
  });

  // fromJson method to create a PortfolioModel from a map (JSON)
  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['id'],
      createdBy: json['created_by'],
      images: List<String>.from(json['images'] ?? []),
      videos: List<String>.from(json['videos'] ?? []),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      description: json['description'],
      duration: json['duration'],
      title: json['title'],
      status: json['status'] ?? 'active',  // Default to 'active' if not provided
    );
  }

  // toJson method to convert the PortfolioModel into a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'created_by': createdBy,
      'images': images,
      'videos': videos,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'description': description,
      'duration': duration,
      'title': title,
      'status': status,
    };
  }

  // Optional: toString method for easier debugging
  @override
  String toString() {
    return 'PortfolioModel{id: $id, createdBy: $createdBy, images: $images, videos: $videos, createdAt: $createdAt, updatedAt: $updatedAt, description: $description, duration: $duration, title: $title, status: $status}';
  }
}
