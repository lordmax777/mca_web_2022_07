// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRes _$AuthResFromJson(Map json) => AuthRes(
      access_token: json['access_token'] as String,
      expires_in: json['expires_in'] as int,
      refresh_token: json['refresh_token'] as String,
      scope: json['scope'],
      token_type: json['token_type'] as String,
    );

Map<String, dynamic> _$AuthResToJson(AuthRes instance) => <String, dynamic>{
      'access_token': instance.access_token,
      'expires_in': instance.expires_in,
      'token_type': instance.token_type,
      'scope': instance.scope,
      'refresh_token': instance.refresh_token,
    };
