class ReportModel {
  String? id;
  String? reportedBy; // User ID who reported
  String? reportedService; // Service ID being reported
  String? reportNote; // Report description/reason
  String? createdAt;
  String? updatedAt;

  ReportModel({
    this.id,
    this.reportedBy,
    this.reportedService,
    this.reportNote,
    this.createdAt,
    this.updatedAt,
  });

  ReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportedBy = json['reported_by'];
    reportedService = json['reported_service'];
    reportNote = json['report_note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reported_by'] = reportedBy;
    data['reported_service'] = reportedService;
    data['report_note'] = reportNote;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  ReportModel copyWith({
    String? id,
    String? reportedBy,
    String? reportedService,
    String? reportNote,
    String? createdAt,
    String? updatedAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      reportedBy: reportedBy ?? this.reportedBy,
      reportedService: reportedService ?? this.reportedService,
      reportNote: reportNote ?? this.reportNote,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 