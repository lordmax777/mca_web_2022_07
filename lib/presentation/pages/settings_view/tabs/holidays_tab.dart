import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/spaced_column.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

class HolidaysTab extends StatefulWidget {
  const HolidaysTab({super.key});

  @override
  State<HolidaysTab> createState() => _HolidaysTabState();
}

class _HolidaysTabState extends State<HolidaysTab>
    with FormsMixin<HolidaysTab> {
  final generalState = appStore.state.generalState;
  final double fieldWidth = 450;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller1.text = DateFormat("dd/MM/yyyy")
          .format(DateTime.parse(generalState.companyInfo.yearstart));
      final hct = generalState.lists.holidayCalculationTypes.firstWhereOrNull(
          (element) => element.id == generalState.companyInfo.hct);
      if (hct != null) {
        selected1 = DefaultMenuItem(id: hct.id, title: hct.name);
      }
      controller2.text = generalState.companyInfo.ahew.toString();
      controller3.text = generalState.companyInfo.paidSickness.toString();
      controller4.text = generalState.companyInfo.piw.toString();
      setState(() {});
    });
  }

  late final holidayCalculationTypes = [
    ...generalState.lists.holidayCalculationTypes
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      surfaceTintColor: Colors.white,
      scrollable: true,
      content: Form(
        key: formKey,
        child: SizedBox(
          width: context.width * 0.8,
          child: SpacedColumn(
            verticalSpace: 36,
            children: [
              DefaultTextField(
                width: fieldWidth,
                label: "Year Start",
                controller: controller1,
                enabled: false,
                onTap: () {
                  showCustomDatePicker(context).then((value) {
                    if (value != null) {
                      controller1.text = DateFormat("dd/MM/yyyy").format(value);
                    }
                    setState(() {});
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a date";
                  }
                  return null;
                },
              ),

              //lock time after failed login
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultDropdown(
                    label: "Holiday Calculation Type",
                    width: fieldWidth,
                    valueId: selected1?.id ??
                        holidayCalculationTypes
                            .firstWhereOrNull(
                                (element) => element.name == "Basic")
                            ?.id,
                    items: [
                      for (final item in holidayCalculationTypes)
                        DefaultMenuItem(id: item.id, title: item.name),
                    ],
                    hasSearchBox: true,
                    onChanged: (value) {
                      setState(() {
                        selected1 = value;
                      });
                    },
                  ),
                  subLabel("Default: Basic"),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    width: fieldWidth,
                    label: "Annual Holiday Entitlement (Weeks)",
                    controller: controller2,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  subLabel("Default: 5.6 weeks"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    width: fieldWidth,
                    label: "SSP Waiting Days",
                    controller: controller3,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  subLabel("Default: 3 Days"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextField(
                    width: fieldWidth,
                    label: "SSP Link Period of Incapacity for Work (Weeks)",
                    controller: controller4,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a value";
                      }
                      return null;
                    },
                  ),
                  subLabel("Default: 8 Weeks"),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(onPressed: save, child: const Text("Save")),
      ],
    );
  }

  void save() {
    if (!isFormValid) return;
    context.futureLoading(() async {
      final res = await dispatch<bool>(SaveCompanyDetailsAction(
        yearStart: controller1.text,
        holidayCalculationType: selected1?.id,
        annualHolidayEntitlementWeeks: int.tryParse(controller2.text),
        periodOfIncapacity: int.tryParse(controller4.text),
        paidSickness: int.tryParse(controller3.text),
      ));
      if (res.isLeft) {
        context.showSuccess("Saved successfully");
      } else if (res.isRight) {
        context.showError(res.right.message);
      } else {
        context.showError("Something went wrong");
      }
    });
  }

  Text subLabel(String value) {
    return Text(
      value,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}
