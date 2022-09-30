import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class UserDetailsPayrollTabNewContractPage extends StatefulWidget {
  final int? id;
  const UserDetailsPayrollTabNewContractPage({Key? key, this.id})
      : super(key: key);

  @override
  State<UserDetailsPayrollTabNewContractPage> createState() =>
      _UserDetailsPayrollTabNewContractPageState();
}

class _UserDetailsPayrollTabNewContractPageState
    extends State<UserDetailsPayrollTabNewContractPage> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isNewContract = true;

  String? jobTitle;
  String? contractType;
  String? holidayEntitlementStart;
  String? holidayCalculationType;
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
    if (widget.id != null) {
      isNewContract = false;
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
                        _buildLeft(dpWidth),
                        _buildRight(dpWidth),
                      ],
                    ),
                    const Divider(color: ThemeColors.gray11, thickness: 1.0),
                    _SaveAndCancelButtonsWidget(isNewContract: isNewContract),
                  ],
                ),
              ),
            ),
          ]));
        });
  }

  Widget _buildLeft(double dpWidth) {
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 1),
          DropdownWidget(
            hintText: "Job Title",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            value: jobTitle,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Contract Type",
            value: contractType,
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            onChanged: (_) {},
            items: [],
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                controller:
                    TextEditingController(text: contractStartDate?.toString()),
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
                    initialDate: DateTime(2015),
                    firstDate: DateTime(1930),
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
                controller: TextEditingController(
                    text: contractEndDate?.toIso8601String()),
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
                    initialDate: DateTime(2015),
                    firstDate: DateTime(1930),
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
                width: dpWidth / 6,
                enabled: false,
                labelText: "Agreed Weekly Hours",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value";
                  }
                },
                onTap: () {},
              ),
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 6,
                enabled: false,
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

  Widget _buildRight(double dpWidth) {
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(),
          DropdownWidget(
            hintText: "Annual Holiday Entitlement Start",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Holiday Calculation Type",
            dropdownBtnWidth: dpWidth / 3 + 24.0,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 24.0,
            onChanged: (_) {},
            items: [],
          ),
          TextInputWidget(
            width: dpWidth / 3 + 24.0,
            labelText: "Annual Holiday Entitlement",
          ),
          TextInputWidget(
            width: dpWidth / 3 + 24.0,
            labelText: "Holidays Carried Over",
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                width: dpWidth / 6,
                labelText: "Paid Lunchtime (min)",
              ),
              TextInputWidget(
                width: dpWidth / 6,
                labelText: "Unpaid Lunchtime (min)",
              ),
            ],
          ),
        ]);
  }

  Widget _buildLeftBottom(double dpWidth) {
    return SpacedColumn(verticalSpace: 24.0, children: [
      _buildSalary(dpWidth, 'Salary Per Hour', true),
      _buildSalary(dpWidth, 'Salary Per Hour (Overtime)', false),
      _buildSalary(dpWidth, 'Salary Per Annum', true),
    ]);
  }

  Widget _buildSalary(double dpWidth, String label, bool isRequired) {
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
}

class _SaveAndCancelButtonsWidget extends StatelessWidget {
  final bool isNewContract;
  const _SaveAndCancelButtonsWidget({Key? key, this.isNewContract = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          onPressed: () {
            _UserDetailsPayrollTabNewContractPageState.formKey.currentState
                ?.validate();
          },
        ),
      ],
    );
  }
}
