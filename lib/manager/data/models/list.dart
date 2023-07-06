import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/utils/global_constants.dart';

final class ClientShortMd extends Equatable {
  //{
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
  final String notes;
  final bool active;

  const ClientShortMd({
    required this.id,
    required this.name,
    required this.company,
    required this.contact,
    required this.notes,
    required this.active,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        company,
        contact,
        notes,
        active,
      ];

  factory ClientShortMd.fromJson(Map<String, dynamic> json) {
    return ClientShortMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
      company: json['company'] ?? "",
      contact: json['contact'] ?? "",
      notes: (json['notes'] ?? "") as String,
      active: json['active'] ?? false,
    );
  }
}

final class ContractStartMd extends Equatable {
  //{
  //             "id": 0,
  //             "name": "Contract Start Date"
  //         }
  final int id;
  final String name;

  const ContractStartMd({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  factory ContractStartMd.fromJson(Map<String, dynamic> json) {
    return ContractStartMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
    );
  }
}

final class ContractTypeMd extends Equatable {
  final int id;
  final String name;

  const ContractTypeMd({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  factory ContractTypeMd.fromJson(Map<String, dynamic> json) {
    return ContractTypeMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
    );
  }
}

final class ColorSchemeMd extends Equatable {
  //{
  //             "id": 1,
  //             "name": "Blue 1",
  //             "colour1": "#3B5998",
  //             "colour2": "#8b9dc3",
  //             "colour3": "#f0f0f0"
  //         }
  final int id;
  final String name;
  final String colour1;
  final String colour2;
  final String colour3;

  const ColorSchemeMd({
    required this.id,
    required this.name,
    required this.colour1,
    required this.colour2,
    required this.colour3,
  });

  @override
  List<Object?> get props => [id, name, colour1, colour2, colour3];

  factory ColorSchemeMd.fromJson(Map<String, dynamic> json) {
    return ColorSchemeMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
      colour1: json['colour1'] ?? "",
      colour2: json['colour2'] ?? "",
      colour3: json['colour3'] ?? "",
    );
  }
}

final class CurrencyMd extends Equatable {
  // {
  //             "id": 1,
  //             "code": "GBP",
  //             "sign": "£",
  //             "front": true,
  //             "digits": 2
  //         }

  final int id;
  final String code;
  final String sign;
  final bool front;
  final int digits;

  const CurrencyMd({
    required this.id,
    required this.code,
    required this.sign,
    required this.front,
    required this.digits,
  });

  @override
  List<Object?> get props => [id, code, sign, front, digits];

  factory CurrencyMd.fromJson(Map<String, dynamic> json) {
    return CurrencyMd(
      id: (json['id'] ?? 0) as int,
      code: json['code'] ?? "",
      sign: json['sign'] ?? "",
      front: (json['front'] ?? false) as bool,
      digits: json['digits'] ?? 0,
    );
  }
}

final class CountryMd extends Equatable {
  final String code;
  final String name;

  const CountryMd({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];

  factory CountryMd.fromJson(Map<String, dynamic> json) {
    return CountryMd(
      code: json['code'] ?? "",
      name: json['name'] ?? "",
    );
  }
}

final class EthnicMd extends Equatable {
  final int id;
  final String name;

  const EthnicMd({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  factory EthnicMd.fromJson(Map<String, dynamic> json) {
    return EthnicMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
    );
  }
}

final class GroupMd extends Equatable {
  final int id;
  final String name;
  final bool active;

  const GroupMd({required this.id, required this.name, required this.active});

  @override
  List<Object?> get props => [id, name, active];

  factory GroupMd.fromJson(Map<String, dynamic> json) {
    return GroupMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
      active: json['active'] ?? false,
    );
  }
}

final class HandoverTypeMd extends Equatable {
  final int id;
  final String title;
  final bool active;

  const HandoverTypeMd(
      {required this.id, required this.title, required this.active});

  @override
  List<Object?> get props => [id, title, active];

  factory HandoverTypeMd.fromJson(Map<String, dynamic> json) {
    return HandoverTypeMd(
      id: json['id'] as int,
      title: json['title'] ?? "",
      active: json['active'] ?? false,
    );
  }
}

final class HolidayCalculationTypeMd extends Equatable {
  final int id;
  final String name;

  const HolidayCalculationTypeMd({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  factory HolidayCalculationTypeMd.fromJson(Map<String, dynamic> json) {
    return HolidayCalculationTypeMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
    );
  }
}

final class JobTitleMd extends Equatable {
  final int id;
  final String name;
  final bool active;

  const JobTitleMd(
      {required this.id, required this.name, required this.active});

  @override
  List<Object?> get props => [id, name, active];

  factory JobTitleMd.fromJson(Map<String, dynamic> json) {
    return JobTitleMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
      active: json['active'] ?? false,
    );
  }
}

final class LocationShortMd extends Equatable {
  final int id;
  final String name;
  final bool active;
  final bool service;

  const LocationShortMd(
      {required this.id,
      required this.name,
      required this.active,
      required this.service});

  @override
  List<Object?> get props => [id, name, active, service];

  factory LocationShortMd.fromJson(Map<String, dynamic> json) {
    return LocationShortMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
      active: json['active'] ?? false,
      service: json['sevice'] ?? false,
    );
  }
}

final class LoginMethodMd extends Equatable {
  final int id;
  final String name;

  const LoginMethodMd({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  factory LoginMethodMd.fromJson(Map<String, dynamic> json) {
    return LoginMethodMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
    );
  }
}

final class MaritalStatusMd extends Equatable {
  final String code;
  final String name;

  const MaritalStatusMd({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];

  factory MaritalStatusMd.fromJson(Map<String, dynamic> json) {
    return MaritalStatusMd(
      code: json['code'] ?? "",
      name: json['name'] ?? "",
    );
  }
}

final class PaymentMethodMd extends Equatable {
  final int id;
  final String name;
  final bool active;

  const PaymentMethodMd(
      {required this.id, required this.name, required this.active});

  @override
  List<Object?> get props => [id, name, active];

  factory PaymentMethodMd.fromJson(Map<String, dynamic> json) {
    return PaymentMethodMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
      active: json['active'] ?? false,
    );
  }
}

final class QualificationMd extends Equatable {
//{
//             "id": 16,
//             "title": "Cleaning NVQ",
//             "comments": "",
//             "expire": true,
//             "levels": true
//         }
  final int id;
  final String title;
  final String comments;
  final bool expire;
  final bool levels;

  const QualificationMd(
      {required this.id,
      required this.title,
      required this.comments,
      required this.expire,
      required this.levels});

  @override
  List<Object?> get props => [id, title, comments, expire, levels];

  factory QualificationMd.fromJson(Map<String, dynamic> json) {
    return QualificationMd(
      id: json['id'] as int,
      title: json['title'] ?? "",
      comments: json['comments'] ?? "",
      expire: json['expire'] ?? false,
      levels: json['levels'] ?? "",
    );
  }
}

final class QualificationLevelMd extends Equatable {
  final int id;
  final String name;
  final int rank;

  const QualificationLevelMd(
      {required this.id, required this.name, required this.rank});

  @override
  List<Object?> get props => [id, name, rank];

  factory QualificationLevelMd.fromJson(Map<String, dynamic> json) {
    return QualificationLevelMd(
      id: json['id'] as int,
      name: json['level'] ?? "",
      rank: json['rank'] ?? 0,
    );
  }
}

final class ReligionMd extends Equatable {
  final int id;
  final String name;

  const ReligionMd({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];

  factory ReligionMd.fromJson(Map<String, dynamic> json) {
    return ReligionMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
    );
  }
}

final class RequestTypeMd extends Equatable {
  //{
  //             "id": 1,
  //             "name": "Holiday",
  //             "comments": "full day paid holiday",
  //             "full_day": 1,
  //             "paid": true,
  //             "both_time": 0,
  //             "entitlement": -1,
  //             "allocation_required": false
  //         }
  final int id;
  final String name;
  final String comments;
  final int fullDay;
  final bool paid;
  final int bothTime;
  final int entitlement;
  final bool allocationRequired;

  const RequestTypeMd(
      {required this.id,
      required this.name,
      required this.comments,
      required this.fullDay,
      required this.paid,
      required this.bothTime,
      required this.entitlement,
      required this.allocationRequired});

  @override
  List<Object?> get props => [
        id,
        name,
        comments,
        fullDay,
        paid,
        bothTime,
        entitlement,
        allocationRequired
      ];

  factory RequestTypeMd.fromJson(Map<String, dynamic> json) {
    return RequestTypeMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        comments: json['comments'] ?? "" ?? "",
        fullDay: json['full_day'] ?? 0,
        paid: json['paid'] ?? false,
        bothTime: json['both_time'] ?? 0,
        entitlement: json['entitlement'] ?? 0,
        allocationRequired: json['allocation_required'] ?? false);
  }
}

final class ShiftMd extends Equatable {
  //{
  //             "id": 57,
  //             "name": "Flat 1",
  //             "location_id": 41,
  //             "client_id": 5,
  //             "warehouse_id": 4,
  //             "active": false
  //         }
  final int id;
  final String name;
  final int? locationId;
  LocationMd? getLocationMd(List<LocationMd> locations) {
    return locations.firstWhereOrNull((element) => element.id == locationId);
  }

  final int? clientId;
  ClientMd? getClientMd(List<ClientMd> clients) {
    return clients.firstWhereOrNull((element) => element.id == clientId);
  }

  final int? warehouseId;
  WarehouseMd? getWarehouseMd(List<WarehouseMd> warehouses) {
    return warehouses.firstWhereOrNull((element) => element.id == warehouseId);
  }

  final bool active;

  const ShiftMd(
      {required this.id,
      required this.name,
      this.locationId,
      this.clientId,
      this.warehouseId,
      required this.active});

  @override
  List<Object?> get props =>
      [id, name, locationId, clientId, warehouseId, active];

  factory ShiftMd.fromJson(Map<String, dynamic> json) {
    return ShiftMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        locationId: json['location_id'],
        clientId: json['client_id'],
        warehouseId: json['warehouse_id'],
        active: json['active'] ?? false);
  }
}

final class ServiceMd extends Equatable {
  //{
  //             "id": 67,
  //             "name": "evening",
  //             "location_id": 47,
  //             "active": true
  //         }
  final int id;
  final String name;
  final int? locationId;
  final bool active;

  const ServiceMd(
      {required this.id,
      required this.name,
      this.locationId,
      required this.active});

  @override
  List<Object?> get props => [id, name, locationId, active];

  factory ServiceMd.fromJson(Map<String, dynamic> json) {
    return ServiceMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        locationId: json['location_id'],
        active: json['active'] ?? false);
  }
}

final class SpecialRateMd extends Equatable {
  //{
  //             "id": 1,
  //             "name": "Martin",
  //             "rate": 12.5,
  //             "min_work_time": 180,
  //             "paid_time": 180,
  //             "split_time": true,
  //             "shift_id": 297
  //         }
  final int id;
  final String name;
  final num? rate;
  final int? minWorkTime;
  final int? paidTime;
  final bool splitTime;
  final int? shiftId;

  const SpecialRateMd(
      {required this.id,
      required this.name,
      this.rate,
      this.minWorkTime,
      this.paidTime,
      required this.splitTime,
      this.shiftId});

  @override
  List<Object?> get props =>
      [id, name, rate, minWorkTime, paidTime, splitTime, shiftId];

  factory SpecialRateMd.fromJson(Map<String, dynamic> json) {
    return SpecialRateMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
      rate: json['rate'],
      minWorkTime: json['min_work_time'],
      paidTime: json['paid_time'],
      splitTime: json['split_time'] ?? false,
      shiftId: json['shift_id'],
    );
  }
}

final class StatusMd extends Equatable {
  // {
  //             "id": 1,
  //             "name": "Signed in",
  //             "start": true,
  //             "pair": 2,
  //             "level": 0,
  //             "multi": false,
  //             "active": true
  //         }
  final int id;
  final String name;
  final bool start;
  final int? pair;
  final int? level;
  final bool multi;
  final bool active;

  const StatusMd(
      {required this.id,
      required this.name,
      required this.start,
      this.pair,
      this.level,
      required this.multi,
      required this.active});

  @override
  List<Object?> get props => [id, name, start, pair, level, multi, active];

  factory StatusMd.fromJson(Map<String, dynamic> json) {
    return StatusMd(
      id: json['id'] as int,
      name: json['name'] ?? "",
      start: json['start'] ?? false,
      pair: json['pair'],
      level: json['level'],
      multi: json['multi'] ?? false,
      active: json['active'] ?? false,
    );
  }
}

final class WarehouseShortMd extends Equatable {
  // {
  //             "id": 1,
  //             "name": "Canary Wharf WA",
  //             "contact_name": null,
  //             "contact_email": null,
  //             "send_report": false
  //         }
  final int id;
  final String name;
  final String? contactName;
  final String? contactEmail;
  final bool sendReport;

  const WarehouseShortMd(
      {required this.id,
      required this.name,
      required this.contactName,
      required this.contactEmail,
      required this.sendReport});

  @override
  List<Object?> get props => [id, name, contactName, contactEmail, sendReport];

  factory WarehouseShortMd.fromJson(Map<String, dynamic> json) {
    return WarehouseShortMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        contactName: json['contact_name'],
        contactEmail: json['contact_email'],
        sendReport: json['send_report'] ?? false);
  }
}

final class WarehouseItemShortMd extends Equatable {
  //{
  //             "id": 1,
  //             "name": "Double Sheet",
  //             "service": false,
  //             "active": false
  //         }
  final int id;
  final String name;
  final bool service;
  final bool active;

  const WarehouseItemShortMd(
      {required this.id,
      required this.name,
      required this.service,
      required this.active});

  @override
  List<Object?> get props => [id, name, service, active];

  factory WarehouseItemShortMd.fromJson(Map<String, dynamic> json) {
    return WarehouseItemShortMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        service: json['service'] ?? false,
        active: json['active'] ?? false);
  }
}

final class TaxMd extends Equatable {
  //{
  //             "id": 1,
  //             "rate": 0,
  //             "active": true
  //         }
  final int id;
  final num rate;
  final bool active;

  const TaxMd({required this.id, required this.rate, required this.active});

  @override
  List<Object?> get props => [id, rate, active];

  factory TaxMd.fromJson(Map<String, dynamic> json) {
    return TaxMd(
        id: json['id'] as int,
        rate: json['rate'] ?? 0,
        active: json['active'] ?? false);
  }
}

final class VisaMd extends Equatable {
  final int id;
  final String name;
  final bool active;

  const VisaMd({required this.id, required this.name, required this.active});

  @override
  List<Object?> get props => [id, name, active];

  factory VisaMd.fromJson(Map<String, dynamic> json) {
    return VisaMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        active: json['active'] ?? false);
  }
}

final class WorkRepeatMd extends Equatable {
  //{
  //             "id": 1,
  //             "name": "Once",
  //             "days": 0
  //         }
  final int id;
  final String name;
  final int days;

  const WorkRepeatMd(
      {required this.id, required this.name, required this.days});

  @override
  List<Object?> get props => [id, name, days];

  factory WorkRepeatMd.fromJson(Map<String, dynamic> json) {
    return WorkRepeatMd(
        id: json['id'] as int,
        name: json['name'] ?? "",
        days: json['days'] ?? 0);
  }
}

final class RoleMd extends Equatable {
  //{
  //             "code": "ROLE_WEBADMIN",
  //             "name": "Webadmin"
  //         }

  final String code;
  final String name;

  const RoleMd({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];

  factory RoleMd.fromJson(Map<String, dynamic> json) {
    return RoleMd(code: json['code'] ?? "", name: json['name'] ?? "");
  }
}

final class ListMd extends Equatable {
  final List<ClientShortMd> clients;
  final List<ContractStartMd> contractStarts;
  final List<ContractTypeMd> contractTypes;
  final List<ColorSchemeMd> colorSchemas;
  final List<CurrencyMd> currencies;
  final List<CountryMd> countries;
  final List<EthnicMd> ethnics;
  final List<GroupMd> groups;
  final List<HandoverTypeMd> handoverTypes;
  final List<HolidayCalculationTypeMd> holidayCalculationTypes;
  final List<JobTitleMd> jobTitles;
  final List<LocationShortMd> locations;
  final List<LoginMethodMd> loginMethods;
  final List<MaritalStatusMd> maritalStatuses;
  final List<PaymentMethodMd> paymentMethods;
  final List<QualificationMd> qualifications;
  final List<QualificationLevelMd> qualificationLevels;
  final List<ReligionMd> religions;
  final List<RequestTypeMd> requestTypes;
  final List<ShiftMd> shifts;
  final List<ServiceMd> services;
  final List<SpecialRateMd> specialRates;
  final List<WarehouseShortMd> warehouses;
  final List<WarehouseItemShortMd> warehouseItems;
  final List<TaxMd> taxes;
  final List<VisaMd> visas;
  final List<WorkRepeatMd> workRepeats;
  final List<RoleMd> roles;
  final List<UserTitleMd> userTitles;
  final List<LanguageMd> languages;
  final List<StatusMd> statuses;

  List<LocationShortMd> clientRelatedLocation(int? clientId) {
    final list = <LocationShortMd>[];
    if (clientId == null) return list;

    //Get all shifts which are related to the client
    final clientShifts =
        shifts.where((element) => element.clientId == clientId);
    if (clientShifts.isEmpty) return list;

    //Filter locations which are related to the shifts
    for (final shift in clientShifts) {
      final location = locations
          .firstWhereOrNull((element) => element.id == shift.locationId);
      if (location != null) list.add(location);
    }

    //remove duplicates
    return list.toSet().toList();
  }

  const ListMd({
    required this.clients,
    required this.contractStarts,
    required this.contractTypes,
    required this.colorSchemas,
    required this.currencies,
    required this.countries,
    required this.ethnics,
    required this.groups,
    required this.handoverTypes,
    required this.holidayCalculationTypes,
    required this.jobTitles,
    required this.locations,
    required this.loginMethods,
    required this.maritalStatuses,
    required this.paymentMethods,
    required this.qualifications,
    required this.qualificationLevels,
    required this.religions,
    required this.requestTypes,
    required this.shifts,
    required this.services,
    required this.specialRates,
    required this.warehouses,
    required this.warehouseItems,
    required this.taxes,
    required this.visas,
    required this.workRepeats,
    required this.roles,
    required this.userTitles,
    required this.languages,
    required this.statuses,
  });

  @override
  List<Object> get props => [
        clients,
        contractStarts,
        contractTypes,
        colorSchemas,
        currencies,
        countries,
        ethnics,
        groups,
        handoverTypes,
        holidayCalculationTypes,
        jobTitles,
        locations,
        loginMethods,
        maritalStatuses,
        paymentMethods,
        qualifications,
        qualificationLevels,
        religions,
        requestTypes,
        shifts,
        services,
        specialRates,
        warehouses,
        warehouseItems,
        taxes,
        visas,
        workRepeats,
        roles,
        userTitles,
        languages,
        statuses,
      ];

  factory ListMd.fromJson(Map<String, dynamic> json) {
    return ListMd(
      clients: (json['clients'] as List<dynamic>)
          .map((e) => ClientShortMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      colorSchemas: (json['colour_schemas'] as List<dynamic>)
          .map((e) => ColorSchemeMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      contractStarts: (json['contract_starts'] as List<dynamic>)
          .map((e) => ContractStartMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      contractTypes: (json['contract_types'] as List<dynamic>)
          .map((e) => ContractTypeMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      countries: (json['countries'] as List<dynamic>)
          .map((e) => CountryMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      currencies: (json['currencies'] as List<dynamic>)
          .map((e) => CurrencyMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      ethnics: (json['ethnics'] as List<dynamic>)
          .map((e) => EthnicMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      groups: (json['groups'] as List<dynamic>)
          .map((e) => GroupMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      handoverTypes: (json['handover_types'] as List<dynamic>)
          .map((e) => HandoverTypeMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      holidayCalculationTypes:
          (json['holiday_calculation_types'] as List<dynamic>)
              .map((e) =>
                  HolidayCalculationTypeMd.fromJson(e as Map<String, dynamic>))
              .toList(),
      jobTitles: (json['jobtitles'] as List<dynamic>)
          .map((e) => JobTitleMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      locations: (json['locations'] as List<dynamic>)
          .map((e) => LocationShortMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      loginMethods: (json['login_methods'] as List<dynamic>)
          .map((e) => LoginMethodMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      maritalStatuses: (json['marital_statuses'] as List<dynamic>)
          .map((e) => MaritalStatusMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      paymentMethods: (json['payment_methods'] as List<dynamic>)
          .map((e) => PaymentMethodMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualifications: (json['qualifications'] as List<dynamic>)
          .map((e) => QualificationMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      qualificationLevels: (json['qualification_levels'] as List<dynamic>)
          .map((e) => QualificationLevelMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      religions: (json['religions'] as List<dynamic>)
          .map((e) => ReligionMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestTypes: (json['request_types'] as List<dynamic>)
          .map((e) => RequestTypeMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      shifts: (json['shifts'] as List<dynamic>)
          .map((e) => ShiftMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      services: (json['services'] as List<dynamic>)
          .map((e) => ServiceMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      specialRates: (json['special_rates'] as List<dynamic>)
          .map((e) => SpecialRateMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      warehouses: (json['storages'] as List<dynamic>)
          .map((e) => WarehouseShortMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      warehouseItems: (json['storage_items'] as List<dynamic>)
          .map((e) => WarehouseItemShortMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      roles: (json['roles'] as List<dynamic>)
          .map((e) => RoleMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      taxes: (json['taxes'] as List<dynamic>)
          .map((e) => TaxMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      visas: (json['visas'] as List<dynamic>)
          .map((e) => VisaMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      workRepeats: (json['work_repeats'] as List<dynamic>)
          .map((e) => WorkRepeatMd.fromJson(e as Map<String, dynamic>))
          .toList(),
      userTitles: GlobalConstants.userTitleTypes.entries
          .map((e) => UserTitleMd(code: e.key, name: e.value))
          .toList(),
      languages: GlobalConstants.userDisplayLanguages.entries
          .map((e) => LanguageMd(code: e.key, name: e.value))
          .toList(),
      statuses: (json['statuses'] as List<dynamic>)
          .map((e) => StatusMd.fromJson(e as Map<String, dynamic>))
          .toList()
    );
  }

  //factory init
  factory ListMd.init() {
    return const ListMd(
      clients: [],
      colorSchemas: [],
      contractStarts: [],
      contractTypes: [],
      countries: [],
      currencies: [],
      ethnics: [],
      groups: [],
      handoverTypes: [],
      holidayCalculationTypes: [],
      jobTitles: [],
      locations: [],
      loginMethods: [],
      maritalStatuses: [],
      paymentMethods: [],
      qualifications: [],
      qualificationLevels: [],
      religions: [],
      requestTypes: [],
      shifts: [],
      services: [],
      specialRates: [],
      warehouses: [],
      warehouseItems: [],
      roles: [],
      taxes: [],
      visas: [],
      workRepeats: [],
      userTitles: [],
      languages: [],
      statuses: [],
    );
  }
}

final class UserTitleMd extends Equatable {
  //{
  //             "code": mr,
  //             "name": "Mr",
  //         }
  final String code;
  final String name;

  const UserTitleMd({required this.name, required this.code});

  @override
  List<Object?> get props => [name, code];

  factory UserTitleMd.init() {
    return UserTitleMd(
        code: GlobalConstants.userTitleTypes.keys.first,
        name: GlobalConstants.userTitleTypes.values.first);
  }
}

final class LanguageMd extends Equatable {
  //{
  //             "code": en,
  //             "name": "English",
  //         }
  final String code;
  final String name;

  const LanguageMd({required this.name, required this.code});

  @override
  List<Object?> get props => [name, code];

  factory LanguageMd.init() {
    return LanguageMd(
        code: GlobalConstants.userDisplayLanguages.keys.first,
        name: GlobalConstants.userDisplayLanguages.values.first);
  }
}
