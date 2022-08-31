import 'package:json_annotation/json_annotation.dart';
import 'package:mca_web_2022_07/manager/models/users_list.dart';
part 'photos_md.g.dart';

@JsonSerializable()
class PhotosMd {
  String photo;
  int id;
  LastTime createdOn;
  String type;
  int userId;
  int width;
  int height;
  String notes;

  @override
  PhotosMd({
    required this.createdOn,
    required this.height,
    required this.id,
    required this.notes,
    required this.photo,
    required this.type,
    required this.userId,
    required this.width,
  });

  factory PhotosMd.fromJson(Map<String, dynamic> json) =>
      _$PhotosMdFromJson(json);

  Map<String, dynamic> toJson() => _$PhotosMdToJson(this);
}
