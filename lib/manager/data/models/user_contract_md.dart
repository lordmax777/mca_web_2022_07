import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_dashboard/manager/data/data.dart';

final class UserContractMd extends Equatable {
  //{
  //             "id": 727,
  //             "csd": {
  //                 "date": "2018-08-01 00:00:00.000000",
  //                 "timezone_type": 3,
  //                 "timezone": "UTC"
  //             },
  //             "ced": null,
  //             "awh": 45,
  //             "ahe": null,
  //             "ahew": null,
  //             "wdpw": 7,
  //             "hct": 4,
  //             "lunchtime": null,
  //             "lunchtimeUnpaid": null,
  //             "contractType": 0,
  //             "AHEonYS": true,
  //             "initHolidays": 0,
  //             "jobDescription": null,
  //             "salaryPH": 8.5,
  //             "salaryOT": null,
  //             "salaryPA": 1000,
  //             "jobTitleId": "28"
  //         }

  final int id;
  final String? csd;
  DateTime? get dateDt => csd != null ? DateTime.tryParse(csd!) : null;
  final String? ced;
  DateTime? get cedDt => ced != null ? DateTime.tryParse(ced!) : null;
  final num? awh;
  final num? ahe;
  final num? ahew;
  final num? wdpw;
  final num? hct;
  HolidayCalculationTypeMd? hctMd(List<HolidayCalculationTypeMd> list) {
    return list.firstWhereOrNull((element) => element.id == hct);
  }

  final num? lunchtime;
  final num? lunchtimeUnpaid;
  final int? contractType;
  ContractTypeMd? contractTypeMd(List<ContractTypeMd> list) {
    return list.firstWhereOrNull((element) => element.id == contractType);
  }

  final bool? AHEonYS;
  final int? initHolidays;
  final String? jobDescription;
  final num? salaryPH;
  final num? salaryOT;
  final num? salaryPA;
  final String? jobTitleId;
  JobTitleMd? jobTitleMd(List<JobTitleMd> list) {
    return list.firstWhereOrNull(
        (element) => element.id == int.tryParse(jobTitleId ?? ""));
  }

  const UserContractMd({
    required this.id,
    required this.csd,
    required this.ced,
    required this.awh,
    required this.ahe,
    required this.ahew,
    required this.wdpw,
    required this.hct,
    required this.lunchtime,
    required this.lunchtimeUnpaid,
    required this.contractType,
    required this.AHEonYS,
    required this.initHolidays,
    required this.jobDescription,
    required this.salaryPH,
    required this.salaryOT,
    required this.salaryPA,
    required this.jobTitleId,
  });

  //fromJson
  factory UserContractMd.fromJson(Map<String, dynamic> json) {
    try {
      return UserContractMd(
        id: json["id"],
        csd: json["csd"]?['date'],
        ced: json["ced"]?['date'],
        awh: json["awh"],
        ahe: json["ahe"],
        ahew: json["ahew"],
        wdpw: json["wdpw"],
        hct: json["hct"],
        lunchtime: json["lunchtime"],
        lunchtimeUnpaid: json["lunchtimeUnpaid"],
        contractType: json["contractType"],
        AHEonYS: json["AHEonYS"],
        initHolidays: json["initHolidays"],
        jobDescription: json["jobDescription"],
        salaryPH: json["salaryPH"],
        salaryOT: json["salaryOT"],
        salaryPA: json["salaryPA"],
        jobTitleId: json["jobTitleId"],
      );
    } on TypeError catch (e) {
      Logger.e("UserContractMd.fromJson: ${e.stackTrace}");
      rethrow;
    }
  }

  @override
  List<Object?> get props => [
        id,
        csd,
        ced,
        awh,
        ahe,
        ahew,
        wdpw,
        hct,
        lunchtime,
        lunchtimeUnpaid,
        contractType,
        AHEonYS,
        initHolidays,
        jobDescription,
        salaryPH,
        salaryOT,
        salaryPA,
        jobTitleId,
      ];
}
