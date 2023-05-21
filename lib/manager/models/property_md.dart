import 'package:mca_web_2022_07/theme/theme.dart';

class PropertiesMd {
  int id;
  String title;
  int locationId;
  String locationName;

  int? clientId;
  String? clientName;
  bool get hasClient => clientId != null;

  String startTime;
  TimeOfDay get startTimeAsTimeOfDay => Constants.isoTimeOfDay(startTime);
  String finishTime;
  TimeOfDay get finishTimeAsTimeOfDay => Constants.isoTimeOfDay(finishTime);

  String? startBreak;
  TimeOfDay? get startBreakAsTimeOfDay =>
      startBreak != null ? Constants.isoTimeOfDay(startBreak!) : null;
  String? finishBreak;
  TimeOfDay? get finishBreakAsTimeOfDay =>
      finishBreak != null ? Constants.isoTimeOfDay(finishBreak!) : null;
  String? fpStartTime;
  TimeOfDay? get fpStartTimeAsTimeOfDay =>
      fpStartTime != null ? Constants.isoTimeOfDay(fpStartTime!) : null;
  String? fpFinishTime;
  TimeOfDay? get fpFinishTimeAsTimeOfDay =>
      fpFinishTime != null ? Constants.isoTimeOfDay(fpFinishTime!) : null;
  String? fpStartBreak;
  TimeOfDay? get fpStartBreakAsTimeOfDay =>
      fpStartBreak != null ? Constants.isoTimeOfDay(fpStartBreak!) : null;
  String? fpFinishBreak;
  bool strictBreak;

  int? warehouseId;
  String? warehouseName;
  int? checklistTemplateId;
  String? checklistTemplateName;
  int? minPaidTime;
  int? minWorkTime;
  bool splitTime;
  bool checklist;
  dynamic days;
  Map<int, String> get parsedDays =>
      days != null ? Constants.parseDays(days) : {};
  bool active;

  String get initials {
    try {
      return title.substring(0, 2).toUpperCase();
    } catch (e) {
      return "??";
    }
  }

  PropertiesMd({
    required this.id,
    required this.title,
    required this.locationId,
    required this.locationName,
    required this.startTime,
    required this.finishTime,
    this.clientId,
    this.clientName,
    this.warehouseId,
    this.warehouseName,
    this.checklistTemplateId,
    this.checklistTemplateName,
    this.startBreak,
    this.finishBreak,
    this.fpStartTime,
    this.fpFinishTime,
    this.fpStartBreak,
    this.fpFinishBreak,
    required this.strictBreak,
    this.minPaidTime,
    this.minWorkTime,
    required this.splitTime,
    required this.checklist,
    this.days,
    required this.active,
  });

  //from json
  factory PropertiesMd.fromJson(Map<String, dynamic> json) {
    try {
      return PropertiesMd(
        id: json['id'],
        title: json['title'],
        locationId: json['locationId'],
        locationName: json['locationName'],
        clientId: json['clientId'],
        clientName: json['clientName'],
        warehouseId: json['warehouseId'],
        warehouseName: json['warehouseName'],
        checklistTemplateId: json['checklistTemplateId'],
        checklistTemplateName: json['checklistTemplateName'],
        startTime: json['startTime'],
        finishTime: json['finishTime'],
        startBreak: json['startBreak'],
        finishBreak: json['finishBreak'],
        fpStartTime: json['fpStartTime'],
        fpFinishTime: json['fpFinishTime'],
        fpStartBreak: json['fpStartBreak'],
        fpFinishBreak: json['fpFinishBreak'],
        strictBreak: json['strictBreak'] ?? false,
        minPaidTime: json['minPaidTime'],
        minWorkTime: json['minWorkTime'],
        splitTime: json['splitTime'] ?? false,
        checklist: json['checklist'] ?? false,
        days: json['days'],
        active: json['active'] ?? false,
      );
    } on TypeError catch (e) {
      print('PropertiesMd.fromJson: ${e.stackTrace}');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['locationId'] = locationId;
    data['locationName'] = locationName;
    data['clientId'] = clientId;
    data['clientName'] = clientName;
    data['warehouseId'] = warehouseId;
    data['warehouseName'] = warehouseName;
    data['checklistTemplateId'] = checklistTemplateId;
    data['checklistTemplateName'] = checklistTemplateName;
    data['startTime'] = startTime;
    data['finishTime'] = finishTime;
    data['startBreak'] = startBreak;
    data['finishBreak'] = finishBreak;
    data['fpStartTime'] = fpStartTime;
    data['fpFinishTime'] = fpFinishTime;
    data['fpStartBreak'] = fpStartBreak;
    data['fpFinishBreak'] = fpFinishBreak;
    data['strictBreak'] = strictBreak;
    data['minPaidTime'] = minPaidTime;
    data['minWorkTime'] = minWorkTime;
    data['splitTime'] = splitTime;
    data['checklist'] = checklist;
    data['days'] = days;
    data['active'] = active;
    return data;
  }

  factory PropertiesMd.all() {
    return PropertiesMd(
      id: 0,
      title: 'All',
      locationId: 0,
      locationName: 'All',
      clientId: 0,
      clientName: 'All',
      warehouseId: 0,
      warehouseName: 'All',
      checklistTemplateId: 0,
      checklistTemplateName: 'All',
      startTime: '00:00',
      finishTime: '00:00',
      startBreak: '00:00',
      finishBreak: '00:00',
      fpStartTime: '00:00',
      fpFinishTime: '00:00',
      fpStartBreak: '00:00',
      fpFinishBreak: '00:00',
      strictBreak: false,
      minPaidTime: 0,
      minWorkTime: 0,
      splitTime: false,
      checklist: false,
      days: null,
      active: true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PropertiesMd &&
        other.id == id &&
        other.title == title &&
        other.locationId == locationId &&
        other.locationName == locationName &&
        other.clientId == clientId &&
        other.clientName == clientName &&
        other.warehouseId == warehouseId &&
        other.warehouseName == warehouseName &&
        other.checklistTemplateId == checklistTemplateId &&
        other.checklistTemplateName == checklistTemplateName &&
        other.startTime == startTime &&
        other.finishTime == finishTime &&
        other.startBreak == startBreak &&
        other.finishBreak == finishBreak &&
        other.fpStartTime == fpStartTime &&
        other.fpFinishTime == fpFinishTime &&
        other.fpStartBreak == fpStartBreak &&
        other.fpFinishBreak == fpFinishBreak &&
        other.strictBreak == strictBreak &&
        other.minPaidTime == minPaidTime &&
        other.minWorkTime == minWorkTime &&
        other.splitTime == splitTime &&
        other.checklist == checklist &&
        other.days == days &&
        other.active == active;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        locationId.hashCode ^
        locationName.hashCode ^
        clientId.hashCode ^
        clientName.hashCode ^
        warehouseId.hashCode ^
        warehouseName.hashCode ^
        checklistTemplateId.hashCode ^
        checklistTemplateName.hashCode ^
        startTime.hashCode ^
        finishTime.hashCode ^
        startBreak.hashCode ^
        finishBreak.hashCode ^
        fpStartTime.hashCode ^
        fpFinishTime.hashCode ^
        fpStartBreak.hashCode ^
        fpFinishBreak.hashCode ^
        strictBreak.hashCode ^
        minPaidTime.hashCode ^
        minWorkTime.hashCode ^
        splitTime.hashCode ^
        checklist.hashCode ^
        days.hashCode ^
        active.hashCode;
  }
}
