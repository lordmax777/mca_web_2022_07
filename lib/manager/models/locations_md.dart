import 'package:json_annotation/json_annotation.dart';
part 'locations_md.g.dart';

@JsonSerializable(anyMap: true)
class LocationsMd {
  int id;
  String name;

  @override
  LocationsMd({
    required this.name,
    required this.id,
  });

  factory LocationsMd.fromJson(Map<String, dynamic> json) =>
      _$LocationsMdFromJson(json);

  Map<String, dynamic> toJson() => _$LocationsMdToJson(this);
}
