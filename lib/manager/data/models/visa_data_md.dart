import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mca_dashboard/manager/data/data.dart';

final class UserVisaMd extends Equatable {
  // {
  //             "id": 12,
  //             "document_no": "141343",
  //             "startDate": {
  //                 "date": "2020-11-18 00:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "endDate": {
  //                 "date": "2022-11-20 00:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "notExpire": false,
  //             "createdOn": {
  //                 "date": "2022-11-18 10:59:25.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "notes": "test visa expite 20 11",
  //             "title": "EEA family permit"
  //         }
  final int id;
  final String documentNumber;
  final String title;
  VisaMd? visaTypeMd(List<VisaMd> list) =>
      list.firstWhereOrNull((element) => element.name == title);
  final bool hasExpireDate;
  final String startDate;
  DateTime? get startDateMd => DateTime.tryParse(startDate);
  final String endDate;
  DateTime? get endDateMd => DateTime.tryParse(endDate);
  final String notes;

  const UserVisaMd({
    required this.id,
    required this.documentNumber,
    required this.title,
    required this.hasExpireDate,
    required this.startDate,
    required this.endDate,
    required this.notes,
  });

  @override
  List<Object?> get props => [
        id,
        documentNumber,
        title,
        hasExpireDate,
        startDate,
        endDate,
        notes,
      ];

  //fromJson
  factory UserVisaMd.fromJson(Map<String, dynamic> json) {
    return UserVisaMd(
      id: json['id'],
      documentNumber: json['document_no'] ?? "",
      title: json['title'] ?? "",
      hasExpireDate: json['notExpire'] ?? false,
      startDate: json['startDate']?['date'] ?? "",
      endDate: json['endDate']?['date'] ?? "",
      notes: json['notes'] ?? "",
    );
  }
}
