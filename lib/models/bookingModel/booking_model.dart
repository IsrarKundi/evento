import 'package:event_connect/models/serviceModels/services_model.dart';
import 'package:event_connect/models/userModel/user_model.dart';

class BookingModel {
  final String? id; // optional since it's auto-generated
  final DateTime selectedDate;
  final String selectedTime;
  final String supplierId;
  final String bookedBy;
  final DateTime? bookedAt;
  final String? bookingStatus;
  final UserModel? userModel;
  final UserModel? supplierModel;
  final String serviceId;
  final ServiceModel? serviceModel;

  BookingModel({
    this.id,
    this.userModel,
    this.supplierModel,
    required this.selectedDate,
    required this.selectedTime,
    required this.supplierId,
    required this.bookedBy,
    required this.serviceId,
    this.bookedAt,
    this.bookingStatus,
    this.serviceModel,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'],
      selectedDate: DateTime.parse(map['selected_date']),
      selectedTime: map['selected_time'],
      supplierId: map['supplier_id'],
      bookedBy: map['booked_by'],
      serviceId: map['service_id'] ?? '',
      bookedAt: map['booked_at'] != null ? DateTime.parse(map['booked_at']) : null,
      bookingStatus: map['booking_status'] ?? "upcoming",
      userModel: map['user_model'] != null ? UserModel.fromJson(map['user_model']) : null,
      supplierModel: map['supplier_model'] != null ? UserModel.fromJson(map['supplier_model']) : null,
      serviceModel: map['service_model'] != null ? ServiceModel.fromMap(map['service_model']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selected_date': selectedDate.toIso8601String(),
      'selected_time': selectedTime,
      'supplier_id': supplierId,
      'booked_by': bookedBy,
      'service_id': serviceId,
      'booking_status': bookingStatus,
    };
  }

  BookingModel copyWith({
    String? id,
    DateTime? selectedDate,
    String? selectedTime,
    String? supplierId,
    String? bookedBy,
    DateTime? bookedAt,
    String? bookingStatus,
    UserModel? userModel,
    UserModel? supplierModel,
    String? serviceId,
    ServiceModel? serviceModel,
  }) {
    return BookingModel(
      id: id ?? this.id,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      supplierId: supplierId ?? this.supplierId,
      bookedBy: bookedBy ?? this.bookedBy,
      bookedAt: bookedAt ?? this.bookedAt,
      bookingStatus: bookingStatus ?? this.bookingStatus,
      userModel: userModel ?? this.userModel,
      supplierModel: supplierModel ?? this.supplierModel,
      serviceId: serviceId ?? this.serviceId,
      serviceModel: serviceModel ?? this.serviceModel,
    );
  }
}
