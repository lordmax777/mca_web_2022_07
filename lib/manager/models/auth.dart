import 'package:json_annotation/json_annotation.dart';
part 'auth.g.dart';

@JsonSerializable(anyMap: true)
class AuthRes {
  String access_token;
  int expires_in;
  String token_type;
  dynamic scope;
  String refresh_token;

  @override
  AuthRes({
    required this.access_token,
    required this.expires_in,
    required this.refresh_token,
    this.scope,
    required this.token_type,
  });

  factory AuthRes.fromJson(Map<String, dynamic> json) =>
      _$AuthResFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResToJson(this);
}
