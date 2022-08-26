import 'package:json_annotation/json_annotation.dart';
part 'statuses_md.g.dart';

@JsonSerializable(anyMap: true)
class StatusMd {
  String nameStart;
  String nameFinish;
  bool active;
  String activeName;
  int level;
  String levelName;
  bool multi;
  String color;
  String colorName;
  List<DomainsMd> domains;
  int finishId;
  String finishColor;

  @override
  StatusMd({
    required this.active,
    required this.activeName,
    required this.color,
    required this.colorName,
    required this.domains,
    required this.finishColor,
    required this.finishId,
    required this.level,
    required this.levelName,
    required this.multi,
    required this.nameFinish,
    required this.nameStart,
  });

  factory StatusMd.fromJson(Map<String, dynamic> json) =>
      _$StatusMdFromJson(json);

  Map<String, dynamic> toJson() => _$StatusMdToJson(this);
}

@JsonSerializable(anyMap: true)
class DomainsMd {
  int id;

  @override
  DomainsMd({
    required this.id,
  });

  factory DomainsMd.fromJson(Map<String, dynamic> json) =>
      _$DomainsMdFromJson(json);

  Map<String, dynamic> toJson() => _$DomainsMdToJson(this);
}
