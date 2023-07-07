import 'package:equatable/equatable.dart';

final class DetailsMd extends Equatable {
  //{
  //     "username": "96189831",
  //     "title": "Mr",
  //     "first_name": "Dipen",
  //     "last_name": "Flutter",
  //     "date_of_birth": "",
  //     "location": "",
  //     "department": "",
  //     "locale": "en",
  //     "colour_schema_id": 1,
  //     "role": "ROLE_ADMIN",
  //     "date_format": "d/m/Y",
  //     "fullname_format": "%title% %firstname% %lastname%"
  // }

  final String username;
  final String title;
  final String firstName;
  final String lastName;

  String get fullName {
    String name = "";
    if (title.isNotEmpty) name += "$title ";
    if (firstName.isNotEmpty) name += "$firstName ";
    if (lastName.isNotEmpty) name += lastName;
    return name;
  }

  final String dateOfBirth;
  final String location;
  final String department;
  final String locale;
  final int colourSchemaId;
  final String role;
  final String dateFormat;
  final String fullnameFormat;

  const DetailsMd({
    required this.username,
    required this.title,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.location,
    required this.department,
    required this.locale,
    required this.colourSchemaId,
    required this.role,
    required this.dateFormat,
    required this.fullnameFormat,
  });

  @override
  List<Object?> get props => [
        username,
        title,
        firstName,
        lastName,
        dateOfBirth,
        location,
        department,
        locale,
        colourSchemaId,
        role,
        dateFormat,
        fullnameFormat,
      ];

  //from json
  factory DetailsMd.fromJson(Map<String, dynamic> json) => DetailsMd(
        username: json['username'] ?? "",
        title: json['title'] ?? "",
        firstName: json['first_name'] ?? "",
        lastName: json['last_name'] ?? "",
        dateOfBirth: json['date_of_birth'] ?? "",
        location: json['location'] ?? "",
        department: json['department'] ?? "",
        locale: json['locale'] ?? "",
        colourSchemaId: json['colour_schema_id'] ?? 0,
        role: json['role'] ?? "",
        dateFormat: json['date_format'] ?? "",
        fullnameFormat: json['fullname_format'] ?? "",
      );

  //init
  factory DetailsMd.init() => DetailsMd.fromJson(const {});
}
