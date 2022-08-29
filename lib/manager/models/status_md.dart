import 'package:json_annotation/json_annotation.dart';
part 'status_md.g.dart';

@JsonSerializable()
class StatussMd {
  int? id;
  String? name;
  String? comment;
  double? latitude;
  double? longitude;
  bool? whithin_range;
  String? shift;
  String? location;
  String? mode;
  String? timestamp;
  String? created_on;

  @override
  StatussMd({
    this.comment,
    this.created_on,
    this.id,
    this.latitude,
    this.location,
    this.longitude,
    this.mode,
    this.name,
    this.shift,
    this.timestamp,
    this.whithin_range,
  });

  factory StatussMd.fromJson(Map<String, dynamic> json) =>
      _$StatussMdFromJson(json);

  Map<String, dynamic> toJson() => _$StatussMdToJson(this);
}
