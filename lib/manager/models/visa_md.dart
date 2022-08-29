import 'package:json_annotation/json_annotation.dart';

import 'users_list.dart';
part 'visa_md.g.dart';

@JsonSerializable(anyMap: true)
class VisaMd {
  int id;
  String document_no;
  LastTime startDate;
  LastTime? endDate;
  bool notExpire;
  LastTime createdOn;
  String notes;
  String title;
  @override
  VisaMd({
    required this.createdOn,
    required this.document_no,
    required this.title,
    required this.notes,
    this.endDate,
    required this.id,
    required this.notExpire,
    required this.startDate,
  });

  factory VisaMd.fromJson(Map<String, dynamic> json) => _$VisaMdFromJson(json);

  Map<String, dynamic> toJson() => _$VisaMdToJson(this);
}
