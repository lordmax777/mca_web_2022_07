class ApprovalRequestMd {  int? id;  String? requestOn;  String? requestedBy;  String? location;  String? shiftTime;  String? name;  String? dateTime;  String? comments;  String? status;  List? acceptedBy;  bool? active;  ApprovalRequestMd({    this.id,    this.requestOn,    this.requestedBy,    this.location,    this.shiftTime,    this.name,    this.dateTime,    this.comments,    this.status,    this.acceptedBy,    this.active,  });  ApprovalRequestMd.fromJson(Map<String, dynamic> json) {    id = json['id'];    requestOn = json['requestOn'];    requestedBy = json['requestedBy'];    location = json['location'];    shiftTime = json['shiftTime'];    name = json['name'];    dateTime = json['dateTime'];    comments = json['comments'];    status = json['status'];    acceptedBy = json['acceptedBy'];    active = json['active'];  }  Map<String, dynamic> toJson() {    final Map<String, dynamic> data = <String, dynamic>{};    data['id'] = id;    data['requestOn'] = requestOn;    data['requestedBy'] = requestedBy;    data['location'] = location;    data['shiftTime'] = shiftTime;    data['name'] = name;    data['dateTime'] = dateTime;    data['comments'] = comments;    data['status'] = status;    data['acceptedBy'] = acceptedBy;    data['active'] = active;    return data;  }  factory ApprovalRequestMd.all() {    return ApprovalRequestMd(      id: 0,      requestOn: '',      requestedBy: '',      location: '',      shiftTime: '',      name: '',      dateTime: '',      comments: '',      status: '',      acceptedBy: [],      active: false,    );  }}