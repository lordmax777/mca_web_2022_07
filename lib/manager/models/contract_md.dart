import 'package:json_annotation/json_annotation.dart';
part 'contract_md.g.dart';

//Awh: agreed weekly hours
// Ahe: annual holiday entitlement, days
// Ahew: annual holiday entitlement,  weeks
// Wdpw: work days per week
// Hct: holiday calculation type
// Csd: contract start date
// Ced: contract end date
@JsonSerializable(anyMap: true)
class ContractMd {
  int id;
  ContractDate? csd;
  ContractDate? ced;
  num? awh;
  String? ahe;
  num? ahew;
  num? wdpw;
  num? hct;
  num? lunchtime;
  num? lunchtimeUnpaid;
  int contractType;
  bool? AHEonYS;
  int? initHolidays;
  String? jobDescription;
  double? salaryPH;
  double? salaryOT;
  double? salaryPA;
  String? jobTitleId;

  @override
  ContractMd({
    required this.id,
    required this.contractType,
    this.awh,
    this.AHEonYS,
    this.hct,
    this.initHolidays,
    this.wdpw,
    this.jobTitleId,
    this.salaryPA,
    this.salaryPH,
    this.salaryOT,
    this.ahe,
    this.ahew,
    this.csd,
    this.ced,
    this.jobDescription,
    this.lunchtime,
    this.lunchtimeUnpaid,
  });

  factory ContractMd.fromJson(Map<String, dynamic> json) =>
      _$ContractMdFromJson(json);

  Map<String, dynamic> toJson() => _$ContractMdToJson(this);
}

@JsonSerializable(anyMap: true)
class ContractDate {
  int timezone_type;
  String date;
  String timezone;

  @override
  ContractDate({
    required this.date,
    required this.timezone,
    required this.timezone_type,
  });

  factory ContractDate.fromJson(Map<String, dynamic> json) =>
      _$ContractDateFromJson(json);

  Map<String, dynamic> toJson() => _$ContractDateToJson(this);
}
