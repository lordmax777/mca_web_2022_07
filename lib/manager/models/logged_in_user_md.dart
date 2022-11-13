class LoggedInUserMd {
  String? username;
  String? title;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? location;
  String? department;
  String? locale;
  int? colourSchemaId;
  String? role;
  String? dateFormat;
  String? fullnameFormat;

  LoggedInUserMd(
      {this.username,
      this.title,
      this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.location,
      this.department,
      this.locale,
      this.colourSchemaId,
      this.role,
      this.dateFormat,
      this.fullnameFormat});

  LoggedInUserMd.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    title = json['title'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    location = json['location'];
    department = json['department'];
    locale = json['locale'];
    colourSchemaId = json['colour_schema_id'];
    role = json['role'];
    dateFormat = json['date_format'];
    fullnameFormat = json['fullname_format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['title'] = this.title;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['date_of_birth'] = this.dateOfBirth;
    data['location'] = this.location;
    data['department'] = this.department;
    data['locale'] = this.locale;
    data['colour_schema_id'] = this.colourSchemaId;
    data['role'] = this.role;
    data['date_format'] = this.dateFormat;
    data['fullname_format'] = this.fullnameFormat;
    return data;
  }
}
