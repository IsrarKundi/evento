class CategoryGalleryModel {
  String? id;
  String? categoryName;
  String? mediaUrl;
  String? mediaType; // 'image' or 'video'
  String? description;
  String? createdAt;
  String? updatedAt;

  CategoryGalleryModel({
    this.id,
    this.categoryName,
    this.mediaUrl,
    this.mediaType,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  CategoryGalleryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    mediaUrl = json['media_url'];
    mediaType = json['media_type'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['media_url'] = mediaUrl;
    data['media_type'] = mediaType;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  CategoryGalleryModel copyWith({
    String? id,
    String? categoryName,
    String? mediaUrl,
    String? mediaType,
    String? description,
    String? createdAt,
    String? updatedAt,
  }) {
    return CategoryGalleryModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isImage => mediaType == 'image';
  bool get isVideo => mediaType == 'video';
} 