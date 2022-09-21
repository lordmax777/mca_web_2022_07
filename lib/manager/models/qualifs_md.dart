import 'package:json_annotation/json_annotation.dart';
import 'package:mca_web_2022_07/manager/models/users_list.dart';
part 'qualifs_md.g.dart';

@JsonSerializable(anyMap: true)
class QualifsMd {
  int id;
  String title;
  bool expire;
  bool levels;
  int uqId;
  LastTime? achievementDate;
  String certificateNumber;
  LastTime expiryDate;
  String levelId;
  String level;
  String? comments;
  String? certicate;
  String? thumbnail;
  String? imageType;
  LastTime? approvedOn;

  @override
  QualifsMd({
    required this.certificateNumber,
    required this.expire,
    required this.expiryDate,
    required this.id,
    required this.level,
    required this.levelId,
    required this.levels,
    required this.title,
    required this.uqId,
    this.imageType,
    this.achievementDate,
    this.thumbnail,
    this.comments,
    this.approvedOn,
    this.certicate,
  });

  factory QualifsMd.fromJson(Map<String, dynamic> json) =>
      _$QualifsMdFromJson(json);

  Map<String, dynamic> toJson() => _$QualifsMdToJson(this);
}
