import 'package:json_annotation/json_annotation.dart';
part 'mobile_md.g.dart';

@JsonSerializable()
class MobileMd {
  String registered;
  String? registered_on;
  String? os;
  int? ping_time;

  bool get isRegistered => registered == 'true';

  @override
  MobileMd({
    required this.registered,
    this.registered_on,
    this.os,
    this.ping_time,
  });

  factory MobileMd.fromJson(Map<String, dynamic> json) =>
      _$MobileMdFromJson(json);

  Map<String, dynamic> toJson() => _$MobileMdToJson(this);
}
