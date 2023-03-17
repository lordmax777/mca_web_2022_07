class PropertiesMd {
  int? id;
  String? title;
  int? locationId;
  String? startTime;
  String? finishTime;
  String? locationName;
  int? clientId;
  String? clientName;
  int? warehouseId;
  String? warehouseName;
  int? checklistTemplateId;
  String? checklistTemplateName;
  String? startBreak;
  String? finishBreak;
  String? fpStartTime;
  String? fpFinishTime;
  String? fpStartBreak;
  String? fpFinishBreak;
  bool? strictBreak;
  int? minPaidTime;
  int? minWorkTime;
  bool? splitTime;
  bool? checklist;
  dynamic linked;
  dynamic days;
  bool? active;

  PropertiesMd(
      {this.id,
      this.title,
      this.locationId,
      this.locationName,
      this.clientId,
      this.clientName,
      this.warehouseId,
      this.warehouseName,
      this.checklistTemplateId,
      this.checklistTemplateName,
      this.startTime,
      this.finishTime,
      this.startBreak,
      this.finishBreak,
      this.fpStartTime,
      this.fpFinishTime,
      this.fpStartBreak,
      this.fpFinishBreak,
      this.strictBreak,
      this.minPaidTime,
      this.minWorkTime,
      this.splitTime,
      this.checklist,
      this.linked,
      this.days,
      this.active});

  PropertiesMd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    locationId = json['locationId'];
    locationName = json['locationName'];
    clientId = json['clientId'];
    clientName = json['clientName'];
    warehouseId = json['warehouseId'];
    warehouseName = json['warehouseName'];
    checklistTemplateId = json['checklistTemplateId'];
    checklistTemplateName = json['checklistTemplateName'];
    startTime = json['startTime'];
    finishTime = json['finishTime'];
    startBreak = json['startBreak'];
    finishBreak = json['finishBreak'];
    fpStartTime = json['fpStartTime'];
    fpFinishTime = json['fpFinishTime'];
    fpStartBreak = json['fpStartBreak'];
    fpFinishBreak = json['fpFinishBreak'];
    strictBreak = json['strictBreak'];
    minPaidTime = json['minPaidTime'];
    minWorkTime = json['minWorkTime'];
    splitTime = json['splitTime'];
    checklist = json['checklist'];
    linked = json['linked'];
    days = json['days'];
    active = json['active'];
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
    data['linked'] = linked;
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
      linked: null,
      days: null,
      active: true,
    );
  }
}
