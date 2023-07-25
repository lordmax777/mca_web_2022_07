import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';

class PayrollDataSource with DataSourceMixin<PayrollDataSource> {
  final int? id;
  final JobTitleMd? jobTitle;
  final TextEditingController jobDescriptionController;
  final DateTime? contractStartDate;
  final DateTime? contractEndDate;
  final ContractStartMd? annualHolidayEntitlementStart;
  final TextEditingController holidaysCarriedOutController;
  final ContractTypeMd? contractType;
  final HolidayCalculationTypeMd? holidayCalculationType;
  final TextEditingController agreedWeeklyHoursController;
  final TextEditingController workingDaysPerWeekController;
  final TextEditingController annualHolidayEntitlementController;
  final TextEditingController paidLunchTimeController;
  final TextEditingController unpaidLunchTimeController;
  final TextEditingController salaryPerHourController;
  final TextEditingController salaryPerHourOvertimeController;
  final TextEditingController salaryPerAnnumController;

  const PayrollDataSource({
    this.id,
    this.jobTitle,
    required this.jobDescriptionController,
    this.contractStartDate,
    this.contractEndDate,
    this.annualHolidayEntitlementStart,
    required this.holidaysCarriedOutController,
    this.contractType,
    this.holidayCalculationType,
    required this.agreedWeeklyHoursController,
    required this.workingDaysPerWeekController,
    required this.annualHolidayEntitlementController,
    required this.paidLunchTimeController,
    required this.unpaidLunchTimeController,
    required this.salaryPerHourController,
    required this.salaryPerHourOvertimeController,
    required this.salaryPerAnnumController,
  });

  @override
  PayrollDataSource copyWith(
      {int? id,
      JobTitleMd? jobTitle,
      DateTime? contractStartDate,
      DateTime? contractEndDate,
      ContractStartMd? annualHolidayEntitlementStart,
      ContractTypeMd? contractType,
      HolidayCalculationTypeMd? holidayCalculationType}) {
    return PayrollDataSource(
      id: id ?? this.id,
      agreedWeeklyHoursController: agreedWeeklyHoursController,
      workingDaysPerWeekController: workingDaysPerWeekController,
      annualHolidayEntitlementController: annualHolidayEntitlementController,
      paidLunchTimeController: paidLunchTimeController,
      unpaidLunchTimeController: unpaidLunchTimeController,
      salaryPerHourController: salaryPerHourController,
      salaryPerHourOvertimeController: salaryPerHourOvertimeController,
      salaryPerAnnumController: salaryPerAnnumController,
      holidaysCarriedOutController: holidaysCarriedOutController,
      jobDescriptionController: jobDescriptionController,
      annualHolidayEntitlementStart:
          annualHolidayEntitlementStart ?? this.annualHolidayEntitlementStart,
      contractEndDate: contractEndDate ?? this.contractEndDate,
      contractStartDate: contractStartDate ?? this.contractStartDate,
      contractType: contractType ?? this.contractType,
      holidayCalculationType:
          holidayCalculationType ?? this.holidayCalculationType,
      jobTitle: jobTitle ?? this.jobTitle,
    );
  }

  @override
  List<Object?> get props => [
        id,
        jobTitle,
        jobDescriptionController,
        contractStartDate,
        contractEndDate,
        annualHolidayEntitlementStart,
        holidaysCarriedOutController,
        contractType,
        holidayCalculationType,
        agreedWeeklyHoursController,
        workingDaysPerWeekController,
        annualHolidayEntitlementController,
        paidLunchTimeController,
        unpaidLunchTimeController,
        salaryPerHourController,
        salaryPerHourOvertimeController,
        salaryPerAnnumController,
      ];

  //init
  factory PayrollDataSource.init({int? id}) {
    return PayrollDataSource(
      id: id,
      contractEndDate: null,
      contractStartDate: null,
      jobDescriptionController:
          TextEditingController(text: kDebugMode ? "Job Description" : null),
      holidaysCarriedOutController:
          TextEditingController(text: kDebugMode ? "0" : null),
      agreedWeeklyHoursController:
          TextEditingController(text: kDebugMode ? "4" : null),
      workingDaysPerWeekController:
          TextEditingController(text: kDebugMode ? "3" : null),
      annualHolidayEntitlementController:
          TextEditingController(text: kDebugMode ? "0" : null),
      paidLunchTimeController:
          TextEditingController(text: kDebugMode ? "0" : null),
      unpaidLunchTimeController:
          TextEditingController(text: kDebugMode ? "0" : null),
      salaryPerHourController:
          TextEditingController(text: kDebugMode ? "0" : null),
      salaryPerHourOvertimeController:
          TextEditingController(text: kDebugMode ? "0" : null),
      salaryPerAnnumController:
          TextEditingController(text: kDebugMode ? "0" : null),
    );
  }

  @override
  void dispose() {
    jobDescriptionController.dispose();
    holidaysCarriedOutController.dispose();
    agreedWeeklyHoursController.dispose();
    workingDaysPerWeekController.dispose();
    annualHolidayEntitlementController.dispose();
    paidLunchTimeController.dispose();
    unpaidLunchTimeController.dispose();
    salaryPerHourController.dispose();
    salaryPerHourOvertimeController.dispose();
    salaryPerAnnumController.dispose();
  }

  bool isValid(BuildContext context) {
    if (jobTitle == null ||
        contractType == null ||
        contractStartDate == null ||
        annualHolidayEntitlementStart == null ||
        holidayCalculationType == null) {
      context.showError(
          "Please fill ${jobTitle == null ? "Job Title, " : ""}${contractType == null ? "Contract Type, " : ""}${contractStartDate == null ? "Contract Start Date, " : ""}${annualHolidayEntitlementStart == null ? "Annual Holiday Entitlement Start, " : ""}${holidayCalculationType == null ? "Holiday Calculation Type, " : ""}");
      return false;
    }
    return true;
  }

  factory PayrollDataSource.fromUserContract(
    UserContractMd? contract, {
    required List<ContractTypeMd> contractTypes,
    required List<HolidayCalculationTypeMd> holidayCalculationTypes,
    required List<JobTitleMd> jobTitles,
    required List<ContractStartMd> contractStarts,
  }) {
    if (contract == null) return PayrollDataSource.init();
    return PayrollDataSource(
      annualHolidayEntitlementStart:
          contract.AHEonYS == true ? contractStarts[1] : contractStarts[0],
      id: contract.id,
      holidaysCarriedOutController:
          TextEditingController(text: contract.initHolidays.toString()),
      agreedWeeklyHoursController:
          TextEditingController(text: contract.awh.toString()),
      annualHolidayEntitlementController:
          TextEditingController(text: contract.ahe.toString()),
      paidLunchTimeController:
          TextEditingController(text: contract.lunchtime.toString()),
      salaryPerAnnumController:
          TextEditingController(text: contract.salaryPA.toString()),
      salaryPerHourController:
          TextEditingController(text: contract.salaryPH.toString()),
      salaryPerHourOvertimeController:
          TextEditingController(text: contract.salaryOT.toString()),
      unpaidLunchTimeController:
          TextEditingController(text: contract.lunchtimeUnpaid.toString()),
      workingDaysPerWeekController:
          TextEditingController(text: contract.wdpw.toString()),
      jobDescriptionController:
          TextEditingController(text: contract.jobDescription),
      contractType: contract.contractTypeMd(contractTypes),
      contractEndDate: contract.cedDt,
      contractStartDate: contract.dateDt,
      holidayCalculationType: contract.hctMd(holidayCalculationTypes),
      jobTitle: contract.jobTitleMd(jobTitles),
    );
  }
}
