class AvailabilityModel {
  String? id;
  List<DateTime> selectedDates;
  DateTime startDate;
  DateTime endDate;
  List<String> availableTimes;
  String createdBy;
  Map<String, List<String>>? slotsPerDate; // Add this new field

  AvailabilityModel({
    this.id,
    required this.selectedDates,
    required this.startDate,
    required this.endDate,
    required this.availableTimes,
    required this.createdBy,
    this.slotsPerDate, // Add this parameter
  });

  factory AvailabilityModel.fromMap(Map<String, dynamic> map) {
    return AvailabilityModel(
      id: map['id']?.toString(),
      selectedDates: (map['selected_dates'] as List<dynamic>?)
              ?.map((e) => DateTime.parse(e.toString()))
              .toList() ??
          [],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      availableTimes: List<String>.from(map['available_times'] ?? []),
      createdBy: map['created_by'] ?? '',
      slotsPerDate: map['slots_per_date'] != null 
          ? Map<String, List<String>>.from(
              (map['slots_per_date'] as Map).map(
                (key, value) => MapEntry(key.toString(), List<String>.from(value))
              )
            )
          : null, // Add this field parsing
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'selected_dates': selectedDates.map((date) => date.toIso8601String()).toList(),
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'available_times': availableTimes,
      'created_by': createdBy,
      if (slotsPerDate != null) 'slots_per_date': slotsPerDate, // Add this field to map
    };
  }
}