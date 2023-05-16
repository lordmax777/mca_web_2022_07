import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';

import '../redux/sets/app_state.dart';
import '../redux/states/general_state.dart';
import 'location_item_md.dart';
part 'list_all_md.g.dart';

@JsonSerializable()
class ListAllMd {
  final List<ListCurrency> currencies;
  final List<ListCountry> countries;
  final List<ListEthnic> ethnics;
  final List<ListHandoverType> handover_types;
  final List<ListGroup> groups;
  final List<ListJobTitle> jobtitles;
  final List<ListLocation> locations;
  final List<ListQualification> qualifications;
  final List<ListQualificationLevel> qualification_levels;
  final List<ListReligion> religions;
  final List<ListRequestType> request_types;
  final List<ListShift> shifts;
  final List<ListSpecialRate> special_rates;
  final List<ListStatus> statuses;
  final List<ListStorage> storages;
  final List<ListStorageItem> storage_items;
  final List<ListVisa> visas;
  final List<ListRole> roles;
  final List<LoginMethods> login_methods;
  final List<MaritalStatuses> marital_statuses;
  final List<ContractStarts> contract_starts;
  final List<ContractTypes> contract_types;
  final List<HolidayCalculationTypes> holiday_calculation_types;
  final List<ColorSchemas> color_schemas;
  final List<ListTaxes> taxes;
  final List<ListClients> clients;
  final List<ListServices> services;
  final List<ListPaymentMethods> payment_methods;
  final List<ListWorkRepeats> work_repeats;

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
      clients: [],
      services: [],
      payment_methods: [],
      work_repeats: [],
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
    required this.clients,
    required this.services,
    required this.payment_methods,
    required this.work_repeats,
  });

  factory ListAllMd.fromJson(Map<String, dynamic> json) =>
      _$ListAllMdFromJson(json);

  Map<String, dynamic> toJson() => _$ListAllMdToJson(this);
}

@JsonSerializable()
class ListCurrency {
  final int id;
  final String code;
  final String sign;
  final bool front;
  final int digits;

  String get title => '$code ($sign)';

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
  final String code;
  final String name;

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
  final int id;
  final String name;

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
  final int id;
  final String title;
  final bool active;

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
  final int id;
  final String name;
  final bool active;

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
  final int id;
  final String name;
  final bool active;

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
  final int id;
  final String name;
  final bool active;
  final bool? service;

  @override
  ListLocation({
    required this.id,
    required this.name,
    required this.active,
    this.service,
  });

  factory ListLocation.fromJson(Map<String, dynamic> json) =>
      _$ListLocationFromJson(json);

  Map<String, dynamic> toJson() => _$ListLocationToJson(this);
}

@JsonSerializable()
class ListQualification {
  final int id;
  final String title;
  final String comments;
  final bool expire;
  final bool levels;

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
  final int id;
  final String level;
  final int rank;

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
  final int id;
  final String name;

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
  final int id;
  final String name;
  final String comments;
  final int full_day;
  final bool paid;
  final int both_time;
  final int entitlement;
  final bool allocation_required;

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
//{
//             "id": 57,
//             "name": "Flat 1",
//             "location_id": 41,
//             "client_id": 5,
//             "warehouse_id": 4,
//             "active": false
//},

  final int id;
  final String name;
  final int location_id;
  final bool active;
  final int? client_id;
  final int? warehouse_id;

  //Getters
  GeneralState get state => appStore.state.generalState;

  //Late initialized variables
  @JsonKey(ignore: true)
  late final LocationAddress location;
  @JsonKey(ignore: true)
  late final ClientInfoMd? client;
  @JsonKey(ignore: true)
  late final WarehouseMd? warehouse;
  @JsonKey(ignore: true)
  late final PropertiesMd property;

  PropertiesMd propertyFromNewState(List<PropertiesMd> newProperties) {
    return newProperties.firstWhere((element) => element.id == id);
  }

  @override
  ListShift({
    required this.id,
    required this.name,
    required this.location_id,
    required this.active,
    this.client_id,
    this.warehouse_id,
  }) {
    property =
        state.allSortedProperties.firstWhere((element) => element.id == id);
    warehouse = state.storages
        .firstWhereOrNull((element) => element.id == warehouse_id);
    client = state.clientInfos
        .firstWhereOrNull((element) => element.id == client_id);
    location =
        state.locations.firstWhere((element) => element.id == location_id);
  }

  factory ListShift.fromJson(Map<String, dynamic> json) =>
      _$ListShiftFromJson(json);

  Map<String, dynamic> toJson() => _$ListShiftToJson(this);

  factory ListShift.init() {
    return ListShift(
      id: -10,
      name: '',
      location_id: 0,
      active: false,
      client_id: 0,
      warehouse_id: 0,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ListShift &&
        other.id == id &&
        other.name == name &&
        other.location_id == location_id &&
        other.active == active &&
        other.client_id == client_id &&
        other.warehouse_id == warehouse_id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        location_id.hashCode ^
        active.hashCode ^
        client_id.hashCode ^
        warehouse_id.hashCode;
  }
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

  final int id;
  final String name;
  final double rate;
  final int? min_work_time;
  final int? paid_time;
  final bool split_time;
  final int shift_id;

  @override
  ListSpecialRate({
    required this.id,
    required this.name,
    required this.rate,
    this.min_work_time,
    this.paid_time,
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

  final int id;
  final String name;
  final bool start;
  final int pair;
  final int level;
  final bool multi;
  final bool active;

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

  final int id;
  final String name;
  final String? contact_name;
  final String? contact_email;
  final bool send_report;

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

  final int id;
  final String name;
  final bool service;
  final bool active;

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

  final int id;
  final String name;
  final bool active;

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

  final String code;
  final String name;

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

  final int id;
  final String name;

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
  final String code;
  final String name;

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
  final int id;
  final String name;

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
  final int id;
  final String name;

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
  final int id;
  final String name;
  final String colour1;
  final String colour2;
  final String colour3;

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
  final int id;
  final int rate;
  final bool active;

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

@JsonSerializable()
class ListClients {
//        {
//             "id": 2,
//             "name": "kashiba house owners 1",
//             "company": "kashiba house owners",
//             "contact": null,
//             "notes": "",
//             "active": true
//         }
  final int id;
  final String name;
  final String company;
  final String? contact;
  final String? notes;
  final bool active;

  @override
  ListClients({
    required this.id,
    required this.name,
    required this.company,
    required this.contact,
    required this.notes,
    required this.active,
  });

  factory ListClients.fromJson(Map<String, dynamic> json) =>
      _$ListClientsFromJson(json);

  Map<String, dynamic> toJson() => _$ListClientsToJson(this);
}

@JsonSerializable()
class ListServices {
// {
//             "id": 66,
//             "name": "FLAT",
//             "location_id": 45,
//             "active": true
//         }
  final int id;
  final String name;
  final int location_id;
  final bool active;

  @override
  ListServices({
    required this.id,
    required this.name,
    required this.location_id,
    required this.active,
  });

  factory ListServices.fromJson(Map<String, dynamic> json) =>
      _$ListServicesFromJson(json);

  Map<String, dynamic> toJson() => _$ListServicesToJson(this);
}

@JsonSerializable()
class ListPaymentMethods {
//yment_methods": [
//         {
//             "id": 1,
//             "name": "Cash",
//             "active": true
//         },
//         {
  final int id;
  final String name;
  final bool active;

  @override
  ListPaymentMethods({
    required this.id,
    required this.name,
    required this.active,
  });

  factory ListPaymentMethods.fromJson(Map<String, dynamic> json) =>
      _$ListPaymentMethodsFromJson(json);

  Map<String, dynamic> toJson() => _$ListPaymentMethodsToJson(this);
}

@JsonSerializable()
class ListWorkRepeats {
//{
//             "id": 1,
//             "name": "Once",
//             "days": 0
//         },

  final int id;
  final String name;
  final int days;

  bool get isOnce => id == 1;
  bool get isDaily => id == 2;
  bool get isWeekly => id == 3;
  bool get isFortnightly => id == 4;

  @override
  ListWorkRepeats({
    required this.id,
    required this.name,
    required this.days,
  });

  factory ListWorkRepeats.fromJson(Map<String, dynamic> json) =>
      _$ListWorkRepeatsFromJson(json);

  Map<String, dynamic> toJson() => _$ListWorkRepeatsToJson(this);
}
