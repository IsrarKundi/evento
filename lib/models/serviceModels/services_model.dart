import 'package:event_connect/models/availabilityModel/availability_model.dart';
import '../userModel/user_model.dart';

class ServiceModel {
  final String? id;
  final String? serviceImage;
  final String? amount;
  final String? serviceName;
  final String? createdBy;
  final DateTime? createdAt;
  final String? about;
  final String? rating;
  final String? location;
  final bool? advertised;
  final DateTime? advertisedFrom;
  final DateTime? advertisedTill;
  final UserModel? user;
  final AvailabilityModel? availability;
  final bool? perHour;

  ServiceModel({
    this.id,
    this.serviceImage,
    this.amount,
    this.serviceName,
    this.createdBy,
    this.createdAt,
    this.about,
    this.rating,
    this.user,
    this.availability,
    this.location,
    this.advertised,
    this.advertisedFrom,
    this.advertisedTill,
    this.perHour
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as String?,
      serviceImage: map['service_image'] as String?,
      amount: map['amount'] as String?,
      serviceName: map['service_name'] as String?,
      createdBy: map['created_by'] as String?,
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      about: map['about'] as String? ?? '',
      rating: map['rating'] as String? ?? '',
      location: map['location'] as String?,
      advertised: map['advertised'] as bool?,
      advertisedFrom: map['advertised_from'] != null ? DateTime.tryParse(map['advertised_from']) : null,
      advertisedTill: map['advertised_till'] != null ? DateTime.tryParse(map['advertised_till']) : null,
      user: map['user'] != null ? UserModel.fromJson(map['user']) : null,
      availability: map['availability'] != null ? AvailabilityModel.fromMap(map['availability']) : null,
      perHour: map['per_hour'] != null ? map['per_hour'] : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'service_image': serviceImage,
      'amount': amount,
      'per_hour': perHour,
      'service_name': serviceName,
      'location': location,
      'created_by': createdBy,
      'about': about,
      'rating': rating,
      'created_at': createdAt?.toIso8601String(),
      'advertised': advertised,
      'advertised_from': advertisedFrom?.toIso8601String(),
      'advertised_till': advertisedTill?.toIso8601String(),
    };
  }

  // copyWith method to create a new instance with modified properties
  ServiceModel copyWith({
    String? id,
    String? serviceImage,
    String? amount,
    String? serviceName,
    String? createdBy,
    DateTime? createdAt,
    String? about,
    String? rating,
    String? location,
    bool? advertised,
    DateTime? advertisedFrom,
    DateTime? advertisedTill,
    UserModel? user,
    AvailabilityModel? availability,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      serviceImage: serviceImage ?? this.serviceImage,
      amount: amount ?? this.amount,
      serviceName: serviceName ?? this.serviceName,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      about: about ?? this.about,
      rating: rating ?? this.rating,
      location: location ?? this.location,
      advertised: advertised ?? this.advertised,
      advertisedFrom: advertisedFrom ?? this.advertisedFrom,
      advertisedTill: advertisedTill ?? this.advertisedTill,
      user: user ?? this.user,
      availability: availability ?? this.availability,
    );
  }
}
