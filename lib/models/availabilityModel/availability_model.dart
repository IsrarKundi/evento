class AvailabilityModel {
  final String? id;
  final String createdBy;
  final String? serviceId;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> availableTimes;
  final List<DateTime> selectedDates; // ✅ New field
  final DateTime? createdAt;

  AvailabilityModel({
    this.id,
    required this.createdBy,
    this.serviceId,
    required this.startDate,
    required this.endDate,
    required this.availableTimes,
    required this.selectedDates,
    this.createdAt,
  });

  factory AvailabilityModel.fromMap(Map<String, dynamic> map) {
    return AvailabilityModel(
      id: map['id'],
      createdBy: map['created_by'],
      serviceId: map['service_id'] ?? "",
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      availableTimes: List<String>.from(map['available_times'] ?? []),
      selectedDates: map['selected_dates'] != null
          ? List<String>.from(map['selected_dates'])
          .map((date) => DateTime.parse(date))
          .toList()
          : [],
      createdAt:
      map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'created_by': createdBy,
      'service_id': serviceId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'available_times': availableTimes,
      'selected_dates': selectedDates
          .map((date) => date.toIso8601String())
          .toList(), // ✅ Save as string list
    };
  }
}
