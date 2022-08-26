import 'package:json_annotation/json_annotation.dart';
part 'lists_md.g.dart';

@JsonSerializable(anyMap: true)
class ListsMd {
  int id;
  String name;

  @override
  ListsMd({
    required this.name,
    required this.id,
  });

  factory ListsMd.fromJson(Map<String, dynamic> json) =>
      _$ListsMdFromJson(json);

  Map<String, dynamic> toJson() => _$ListsMdToJson(this);
}
