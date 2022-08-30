// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetailsMd _$UserDetailsMdFromJson(Map json) => UserDetailsMd(
      account: UserDetailsAccountMd.fromJson(
          Map<String, dynamic>.from(json['account'] as Map)),
      address: UserDetailsAddressMd.fromJson(
          Map<String, dynamic>.from(json['address'] as Map)),
      date_of_birth: json['date_of_birth'] == null
          ? null
          : LastTime.fromJson(
              Map<String, dynamic>.from(json['date_of_birth'] as Map)),
      ethnic: json['ethnic'] as String,
      first_name: json['first_name'] as String,
      last_name: json['last_name'] as String,
      marital_status: json['marital_status'] as String,
      nationality: json['nationality'] as String,
      next_of_kin: UserDetailsNextOfKinMd.fromJson(
          Map<String, dynamic>.from(json['next_of_kin'] as Map)),
      notes: json['notes'] as String,
      payroll: UserDetailsPayrollMd.fromJson(
          Map<String, dynamic>.from(json['payroll'] as Map)),
      phones: UserDetailsPhonesMd.fromJson(
          Map<String, dynamic>.from(json['phones'] as Map)),
      religion: json['religion'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$UserDetailsMdToJson(UserDetailsMd instance) =>
    <String, dynamic>{
      'title': instance.title,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'date_of_birth': instance.date_of_birth,
      'nationality': instance.nationality,
      'marital_status': instance.marital_status,
      'ethnic': instance.ethnic,
      'religion': instance.religion,
      'address': instance.address,
      'phones': instance.phones,
      'next_of_kin': instance.next_of_kin,
      'payroll': instance.payroll,
      'account': instance.account,
      'notes': instance.notes,
    };

UserDetailsAddressMd _$UserDetailsAddressMdFromJson(Map json) =>
    UserDetailsAddressMd(
      city: json['city'] as String,
      country: json['country'] as String,
      county: json['county'] as String,
      line1: json['line1'] as String,
      line2: json['line2'] as String,
      postcode: json['postcode'] as String,
    );

Map<String, dynamic> _$UserDetailsAddressMdToJson(
        UserDetailsAddressMd instance) =>
    <String, dynamic>{
      'line1': instance.line1,
      'line2': instance.line2,
      'city': instance.city,
      'country': instance.country,
      'postcode': instance.postcode,
      'county': instance.county,
    };

UserDetailsPhonesMd _$UserDetailsPhonesMdFromJson(Map json) =>
    UserDetailsPhonesMd(
      landline: json['landline'] as String,
      mobile: json['mobile'] as String,
    );

Map<String, dynamic> _$UserDetailsPhonesMdToJson(
        UserDetailsPhonesMd instance) =>
    <String, dynamic>{
      'mobile': instance.mobile,
      'landline': instance.landline,
    };

UserDetailsNextOfKinMd _$UserDetailsNextOfKinMdFromJson(Map json) =>
    UserDetailsNextOfKinMd(
      name: json['name'] as String,
      phone: json['phone'] as String,
      relation: json['relation'] as String,
    );

Map<String, dynamic> _$UserDetailsNextOfKinMdToJson(
        UserDetailsNextOfKinMd instance) =>
    <String, dynamic>{
      'name': instance.name,
      'relation': instance.relation,
      'phone': instance.phone,
    };

UserDetailsPayrollMd _$UserDetailsPayrollMdFromJson(Map json) =>
    UserDetailsPayrollMd(
      payroll_code: json['payroll_code'] as String,
      national_insurance: json['national_insurance'] as String,
    );

Map<String, dynamic> _$UserDetailsPayrollMdToJson(
        UserDetailsPayrollMd instance) =>
    <String, dynamic>{
      'payroll_code': instance.payroll_code,
      'national_insurance': instance.national_insurance,
    };

UserDetailsAccountMd _$UserDetailsAccountMdFromJson(Map json) =>
    UserDetailsAccountMd(
      active: json['active'] as bool,
      group: json['group'] as String,
      group_admin: json['group_admin'] as bool,
      location: json['location'] as String,
      location_admin: json['location_admin'] as bool,
      login_methods: json['login_methods'] as String,
      login_required: json['login_required'] as bool,
      locked: json['locked'],
    );

Map<String, dynamic> _$UserDetailsAccountMdToJson(
        UserDetailsAccountMd instance) =>
    <String, dynamic>{
      'active': instance.active,
      'login_required': instance.login_required,
      'group': instance.group,
      'group_admin': instance.group_admin,
      'location': instance.location,
      'location_admin': instance.location_admin,
      'locked': instance.locked,
      'login_methods': instance.login_methods,
    };
