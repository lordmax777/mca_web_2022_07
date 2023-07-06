import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/users_view/data/data_source.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/utils.dart';

class PayrollPopup extends StatefulWidget {
  final UserContractMd? contract;
  final int userId;

  const PayrollPopup({super.key, this.contract, required this.userId});

  @override
  State<PayrollPopup> createState() => _PayrollPopupState();
}

class _PayrollPopupState extends State<PayrollPopup> {
  UserContractMd? get contract => widget.contract;

  bool get isNew => contract == null;

  final formKey = GlobalKey<FormState>();
  late PayrollDataSource data;

  @override
  void initState() {
    data = PayrollDataSource.fromUserContract(contract,
        jobTitles: appStore.state.generalState.lists.jobTitles,
        contractTypes: appStore.state.generalState.lists.contractTypes,
        contractStarts: appStore.state.generalState.lists.contractStarts,
        holidayCalculationTypes:
            appStore.state.generalState.lists.holidayCalculationTypes);
    super.initState();
  }

  void updateUI() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Text("${isNew ? "Add" : "Update"} Contract"),
          const Spacer(),
          IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;
            if (!data.isValid(context)) return;
            //Create new contract
            await context.futureLoading(() async {
              final success = await dispatch<bool>(
                  PostUserContractAction(widget.userId, data));
              if (success.isRight) {
                context.showError(success.right.message);
                return;
              }
              context.pop(true);
            });
          },
          child: Text(isNew ? "Add" : "Update"),
        ),
      ],
      contentPadding: const EdgeInsets.all(8),
      content: SingleChildScrollView(
        child: SizedBox(
          width: context.width,
          child: Form(
            key: formKey,
            child: StoreConnector<AppState, ListMd>(
              converter: (store) => store.state.generalState.lists,
              builder: (context, vm) {
                final jobTitles =
                    [...vm.jobTitles].where((element) => element.active);
                final contractTypes = [...vm.contractTypes];
                final holidayEntitlements = [...vm.contractStarts];
                final holdiayCalcTypes = [...vm.holidayCalculationTypes];
                return Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    UserCard(
                      width: 550,
                      title: "",
                      items: [
                        UserCardItem(
                            isRequired: true,
                            title: "Job Title",
                            dropdown: UserCardDropdown(
                              valueId: data.jobTitle?.id,
                              items: [
                                for (final item in jobTitles)
                                  DefaultMenuItem(
                                    id: item.id,
                                    title: item.name,
                                  )
                              ],
                              onChanged: (value) {
                                data = data.copyWith(
                                    jobTitle: jobTitles.firstWhere(
                                        (element) => element.id == value.id));
                                updateUI();
                              },
                            )),
                        UserCardItem(
                            isRequired: true,
                            title: "Contract Type",
                            dropdown: UserCardDropdown(
                              valueId: data.contractType?.id,
                              items: [
                                for (final item in contractTypes)
                                  DefaultMenuItem(
                                    id: item.id,
                                    title: item.name,
                                  )
                              ],
                              onChanged: (value) {
                                data = data.copyWith(
                                    contractType: contractTypes.firstWhere(
                                        (element) => element.id == value.id));
                                updateUI();
                              },
                            )),
                        UserCardItem(
                          isRequired: true,
                          title: "Start Date",
                          simpleText:
                              data.contractStartDate?.toApiDateWithDash ??
                                  "Select Date",
                          onSimpleTextTapped: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: data.contractStartDate ??
                                        DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100))
                                .then((value) {
                              if (value != null) {
                                data = data.copyWith(contractStartDate: value);
                                updateUI();
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          isRequired: true,
                          title: "End Date",
                          simpleText: data.contractEndDate?.toApiDateWithDash ??
                              "Select Date",
                          onSimpleTextTapped: () {
                            showDatePicker(
                                    context: context,
                                    initialDate:
                                        data.contractEndDate ?? DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100))
                                .then((value) {
                              if (value != null) {
                                data = data.copyWith(contractEndDate: value);
                                updateUI();
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          isRequired: true,
                          title: "Agreed Weekly Hours",
                          controller: data.agreedWeeklyHoursController,
                        ),
                        UserCardItem(
                          isRequired: true,
                          title: "Agreed Days per Week",
                          controller: data.workingDaysPerWeekController,
                        ),
                      ],
                    ),
                    UserCard(
                      width: 550,
                      title: "",
                      items: [
                        UserCardItem(
                            isRequired: true,
                            title: "AHE Start Date",
                            dropdown: UserCardDropdown(
                              valueId: data.annualHolidayEntitlementStart?.id,
                              items: [
                                for (final item in holidayEntitlements)
                                  DefaultMenuItem(
                                    id: item.id,
                                    title: item.name,
                                  )
                              ],
                              onChanged: (value) {
                                data = data.copyWith(
                                    annualHolidayEntitlementStart:
                                        holidayEntitlements.firstWhere(
                                            (element) =>
                                                element.id == value.id));
                                updateUI();
                              },
                            )),
                        UserCardItem(
                            isRequired: true,
                            title: "Holiday Calculation Type",
                            dropdown: UserCardDropdown(
                              valueId: data.holidayCalculationType?.id,
                              items: [
                                for (final item in holdiayCalcTypes)
                                  DefaultMenuItem(
                                    id: item.id,
                                    title: item.name,
                                  )
                              ],
                              onChanged: (value) {
                                data = data.copyWith(
                                    holidayCalculationType:
                                        holdiayCalcTypes.firstWhere((element) =>
                                            element.id == value.id));
                                updateUI();
                              },
                            )),
                        UserCardItem(
                          title: "Annual Holiday Entitlement",
                          controller: data.annualHolidayEntitlementController,
                        ),
                        UserCardItem(
                          title: "Holidays Carried Over",
                          controller: data.holidaysCarriedOutController,
                        ),
                      ],
                    ),
                    UserCard(
                      width: 550,
                      title: "",
                      items: [
                        UserCardItem(
                          title: "Paid Lunchtime (min)",
                          controller: data.paidLunchTimeController,
                        ),
                        UserCardItem(
                          title: "Unpaid Lunchtime (min)",
                          controller: data.unpaidLunchTimeController,
                        ),
                        UserCardItem(
                          isRequired: true,
                          title: "Salary Per Hour",
                          controller: data.salaryPerHourController,
                        ),
                        UserCardItem(
                          title: "Salary Per Hour (Overtime)",
                          controller: data.salaryPerHourOvertimeController,
                        ),
                        UserCardItem(
                          isRequired: true,
                          title: "Salary Salary Per Annum",
                          controller: data.salaryPerAnnumController,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
