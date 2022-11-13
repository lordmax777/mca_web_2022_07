// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_all_md.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListAllMd _$ListAllMdFromJson(Map<String, dynamic> json) => ListAllMd(
      countries: (json['countries'] as List<dynamic>)
          .map((e) => ListCountry.fromJson(e as Map<String, dynamic>))
          .toList(),
      holiday_calculation_types:
          (json['holiday_calculation_types'] as List<dynamic>)
              .map((e) =>
                  HolidayCalculationTypes.fromJson(e as Map<String, dynamic>))
              .toList(),
      currencies: (json['currencies'] as List<dynamic>)
          .map((e) => ListCurrency.fromJson(e as Map<String, dynamic>))
          .toList(),
      ethnics: (json['ethnics'] as List<dynamic>)
          .map((e) => ListEthnic.fromJson(e as Map<String, dynamic>))
          .toList(),
      groups: (json['groups'] as List<dynamic>)
          .map((e) => ListGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      handover_types: (json['handover_types'] as List<dynamic>)
          .map((e) => ListHandoverType.fromJson(e as Map<String, dynamic>))
          .toList(),
      jobtitles: (json['jobtitles'] as List<dynamic>)
          .map((e) => ListJobTitle.fromJson(e as Map<String, dynamic>))
          .toList(),
      locations: (json['locations'] as List<dynamic>)
          .map((e) => ListLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualification_levels: (json['qualification_levels'] as List<dynamic>)
          .map(
              (e) => ListQualificationLevel.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualifications: (json['qualifications'] as List<dynamic>)
          .map((e) => ListQualification.fromJson(e as Map<String, dynamic>))
          .toList(),
      religions: (json['religions'] as List<dynamic>)
          .map((e) => ListReligion.fromJson(e as Map<String, dynamic>))
          .toList(),
      request_types: (json['request_types'] as List<dynamic>)
          .map((e) => ListRequestType.fromJson(e as Map<String, dynamic>))
          .toList(),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => ListRole.fromJson(e as Map<String, dynamic>))
          .toList(),
      shifts: (json['shifts'] as List<dynamic>)
          .map((e) => ListShift.fromJson(e as Map<String, dynamic>))
          .toList(),
      special_rates: (json['special_rates'] as List<dynamic>)
          .map((e) => ListSpecialRate.fromJson(e as Map<String, dynamic>))
          .toList(),
      statuses: (json['statuses'] as List<dynamic>)
          .map((e) => ListStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
      storage_items: (json['storage_items'] as List<dynamic>)
          .map((e) => ListStorageItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      storages: (json['storages'] as List<dynamic>)
          .map((e) => ListStorage.fromJson(e as Map<String, dynamic>))
          .toList(),
      visas: (json['visas'] as List<dynamic>)
          .map((e) => ListVisa.fromJson(e as Map<String, dynamic>))
          .toList(),
      login_methods: (json['login_methods'] as List<dynamic>)
          .map((e) => LoginMethods.fromJson(e as Map<String, dynamic>))
          .toList(),
      marital_statuses: (json['marital_statuses'] as List<dynamic>)
          .map((e) => MaritalStatuses.fromJson(e as Map<String, dynamic>))
          .toList(),
      contract_types: (json['contract_types'] as List<dynamic>)
          .map((e) => ContractTypes.fromJson(e as Map<String, dynamic>))
          .toList(),
      contract_starts: (json['contract_starts'] as List<dynamic>)
          .map((e) => ContractStarts.fromJson(e as Map<String, dynamic>))
          .toList(),
      color_schemas: (json['color_schemas'] as List<dynamic>)
          .map((e) => ColorSchemas.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ListAllMdToJson(ListAllMd instance) => <String, dynamic>{
      'currencies': instance.currencies,
      'countries': instance.countries,
      'ethnics': instance.ethnics,
      'handover_types': instance.handover_types,
      'groups': instance.groups,
      'jobtitles': instance.jobtitles,
      'locations': instance.locations,
      'qualifications': instance.qualifications,
      'qualification_levels': instance.qualification_levels,
      'religions': instance.religions,
      'request_types': instance.request_types,
      'shifts': instance.shifts,
      'special_rates': instance.special_rates,
      'statuses': instance.statuses,
      'storages': instance.storages,
      'storage_items': instance.storage_items,
      'visas': instance.visas,
      'roles': instance.roles,
      'login_methods': instance.login_methods,
      'marital_statuses': instance.marital_statuses,
      'contract_starts': instance.contract_starts,
      'contract_types': instance.contract_types,
      'holiday_calculation_types': instance.holiday_calculation_types,
      'color_schemas': instance.color_schemas,
    };

ListCurrency _$ListCurrencyFromJson(Map<String, dynamic> json) => ListCurrency(
      id: json['id'] as int,
      code: json['code'] as String,
      sign: json['sign'] as String,
      front: json['front'] as bool,
      digits: json['digits'] as int,
    );

Map<String, dynamic> _$ListCurrencyToJson(ListCurrency instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'sign': instance.sign,
      'front': instance.front,
      'digits': instance.digits,
    };

ListCountry _$ListCountryFromJson(Map<String, dynamic> json) => ListCountry(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ListCountryToJson(ListCountry instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

ListEthnic _$ListEthnicFromJson(Map<String, dynamic> json) => ListEthnic(
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ListEthnicToJson(ListEthnic instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ListHandoverType _$ListHandoverTypeFromJson(Map<String, dynamic> json) =>
    ListHandoverType(
      id: json['id'] as int,
      title: json['title'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$ListHandoverTypeToJson(ListHandoverType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'active': instance.active,
    };

ListGroup _$ListGroupFromJson(Map<String, dynamic> json) => ListGroup(
      id: json['id'] as int,
      name: json['name'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$ListGroupToJson(ListGroup instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'active': instance.active,
    };

ListJobTitle _$ListJobTitleFromJson(Map<String, dynamic> json) => ListJobTitle(
      id: json['id'] as int,
      name: json['name'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$ListJobTitleToJson(ListJobTitle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'active': instance.active,
    };

ListLocation _$ListLocationFromJson(Map<String, dynamic> json) => ListLocation(
      id: json['id'] as int,
      name: json['name'] as String,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$ListLocationToJson(ListLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'active': instance.active,
    };

ListQualification _$ListQualificationFromJson(Map<String, dynamic> json) =>
    ListQualification(
      id: json['id'] as int,
      title: json['title'] as String,
      comments: json['comments'] as String,
      expire: json['expire'] as bool,
      levels: json['levels'] as bool,
    );

Map<String, dynamic> _$ListQualificationToJson(ListQualification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'comments': instance.comments,
      'expire': instance.expire,
      'levels': instance.levels,
    };

ListQualificationLevel _$ListQualificationLevelFromJson(
        Map<String, dynamic> json) =>
    ListQualificationLevel(
      id: json['id'] as int,
      level: json['level'] as String,
      rank: json['rank'] as int,
    );

Map<String, dynamic> _$ListQualificationLevelToJson(
        ListQualificationLevel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'rank': instance.rank,
    };

ListReligion _$ListReligionFromJson(Map<String, dynamic> json) => ListReligion(
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ListReligionToJson(ListReligion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ListRequestType _$ListRequestTypeFromJson(Map<String, dynamic> json) =>
    ListRequestType(
      id: json['id'] as int,
      name: json['name'] as String,
      comments: json['comments'] as String,
      full_day: json['full_day'] as int,
      paid: json['paid'] as bool,
      both_time: json['both_time'] as int,
      entitlement: json['entitlement'] as int,
      allocation_required: json['allocation_required'] as bool,
    );

Map<String, dynamic> _$ListRequestTypeToJson(ListRequestType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'comments': instance.comments,
      'full_day': instance.full_day,
      'paid': instance.paid,
      'both_time': instance.both_time,
      'entitlement': instance.entitlement,
      'allocation_required': instance.allocation_required,
    };

ListShift _$ListShiftFromJson(Map<String, dynamic> json) => ListShift(
      id: json['id'] as int,
      name: json['name'] as String,
      location_id: json['location_id'] as int,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$ListShiftToJson(ListShift instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location_id': instance.location_id,
      'active': instance.active,
    };

ListSpecialRate _$ListSpecialRateFromJson(Map<String, dynamic> json) =>
    ListSpecialRate(
      id: json['id'] as int,
      name: json['name'] as String,
      rate: (json['rate'] as num).toDouble(),
      min_work_time: json['min_work_time'] as int,
      paid_time: json['paid_time'] as int,
      split_time: json['split_time'] as bool,
      shift_id: json['shift_id'] as int,
    );

Map<String, dynamic> _$ListSpecialRateToJson(ListSpecialRate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'rate': instance.rate,
      'min_work_time': instance.min_work_time,
      'paid_time': instance.paid_time,
      'split_time': instance.split_time,
      'shift_id': instance.shift_id,
    };

ListStatus _$ListStatusFromJson(Map<String, dynamic> json) => ListStatus(
      id: json['id'] as int,
      name: json['name'] as String,
      start: json['start'] as bool,
      pair: json['pair'] as int,
      level: json['level'] as int,
      multi: json['multi'] as bool,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$ListStatusToJson(ListStatus instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start': instance.start,
      'pair': instance.pair,
      'level': instance.level,
      'multi': instance.multi,
      'active': instance.active,
    };

ListStorage _$ListStorageFromJson(Map<String, dynamic> json) => ListStorage(
      id: json['id'] as int,
      name: json['name'] as String,
      contact_name: json['contact_name'] as String?,
      contact_email: json['contact_email'] as String?,
      send_report: json['send_report'] as bool,
    );

Map<String, dynamic> _$ListStorageToJson(ListStorage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contact_name': instance.contact_name,
      'contact_email': instance.contact_email,
      'send_report': instance.send_report,
    };

ListStorageItem _$ListStorageItemFromJson(Map<String, dynamic> json) =>
    ListStorageItem(
      id: json['id'] as int,
      name: json['name'] as String,
      service: json['service'] as bool,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$ListStorageItemToJson(ListStorageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'service': instance.service,
      'active': instance.active,
    };

ListVisa _$ListVisaFromJson(Map<String, dynamic> json) => ListVisa(
      active: json['active'] as bool,
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ListVisaToJson(ListVisa instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'active': instance.active,
    };

ListRole _$ListRoleFromJson(Map<String, dynamic> json) => ListRole(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ListRoleToJson(ListRole instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

LoginMethods _$LoginMethodsFromJson(Map<String, dynamic> json) => LoginMethods(
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$LoginMethodsToJson(LoginMethods instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

MaritalStatuses _$MaritalStatusesFromJson(Map<String, dynamic> json) =>
    MaritalStatuses(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$MaritalStatusesToJson(MaritalStatuses instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

ContractStarts _$ContractStartsFromJson(Map<String, dynamic> json) =>
    ContractStarts(
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ContractStartsToJson(ContractStarts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ContractTypes _$ContractTypesFromJson(Map<String, dynamic> json) =>
    ContractTypes(
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$ContractTypesToJson(ContractTypes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

HolidayCalculationTypes _$HolidayCalculationTypesFromJson(
        Map<String, dynamic> json) =>
    HolidayCalculationTypes(
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$HolidayCalculationTypesToJson(
        HolidayCalculationTypes instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ColorSchemas _$ColorSchemasFromJson(Map<String, dynamic> json) => ColorSchemas(
      id: json['id'] as int,
      name: json['name'] as String,
      colour1: json['colour1'] as String,
      colour2: json['colour2'] as String,
      colour3: json['colour3'] as String,
    );

Map<String, dynamic> _$ColorSchemasToJson(ColorSchemas instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colour1': instance.colour1,
      'colour2': instance.colour2,
      'colour3': instance.colour3,
    };
