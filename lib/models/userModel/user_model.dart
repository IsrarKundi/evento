import 'package:event_connect/main.dart';

class UserModel {
  final String? id;
  final String? fullName,profileImage,bio;
  final String? email;
  final String? phoneNo;
  final String? phoneCode;
  final String? completePhoneNo;
  final String? userType;
  final String? location;
  final String? language;
  final String? signupType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? isRoleSelected;
  final bool? isProfileSetup;
  final bool? unreadNotification;
  final bool? unreadMessage;

  UserModel({
    this.id,
    this.fullName,
    this.profileImage,
    this.bio,
    this.email,
    this.phoneNo,
    this.phoneCode,
    this.completePhoneNo,
    this.userType,
    this.location,
    this.language,
    this.signupType,
    this.createdAt,
    this.updatedAt,
    this.isRoleSelected,
    this.isProfileSetup,
    this.unreadNotification,
    this.unreadMessage,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      fullName: map['full_name'],
      bio: map['bio']??"",
      profileImage: map['profile_image']??dummyProfileUrl,
      email: map['email'],
      phoneNo: map['phone_no'],
      phoneCode: map['phone_code'],
      completePhoneNo: map['complete_phone_no'],
      userType: map['user_type'],
      location: map['location'],
      language: map['language'],
      signupType: map['signup_type'],
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
      updatedAt: map['updated_at'] != null ? DateTime.tryParse(map['updated_at']) : null,
      isRoleSelected: map['is_role_selected']??false,
      isProfileSetup: map['is_profile_setup']??false,
      unreadNotification: map['unread_notification']??false,
      unreadMessage: map['unread_message']??false,
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'full_name': fullName,
      'profile_image':profileImage,
      'bio':bio,
      'email': email,
      'phone_no': phoneNo,
      'phone_code': phoneCode,
      'complete_phone_no': completePhoneNo,
      'user_type': userType,
      'location': location,
      'language': language,
      'signup_type': signupType,
      // 'created_at': createdAt?.toIso8601String(),
      // 'updated_at': updatedAt?.toIso8601String(),
      'is_role_selected': isRoleSelected,
      'unread_notification': unreadNotification,
      'unread_message': unreadMessage,
    };
  }
}
