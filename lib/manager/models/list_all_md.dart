import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

import '../redux/sets/app_state.dart';
part 'list_all_md.g.dart';

@JsonSerializable()
class ListAllMd {
  List<ListCurrency> currencies;
  List<ListCountry> countries;
  List<ListEthnic> ethnics;
  List<ListHandoverType> handover_types;
  List<ListGroup> groups;
  List<ListJobTitle> jobtitles;
  List<ListLocation> locations;
  List<ListQualification> qualifications;
  List<ListQualificationLevel> qualification_levels;
  List<ListReligion> religions;
  List<ListRequestType> request_types;
  List<ListShift> shifts;
  List<ListSpecialRate> special_rates;
  List<ListStatus> statuses;
  List<ListStorage> storages;
  List<ListStorageItem> storage_items;
  List<ListVisa> visas;
  List<ListRole> roles;
  List<LoginMethods> login_methods;
  List<MaritalStatuses> marital_statuses;
  List<ContractStarts> contract_starts;
  List<ContractTypes> contract_types;
  List<HolidayCalculationTypes> holiday_calculation_types;
  List<ColorSchemas> color_schemas;
  List<ListTaxes> taxes;

  static ListAllMd init() {
    return ListAllMd(
      holiday_calculation_types: [],
      contract_starts: [],
      contract_types: [],
      countries: [],
      currencies: [],
      locations: [],
      ethnics: [],
      groups: [],
      handover_types: [],
      jobtitles: [],
      qualification_levels: [],
      qualifications: [],
      religions: [],
      request_types: [],
      roles: [],
      shifts: [],
      special_rates: [],
      statuses: [],
      storage_items: [],
      storages: [],
      visas: [],
      login_methods: [],
      marital_statuses: [],
      color_schemas: [],
      taxes: [],
    );
  }

  @override
  ListAllMd({
    required this.countries,
    required this.holiday_calculation_types,
    required this.currencies,
    required this.ethnics,
    required this.groups,
    required this.handover_types,
    required this.jobtitles,
    required this.locations,
    required this.qualification_levels,
    required this.qualifications,
    required this.religions,
    required this.request_types,
    required this.roles,
    required this.shifts,
    required this.special_rates,
    required this.statuses,
    required this.storage_items,
    required this.storages,
    required this.visas,
    required this.login_methods,
    required this.marital_statuses,
    required this.contract_types,
    required this.contract_starts,
    required this.color_schemas,
    required this.taxes,
  });

  factory ListAllMd.fromJson(Map<String, dynamic> json) =>
      _$ListAllMdFromJson(json);

  Map<String, dynamic> toJson() => _$ListAllMdToJson(this);
}

@JsonSerializable()
class ListCurrency {
  int id;
  String code;
  String sign;
  bool front;
  int digits;

  @override
  ListCurrency({
    required this.id,
    required this.code,
    required this.sign,
    required this.front,
    required this.digits,
  });

  factory ListCurrency.fromJson(Map<String, dynamic> json) =>
      _$ListCurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$ListCurrencyToJson(this);
}

@JsonSerializable()
class ListCountry {
  String code;
  String name;

  @override
  ListCountry({
    required this.code,
    required this.name,
  });

  factory ListCountry.fromJson(Map<String, dynamic> json) =>
      _$ListCountryFromJson(json);

  Map<String, dynamic> toJson() => _$ListCountryToJson(this);
}

@JsonSerializable()
class ListEthnic {
  int id;
  String name;

  @override
  ListEthnic({
    required this.id,
    required this.name,
  });

  factory ListEthnic.fromJson(Map<String, dynamic> json) =>
      _$ListEthnicFromJson(json);

  Map<String, dynamic> toJson() => _$ListEthnicToJson(this);
}

@JsonSerializable()
class ListHandoverType {
  int id;
  String title;
  bool active;

  @override
  ListHandoverType({
    required this.id,
    required this.title,
    required this.active,
  });

  factory ListHandoverType.fromJson(Map<String, dynamic> json) =>
      _$ListHandoverTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ListHandoverTypeToJson(this);
}

@JsonSerializable()
class ListGroup {
  int id;
  String name;
  bool active;

  @override
  ListGroup({
    required this.id,
    required this.name,
    required this.active,
  });

  factory ListGroup.fromJson(Map<String, dynamic> json) =>
      _$ListGroupFromJson(json);

  Map<String, dynamic> toJson() => _$ListGroupToJson(this);
}

@JsonSerializable()
class ListJobTitle {
  int id;
  String name;
  bool active;

  @override
  ListJobTitle({
    required this.id,
    required this.name,
    required this.active,
  });

  factory ListJobTitle.fromJson(Map<String, dynamic> json) =>
      _$ListJobTitleFromJson(json);

  Map<String, dynamic> toJson() => _$ListJobTitleToJson(this);
}

@JsonSerializable()
class ListLocation {
  int id;
  String name;
  bool active;

  @override
  ListLocation({
    required this.id,
    required this.name,
    required this.active,
  });

  factory ListLocation.fromJson(Map<String, dynamic> json) =>
      _$ListLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ListLocationToJson(this);
}

@JsonSerializable()
class ListQualification {
  int id;
  String title;
  String comments;
  bool expire;
  bool levels;

  @override
  ListQualification({
    required this.id,
    required this.title,
    required this.comments,
    required this.expire,
    required this.levels,
  });

  factory ListQualification.fromJson(Map<String, dynamic> json) =>
      _$ListQualificationFromJson(json);

  Map<String, dynamic> toJson() => _$ListQualificationToJson(this);
}

@JsonSerializable()
class ListQualificationLevel {
  // "id": 1,
  // "level": "EL3",
  // "rank": 1
  int id;
  String level;
  int rank;
  @override
  ListQualificationLevel({
    required this.id,
    required this.level,
    required this.rank,
  });

  factory ListQualificationLevel.fromJson(Map<String, dynamic> json) =>
      _$ListQualificationLevelFromJson(json);

  Map<String, dynamic> toJson() => _$ListQualificationLevelToJson(this);
}

@JsonSerializable()
class ListReligion {
  int id;
  String name;
  @override
  ListReligion({
    required this.id,
    required this.name,
  });

  factory ListReligion.fromJson(Map<String, dynamic> json) =>
      _$ListReligionFromJson(json);

  Map<String, dynamic> toJson() => _$ListReligionToJson(this);
}

@JsonSerializable()
class ListRequestType {
  //   "id": 1,
  // "name": "Holiday",
  // "comments": "full day paid holiday",
  // "full_day": 1,
  // "paid": true,
  // "both_time": 0,
  // "entitlement": -1,
  // "allocation_required": false
  int id;
  String name;
  String comments;
  int full_day;
  bool paid;
  int both_time;
  int entitlement;
  bool allocation_required;

  @override
  ListRequestType({
    required this.id,
    required this.name,
    required this.comments,
    required this.full_day,
    required this.paid,
    required this.both_time,
    required this.entitlement,
    required this.allocation_required,
  });
  factory ListRequestType.fromJson(Map<String, dynamic> json) =>
      _$ListRequestTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ListRequestTypeToJson(this);
}

@JsonSerializable()
class ListShift {
  // "id": 57,
  // "name": "Flat 1",
  // "location_id": 41,
  // "active": false

  int id;
  String name;
  int location_id;
  bool active;

  @override
  ListShift({
    required this.id,
    required this.name,
    required this.location_id,
    required this.active,
  });
  factory ListShift.fromJson(Map<String, dynamic> json) =>
      _$ListShiftFromJson(json);

  Map<String, dynamic> toJson() => _$ListShiftToJson(this);
}

@JsonSerializable()
class ListSpecialRate {
  // "id": 1,
  //     "name": "Martin",
  //     "rate": 12.5,
  //     "min_work_time": 180,
  //     "paid_time": 180,
  //     "split_time": true,
  //     "shift_id": 297

  int id;
  String name;
  double rate;
  int min_work_time;

  int paid_time;
  bool split_time;
  int shift_id;

  @override
  ListSpecialRate({
    required this.id,
    required this.name,
    required this.rate,
    required this.min_work_time,
    required this.paid_time,
    required this.split_time,
    required this.shift_id,
  });

  factory ListSpecialRate.fromJson(Map<String, dynamic> json) =>
      _$ListSpecialRateFromJson(json);

  Map<String, dynamic> toJson() => _$ListSpecialRateToJson(this);
}

@JsonSerializable()
class ListStatus {
  // "id": 1,
  // "name": "Signed in",
  // "start": true,
  // "pair": 2,
  // "level": 0,
  // "multi": false,
  // "active": true

  int id;
  String name;
  bool start;
  int pair;
  int level;
  bool multi;
  bool active;

  @override
  ListStatus({
    required this.id,
    required this.name,
    required this.start,
    required this.pair,
    required this.level,
    required this.multi,
    required this.active,
  });

  factory ListStatus.fromJson(Map<String, dynamic> json) =>
      _$ListStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ListStatusToJson(this);
}

@JsonSerializable()
class ListStorage {
  // "id": 1,
  // "name": "Canary Wharf WA",
  // "contact_name": null,
  // "contact_email": null,
  // "send_report": false

  int id;
  String name;

  String? contact_name;
  String? contact_email;
  bool send_report;

  @override
  ListStorage({
    required this.id,
    required this.name,
    required this.contact_name,
    required this.contact_email,
    required this.send_report,
  });

  factory ListStorage.fromJson(Map<String, dynamic> json) =>
      _$ListStorageFromJson(json);

  Map<String, dynamic> toJson() => _$ListStorageToJson(this);
}

@JsonSerializable()
class ListStorageItem {
  //  "id": 1,
  //   "name": "Double Sheet",
  //   "service": false,
  //   "active": true

  int id;
  String name;
  bool service;
  bool active;

  @override
  ListStorageItem({
    required this.id,
    required this.name,
    required this.service,
    required this.active,
  });

  factory ListStorageItem.fromJson(Map<String, dynamic> json) =>
      _$ListStorageItemFromJson(json);

  Map<String, dynamic> toJson() => _$ListStorageItemToJson(this);
}

@JsonSerializable()
class ListVisa {
  // "id": 1,
  //       "name": "No visa required",
  //       "active": true

  int id;
  String name;
  bool active;

  @override
  ListVisa({
    required this.active,
    required this.id,
    required this.name,
  });

  factory ListVisa.fromJson(Map<String, dynamic> json) =>
      _$ListVisaFromJson(json);

  Map<String, dynamic> toJson() => _$ListVisaToJson(this);
}

@JsonSerializable()
class ListRole {
  // "code": "ROLE_SYSADMIN",
  //   "name": "Sysadmin"

  String code;
  String name;

  @override
  ListRole({
    required this.code,
    required this.name,
  });

  factory ListRole.fromJson(Map<String, dynamic> json) =>
      _$ListRoleFromJson(json);

  Map<String, dynamic> toJson() => _$ListRoleToJson(this);
}

@JsonSerializable()
class LoginMethods {
  // "code": "ROLE_SYSADMIN",
  //   "name": "Sysadmin"

  int id;
  String name;

  @override
  LoginMethods({
    required this.id,
    required this.name,
  });

  factory LoginMethods.fromJson(Map<String, dynamic> json) =>
      _$LoginMethodsFromJson(json);

  Map<String, dynamic> toJson() => _$LoginMethodsToJson(this);
}

@JsonSerializable()
class MaritalStatuses {
  String code;
  String name;

  @override
  MaritalStatuses({
    required this.code,
    required this.name,
  });

  factory MaritalStatuses.fromJson(Map<String, dynamic> json) =>
      _$MaritalStatusesFromJson(json);

  Map<String, dynamic> toJson() => _$MaritalStatusesToJson(this);
}

@JsonSerializable()
class ContractStarts {
  int id;
  String name;

  @override
  ContractStarts({
    required this.id,
    required this.name,
  });

  factory ContractStarts.fromJson(Map<String, dynamic> json) =>
      _$ContractStartsFromJson(json);

  Map<String, dynamic> toJson() => _$ContractStartsToJson(this);
}

@JsonSerializable()
class ContractTypes {
  int id;
  String name;

  @override
  ContractTypes({
    required this.id,
    required this.name,
  });

  factory ContractTypes.fromJson(Map<String, dynamic> json) =>
      _$ContractTypesFromJson(json);

  Map<String, dynamic> toJson() => _$ContractTypesToJson(this);
}

@JsonSerializable()
class HolidayCalculationTypes {
  int id;
  String name;

  @override
  HolidayCalculationTypes({
    required this.id,
    required this.name,
  });

  factory HolidayCalculationTypes.fromJson(Map<String, dynamic> json) =>
      _$HolidayCalculationTypesFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayCalculationTypesToJson(this);
}

@JsonSerializable()
class ColorSchemas {
  // {
  //  "id": 1,
  //  "name": "Blue 1",
  //  "colour1": "#3B5998",
  //  "colour2": "#8b9dc3",
  //  "colour3": "#f0f0f0"
  // },
  int id;
  String name;
  String colour1;
  String colour2;
  String colour3;

  @override
  ColorSchemas({
    required this.id,
    required this.name,
    required this.colour1,
    required this.colour2,
    required this.colour3,
  });

  factory ColorSchemas.fromJson(Map<String, dynamic> json) =>
      _$ColorSchemasFromJson(json);

  Map<String, dynamic> toJson() => _$ColorSchemasToJson(this);
}

@JsonSerializable()
class ListTaxes {
// {
//             "id": 1,
//             "rate": 0,
//             "active": true
//         }
  int id;
  int rate;
  bool active;

  static ListTaxes? byRate(int r) =>
      appStore.state.generalState.paramList.data!.taxes
          .firstWhereOrNull((element) => element.rate == r);
  static ListTaxes? byId(int i) =>
      appStore.state.generalState.paramList.data!.taxes
          .firstWhereOrNull((element) => element.id == i);

  @override
  ListTaxes({
    required this.id,
    required this.active,
    required this.rate,
  });

  factory ListTaxes.fromJson(Map<String, dynamic> json) =>
      _$ListTaxesFromJson(json);

  Map<String, dynamic> toJson() => _$ListTaxesToJson(this);
}
