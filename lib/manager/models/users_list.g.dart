// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRes _$UserResFromJson(Map json) => UserRes(
      username: json['username'] as String,
      title: json['title'] as String,
      id: json['id'] as int,
      firstName: json['firstName'] as String,
      fullname: json['fullname'] as String,
      lastComment: json['lastComment'] as String?,
      lastIpAddress: json['lastIpAddress'] as String?,
      lastLatitude: (json['lastLatitude'] as num?)?.toDouble(),
      lastLocationId: json['lastLocationId'] as String?,
      lastLongitude: (json['lastLongitude'] as num?)?.toDouble(),
      lastName: json['lastName'] as String,
      lastStatus: json['lastStatus'] as String,
      loginRequired: json['loginRequired'] as bool,
      payrollCode: json['payrollCode'] as String?,
      lastTime: json['lastTime'] == null
          ? null
          : LastTime.fromJson(
              Map<String, dynamic>.from(json['lastTime'] as Map)),
      locked: json['locked'],
      groupId: json['groupId'] as String?,
      groupAdmin: json['groupAdmin'] as bool,
      locationAdmin: json['locationAdmin'] as bool,
      locationId: json['locationId'] as String?,
    );

Map<String, dynamic> _$UserResToJson(UserRes instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'title': instance.title,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'lastTime': instance.lastTime,
      'lastStatus': instance.lastStatus,
      'lastIpAddress': instance.lastIpAddress,
      'lastLocationId': instance.lastLocationId,
      'lastLatitude': instance.lastLatitude,
      'lastLongitude': instance.lastLongitude,
      'payrollCode': instance.payrollCode,
      'lastComment': instance.lastComment,
      'groupId': instance.groupId,
      'locationId': instance.locationId,
      'groupAdmin': instance.groupAdmin,
      'locationAdmin': instance.locationAdmin,
      'loginRequired': instance.loginRequired,
      'locked': instance.locked,
      'fullname': instance.fullname,
    };

LastTime _$LastTimeFromJson(Map json) => LastTime(
      date: json['date'] as String,
      timezone: json['timezone'] as String,
      timezone_type: json['timezone_type'] as int,
    );

Map<String, dynamic> _$LastTimeToJson(LastTime instance) => <String, dynamic>{
      'date': instance.date,
      'timezone_type': instance.timezone_type,
      'timezone': instance.timezone,
    };
