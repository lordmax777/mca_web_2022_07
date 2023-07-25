import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

class ShiftTab extends StatefulWidget {
  const ShiftTab({super.key});

  @override
  State<ShiftTab> createState() => _ShiftTabState();
}

class _ShiftTabState extends State<ShiftTab> with FormsMixin<ShiftTab> {
  final generalState = appStore.state.generalState;
  final double fieldWidth = 320;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final companyInfo = generalState.companyInfo;
      final rotaLen = generalState.lists.payPeriods
          .firstWhereOrNull((element) => element.id == companyInfo.rotalength);
      if (rotaLen != null) {
        selected1 = DefaultMenuItem(id: rotaLen.id, title: rotaLen.name);
        setState(() {});
      }
      controller2.text = companyInfo.rounding.toString();
      controller3.text = companyInfo.grace.toString();
      controller4.text = companyInfo.breaks.toString();
      controller5.text = companyInfo.breakTime.toString();
      controller6.text = companyInfo.breakTimeTotal.toString();
      controller7.text = companyInfo.minRest.toString();
      controller8.text = companyInfo.timeValidity.toString();
      controller9.text = companyInfo.lunchtime.toString();
      controller10.text = companyInfo.lunchtimeUnpaid.toString();
      controller11.text = companyInfo.minHoursForLunch.toString();

      //reminders
      controller12.text = companyInfo.lateReminders;
      controller13.text = companyInfo.longBreakReminders;
      controller14.text = companyInfo.signOutReminders;
      controller15.text = companyInfo.autoSignOut.toString();
    });
  }

  late final rotaLengths = [...generalState.lists.payPeriods];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      surfaceTintColor: Colors.white,
      contentPadding: EdgeInsets.zero,
      content: Form(
        key: formKey,
        child: SizedBox(
          width: context.width * 0.8,
          child: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              children: [
                SpacedColumn(
                  verticalSpace: 36,
                  children: [
                    Text("Shift Timings",
                        style: context.textTheme.headlineLarge),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultDropdown(
                          label: "Length of the Rota",
                          width: fieldWidth,
                          valueId: selected1?.id ??
                              rotaLengths
                                  .firstWhereOrNull(
                                      (element) => element.name == "Basic")
                                  ?.id,
                          items: [
                            for (final item in rotaLengths)
                              DefaultMenuItem(
                                id: item.id,
                                title: item.name,
                              ),
                          ],
                          hasSearchBox: true,
                          onChanged: (value) {
                            setState(() {
                              selected1 = value;
                            });
                          },
                        ),
                        subLabel("Default: Weekly"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Rounding (Minutes)",
                          controller: controller2,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        subLabel("Default: 15"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Grace Period (Minutes)",
                          controller: controller3,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        subLabel("Default: 5"),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Number of Breaktime Allowed",
                          controller: controller4,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        subLabel("Default: 1"),
                      ],
                    ),

                    //Break time per session (Minutes)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Break time per session (Minutes)",
                          controller: controller5,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        subLabel("Default: 20"),
                      ],
                    ),
                    //Break time per shift (Minutes)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Total break time per shift (Minutes)",
                          controller: controller6,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        subLabel("Default: 30"),
                      ],
                    ),

                    //minimum rest between shift (Hours)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Minimum rest between shift (Hours)",
                          controller: controller7,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        subLabel("Default: 11"),
                      ],
                    ),
                    //Punch time before and after shift (Minutes)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Punch time before and after shift (Minutes)",
                          controller: controller8,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        subLabel("Default: 60"),
                      ],
                    ),

                    //Paid lunchtime (Minutes)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Paid lunchtime (Minutes)",
                          controller: controller9,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        subLabel("Default: 40"),
                      ],
                    ),

                    //Unpaid lunchtime (Minutes)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Unpaid lunchtime (Minutes)",
                          controller: controller10,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                            }
                            return null;
                            // return "Please enter a value";
                          },
                        ),
                        subLabel("Default: 20"),
                      ],
                    ),

                    //Minimum working hours for lunchtime
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultTextField(
                          width: fieldWidth,
                          label: "Minimum working hours for lunchtime",
                          controller: controller11,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a value";
                              // return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                        subLabel("Default: 6"),
                      ],
                    ),
                  ],
                ),
                SpacedColumn(verticalSpace: 36, children: [
                  Text("Reminders", style: context.textTheme.headlineLarge),
                  //Late reminder (Minutes)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextField(
                        width: fieldWidth,
                        label: "Late reminders",
                        controller: controller12,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a value";
                          }
                          return null;
                        },
                      ),
                      subLabel("Default: 5, 15"),
                    ],
                  ),

                  //Long Break Reminder (Minutes)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextField(
                        width: fieldWidth,
                        label: "Long Break Reminders",
                        controller: controller13,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a value";
                          }
                          return null;
                        },
                      ),
                      subLabel("Default: 5, 15"),
                    ],
                  ),

                  //Sign out reminder (Minutes)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextField(
                        width: fieldWidth,
                        label: "Sign out reminders",
                        controller: controller14,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a value";
                          }
                          return null;
                        },
                      ),
                      subLabel("Default: 15, 30"),
                    ],
                  ),

                  //Auto Sign out time (Minutes)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextField(
                        width: fieldWidth,
                        label: "Auto Sign out time (Minutes)",
                        controller: controller15,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a value";
                          }
                          return null;
                        },
                      ),
                      subLabel("Default: 35"),
                    ],
                  ),
                ])
              ],
            ),
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
        rotaLength: selected1?.id,
        rounding: int.tryParse(controller2.text),
        gracePeriod: int.tryParse(controller3.text),
        breaks: int.tryParse(controller4.text),
        breakTime: int.tryParse(controller5.text),
        breakTimeTotal: int.tryParse(controller6.text),
        minRest: int.tryParse(controller7.text),
        timeValidity: int.tryParse(controller8.text),
        lunchtime: int.tryParse(controller9.text),
        lunchtimeUnpaid: int.tryParse(controller10.text),
        minHoursForLunch: int.tryParse(controller11.text),
        lateReminders: controller12.text,
        longBreakReminders: controller13.text,
        signOutReminders: controller14.text,
        autoSignOutTime: int.tryParse(controller15.text),
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
