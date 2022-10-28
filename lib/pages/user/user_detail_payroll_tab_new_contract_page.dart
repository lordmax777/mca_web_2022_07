import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';

import '../../manager/redux/sets/app_state.dart';
import '../../manager/redux/states/users_state/users_state.dart';
import '../../theme/theme.dart';

class UserDetailsPayrollTabNewContractPage extends StatefulWidget {
  final ContractMd? contract;
  const UserDetailsPayrollTabNewContractPage({Key? key, this.contract})
      : super(key: key);

  @override
  State<UserDetailsPayrollTabNewContractPage> createState() =>
      _UserDetailsPayrollTabNewContractPageState();
}

class _UserDetailsPayrollTabNewContractPageState
    extends State<UserDetailsPayrollTabNewContractPage> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isNewContract = true;

  List errors = [];

  CodeMap jobTitle = CodeMap(name: null, code: null);

  CodeMap contractType = CodeMap(name: null, code: null);

  CodeMap holidayEntitlementStart = CodeMap(name: null, code: null);

  CodeMap holidayCalculationType = CodeMap(name: null, code: null);

  DateTime? contractStartDate;
  DateTime? contractEndDate;

  TextEditingController aveWeeklyHours = TextEditingController();
  TextEditingController agreedDaysPerWeek = TextEditingController();
  TextEditingController annualHolidayEntitlement = TextEditingController();
  TextEditingController holidaysCarriedOver = TextEditingController(text: "0");
  TextEditingController paidLunchtime = TextEditingController();
  TextEditingController unpaidLunchtime = TextEditingController();
  TextEditingController salaryPerHour = TextEditingController();
  TextEditingController salaryPerHourOvertime = TextEditingController();
  TextEditingController salaryPerAnnum = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.contract != null) {
      final jobTitles = appStore.state.generalState.paramList.data!.jobtitles;
      final contractStarts =
          appStore.state.generalState.paramList.data!.contract_starts;
      final contractTypes =
          appStore.state.generalState.paramList.data!.contract_types;
      final holidayCalcTypes =
          appStore.state.generalState.paramList.data!.holiday_calculation_types;

      isNewContract = false;
      final c = widget.contract!;

      aveWeeklyHours.text = c.awh?.toString() ?? "";
      agreedDaysPerWeek.text = c.wdpw?.toString() ?? "";
      annualHolidayEntitlement.text = c.ahe?.toString() ?? "";
      holidaysCarriedOver.text = c.initHolidays?.toString() ?? "0";
      paidLunchtime.text = c.lunchtime?.toString() ?? "";
      unpaidLunchtime.text = c.lunchtimeUnpaid?.toString() ?? "";
      salaryPerHour.text = c.salaryPH?.toString() ?? "";
      salaryPerHourOvertime.text = c.salaryOT?.toString() ?? "";
      salaryPerAnnum.text = c.salaryPA.toString();
      contractStartDate = DateTime.tryParse((c.csd?.date) ?? "");
      contractEndDate = DateTime.tryParse((c.ced?.date) ?? "");

      //Add dropdown values
      jobTitle = CodeMap(
          name: jobTitles
              .firstWhereOrNull(
                  (element) => element.id.toString() == c.jobTitleId)
              ?.name,
          code: c.jobTitleId);
      contractType = CodeMap(
          name: contractTypes
              .firstWhereOrNull((element) => element.id == c.contractType)
              ?.name,
          code: c.contractType.toString());
      holidayCalculationType = CodeMap(
          name: holidayCalcTypes
              .firstWhereOrNull((element) => element.id == c.hct)
              ?.name,
          code: c.hct.toString());
      holidayEntitlementStart = CodeMap(
          name: !c.AHEonYS!
              ? contractStarts.first.name.toString()
              : contractStarts[1].name.toString(),
          code: !c.AHEonYS!
              ? contractStarts.first.id.toString()
              : contractStarts[1].id.toString());
    }
  }

  @override
  void dispose() {
    paidLunchtime.dispose();
    unpaidLunchtime.dispose();
    aveWeeklyHours.dispose();
    agreedDaysPerWeek.dispose();
    annualHolidayEntitlement.dispose();
    holidaysCarriedOver.dispose();
    salaryPerHour.dispose();
    salaryPerHourOvertime.dispose();
    salaryPerAnnum.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final user = state.usersState.userDetails.data;
          final String newOrEdit = isNewContract ? "New" : "Edit";
          String nameWithUsername = "$newOrEdit Contract";

          if (user != null) {
            nameWithUsername =
                "$newOrEdit Contract (${user.first_name} ${user.last_name})";
          }
          return PageWrapper(
              child: SpacedColumn(verticalSpace: 16.0, children: [
            PageGobackWidget(text: nameWithUsername),
            TableWrapperWidget(
              padding: const EdgeInsets.only(
                  left: 48.0, right: 48.0, top: 48.0, bottom: 16.0),
              child: Form(
                key: formKey,
                child: SpacedColumn(
                  verticalSpace: 16.0,
                  children: [
                    SpacedRow(
                      horizontalSpace: dpWidth * .05,
                      children: [
                        _buildLeft(dpWidth, state.generalState),
                        _buildRight(dpWidth, state),
                      ],
                    ),
                    const Divider(color: ThemeColors.gray11, thickness: 1.0),
                    _SaveAndCancelButtonsWidget(isNewContract),
                  ],
                ),
              ),
            ),
          ]));
        });
  }

  Widget _buildLeft(double dpWidth, GeneralState state) {
    final jobTitles = state.paramList.data!.jobtitles;
    final contractTypes = state.paramList.data!.contract_types;
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),
          DropdownWidget1(
            hintText: "Job Title",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            value: jobTitle.name,
            objItems: jobTitles,
            items: jobTitles.map<String>((e) => e.name).toList(),
            onChangedWithObj: (value) {
              setState(() {
                jobTitle =
                    CodeMap(code: value.item.id.toString(), name: value.name);
              });
            },
          ),
          DropdownWidget1(
            hintText: "Contract Type",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            value: contractType.name,
            objItems: contractTypes,
            items: contractTypes.map<String>((e) => e.name).toList(),
            onChangedWithObj: (value) {
              setState(() {
                contractType =
                    CodeMap(code: value.item.id.toString(), name: value.name);
              });
            },
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                controller: TextEditingController(
                    text: contractStartDate?.formattedDate),
                isRequired: true,
                width: dpWidth / 6,
                enabled: false,
                labelText: "Contract Start Date",
                leftIcon: HeroIcons.calendar,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                },
                onTap: () async {
                  DateTime? val = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2035),
                  );
                  if (val != null) {
                    setState(() {
                      contractStartDate = val;
                    });
                  }
                },
              ),
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 6,
                controller:
                    TextEditingController(text: contractEndDate?.formattedDate),
                enabled: false,
                labelText: "Contract End Date",
                leftIcon: HeroIcons.calendar,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return "Please enter a value";
                  }
                  if (contractStartDate != null &&
                      contractEndDate != null &&
                      contractStartDate!.isAfter(contractEndDate!)) {
                    return "Contract end date must be after contract start date";
                  }
                  return null;
                },
                onTap: () async {
                  DateTime? val = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2015),
                    lastDate: DateTime(2035),
                  );
                  if (val != null) {
                    setState(() {
                      contractEndDate = val;
                    });
                  }
                },
              ),
            ],
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                isRequired: true,
                controller: aveWeeklyHours,
                width: dpWidth / 6,
                labelText: "Agreed Weekly Hours",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                },
                onTap: () {},
              ),
              TextInputWidget(
                controller: agreedDaysPerWeek,
                isRequired: true,
                width: dpWidth / 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                },
                labelText: "Agreed Days per Week",
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(),
          _buildLeftBottom(dpWidth),
        ]);
  }

  Widget _buildRight(double dpWidth, AppState state) {
    final contrSt = state.generalState.paramList.data?.contract_starts ?? [];
    final hCalcTypes =
        state.generalState.paramList.data?.holiday_calculation_types ?? [];
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),
          DropdownWidget1<ContractStarts>(
            hintText: "Annual Holiday Entitlement Start",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            isRequired: true,
            objItems: contrSt,
            value: holidayEntitlementStart.name,
            onChangedWithObj: (DpItem val) {
              setState(() {
                holidayEntitlementStart = CodeMap(
                    code: (val.item as ContractStarts).id.toString(),
                    name: val.name);
              });
            },
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            items: contrSt.map<String>((e) => e.name).toList(),
          ),
          DropdownWidget1<HolidayCalculationTypes>(
            hintText: "Holiday Calculation Type",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            isRequired: true,
            objItems: hCalcTypes,
            value: holidayCalculationType.name,
            onChangedWithObj: (DpItem val) {
              setState(() {
                holidayCalculationType = CodeMap(
                    code: (val.item as HolidayCalculationTypes).id.toString(),
                    name: val.name);
              });
            },
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            items: hCalcTypes.map<String>((e) => e.name).toList(),
          ),
          TextInputWidget(
            width: dpWidth / 3 + 24.0,
            labelText: "Annual Holiday Entitlement",
            controller: annualHolidayEntitlement,
          ),
          TextInputWidget(
            width: dpWidth / 3 + 24.0,
            labelText: "Holidays Carried Over",
            controller: holidaysCarriedOver,
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                width: dpWidth / 6,
                controller: paidLunchtime,
                labelText: "Paid Lunchtime (min)",
              ),
              TextInputWidget(
                width: dpWidth / 6,
                controller: unpaidLunchtime,
                labelText: "Unpaid Lunchtime (min)",
              ),
            ],
          ),
        ]);
  }

  Widget _buildLeftBottom(double dpWidth) {
    return SpacedColumn(verticalSpace: 24.0, children: [
      _buildSalary(dpWidth, 'Salary Per Hour', true, salaryPerHour),
      _buildSalary(
          dpWidth, 'Salary Per Hour (Overtime)', false, salaryPerHourOvertime),
      _buildSalary(dpWidth, 'Salary Per Annum', true, salaryPerAnnum),
      if (errors.isNotEmpty)
        Center(
          child: KText(
            text: errors.join(".\n"),
            textColor: ThemeColors.red3,
            fontSize: 18,
          ),
        ),
    ]);
  }

  Widget _buildSalary(double dpWidth, String label, bool isRequired,
      TextEditingController controller) {
    return SpacedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 200.0,
          child: SpacedRow(
            horizontalSpace: 4.0,
            children: [
              KText(
                  text: label,
                  fontWeight: FWeight.bold,
                  isSelectable: false,
                  fontSize: 14.0,
                  textColor: ThemeColors.gray2),
              if (isRequired)
                KText(
                  text: '*',
                  fontWeight: FWeight.bold,
                  isSelectable: false,
                  fontSize: 14.0,
                  textColor: ThemeColors.red3,
                ),
            ],
          ),
        ),
        TextInputWidget(
          width: dpWidth / 8,
          hintText: "0.00",
          controller: controller,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                }
              : null,
          rightIcon: HeroIcons.pound,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _SaveAndCancelButtonsWidget(bool isNewContract) {
    return SpacedRow(
      mainAxisAlignment: MainAxisAlignment.end,
      horizontalSpace: 14.0,
      children: [
        ButtonLargeSecondary(
          paddingWithoutIcon: true,
          text: "Cancel",
          onPressed: () {
            context.navigateBack();
          },
          bgColor: ThemeColors.white,
        ),
        ButtonLarge(
          icon: const HeroIcon(HeroIcons.check),
          text: isNewContract ? "Add Contract" : "Save Contract",
          onPressed: _onSaveContract,
        ),
      ],
    );
  }

  Future<void> _onSaveContract() async {
    if (formKey.currentState!.validate()) {
      //Print all variables
      print("Contract Type: ${contractType.toJson()}");
      print("Contract Start Date: $contractStartDate");
      print("Contract End Date: $contractEndDate");
      print("Holiday Entitlement Start: ${holidayEntitlementStart.toJson()}");
      print("Holiday Calculation Type: ${holidayCalculationType.toJson()}");
      print("Salary Per Hour: ${salaryPerHour.text}");
      print("Salary Per Hour (Overtime): ${salaryPerHourOvertime.text}");
      print("Salary Per Annum: ${salaryPerAnnum.text}");
      print("Agreed Weekly Hours: ${aveWeeklyHours.text}");
      print("Agreed Days per Week: ${agreedDaysPerWeek.text}");
      print("Paid Lunchtime (min): ${paidLunchtime.text}");
      print("Unpaid Lunchtime (min): ${unpaidLunchtime.text}");
      print("Holidays Carried Over: ${holidaysCarriedOver.text}");
      print("Annual Holiday Entitlement: ${annualHolidayEntitlement.text}");
      print("Job Title: ${jobTitle.toJson()}");
      print("Holidays Carried Over: ${holidaysCarriedOver.text}");
      setState(() {
        errors.clear();
      });
      ApiResponse? res =
          await appStore.dispatch(GetPostUserDetailsContractAction(
        wdpw: agreedDaysPerWeek.text,
        salaryPH: double.parse(salaryPerHour.text.toString()),
        salaryPA: double.parse(salaryPerAnnum.text.toString()),
        salaryOT: double.parse(salaryPerHourOvertime.text),
        initHolidays: holidaysCarriedOver.text,
        jobTitle: jobTitle,
        hct: holidayCalculationType,
        csd: contractStartDate!,
        ced: contractEndDate,
        awh: int.parse(aveWeeklyHours.text),
        contractType: contractType,
        AHEonYS: holidayEntitlementStart,
        contractid: widget.contract?.id,
        ahe: annualHolidayEntitlement.text,
        lunchtime: paidLunchtime.text,
        lunchtimeUnpaid: unpaidLunchtime.text,
      ));

      if (res != null) {
        if (res.success) {
          //Do nothing
        } else {
          if (res.rawError != null) {
            final e = jsonDecode(res.rawError!.data)['errors'].values;
            for (var element in e) {
              setState(() {
                errors.add(element.first);
              });
            }
          }
        }
      }
    }
  }
}
