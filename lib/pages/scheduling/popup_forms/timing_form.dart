import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/mca_loading.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';

import '../../../comps/modals/custom_date_picker.dart';
import '../../../comps/modals/custom_time_picker.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/models/list_all_md.dart';
import '../../../manager/models/location_item_md.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../theme/theme.dart';
import '../../../utils/global_functions.dart';
import '../../properties/new_prop_tabs/shift_details_tab.dart';
import '../create_shift_popup.dart';
import '../models/timing_model.dart';

class CreatedTimingReturnValue {
  DateTime? startDate;
  DateTime? altStartDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isAllDay = false;
  int? repeatTypeIndex;
  List<int> repeatDays = [];
  bool hasAltTime;

  CreatedTimingReturnValue({
    this.startDate,
    this.altStartDate,
    this.startTime,
    this.endTime,
    this.isAllDay = false,
    this.repeatTypeIndex,
    this.hasAltTime = true,
  });
}

class TimingForm extends StatefulWidget {
  final AppState state;
  final TimingModel? timingInfo;
  final bool hasAltStartDate;
  const TimingForm({
    Key? key,
    required this.state,
    this.timingInfo,
    this.hasAltStartDate = false,
  }) : super(key: key);

  @override
  State<TimingForm> createState() => _TimingFormState();
}

class _TimingFormState extends State<TimingForm> {
  final ScrollController scrollController = ScrollController();

  TimingModel? get timingInfo => widget.timingInfo;
  AppState get state => widget.state;
  bool get hasAltStartDate => widget.hasAltStartDate;

  CompanyMd get company => GeneralController.to.companyInfo;

  final _formKey = GlobalKey<FormState>();

  TimingModel returnVal = TimingModel();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (timingInfo != null) {
        setState(() {
          returnVal = timingInfo!.copy();
        });
      }
    });
  }

  final fieldWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    final List<ListWorkRepeats> workRepeats = [
      ...state.generalState.workRepeats
    ];

    return AlertDialog(
      contentPadding:
          const EdgeInsets.only(left: 60, top: 20, bottom: 20, right: 50),
      title: Row(
        children: [
          const Text("Create Timing"),
          const Spacer(),
          IconButton(
            onPressed: () {
              onWillPop(context).then((value) {
                if (value) {
                  context.popRoute();
                }
              });
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: RawScrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        trackColor: Colors.grey.withOpacity(0.6),
        thickness: 10,
        thumbColor: ThemeColors.MAIN_COLOR.withOpacity(0.7),
        controller: scrollController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 20),
          controller: scrollController,
          child: Form(
            key: _formKey,
            child: rowOrColumnWrapper(
              false,
              [
                SpacedColumn(
                  verticalSpace: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    labelWithField(
                      "Start Date",
                      TextInputWidget(
                        width: 300,
                        rightIcon: HeroIcons.calendar,
                        isReadOnly: true,
                        hintText: "Start date",
                        controller: TextEditingController(
                          text: returnVal.date?.formattedDate ?? "",
                        ),
                        onTap: () async {
                          final date = await showCustomDatePicker(context,
                              initialTime: returnVal.date);
                          if (date == null) return;
                          if (date.isBefore(DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day))) {
                            McaLoading.showFail("Date cannot be before today");
                            return;
                          }

                          setState(() {
                            returnVal.date = date;
                          });
                        },
                      ),
                    ),
                    if (hasAltStartDate)
                      labelWithField(
                        "Alternative Start Date",
                        TextInputWidget(
                          width: 300,
                          rightIcon: HeroIcons.calendar,
                          isReadOnly: true,
                          hintText: "Start date",
                          controller: TextEditingController(
                            text: returnVal.altStartDate?.formattedDate ?? "",
                          ),
                          onTap: () async {
                            final date = await showCustomDatePicker(context,
                                initialTime: returnVal.altStartDate);

                            if (date == null) return;
                            if (date.isBefore(DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day))) {
                              McaLoading.showFail(
                                  "Date cannot be before today");
                              return;
                            }

                            setState(() {
                              returnVal.altStartDate = date;
                            });
                          },
                        ),
                      ),
                    labelWithField(
                      "All day",
                      toggle(returnVal.isAllDay, (val) {
                        setState(() {
                          returnVal.isAllDay = val;
                        });
                      }),
                    ),
                    labelWithField(
                      "Start Time",
                      TextInputWidget(
                        width: 300,
                        rightIcon: HeroIcons.clock,
                        isReadOnly: true,
                        hintText: "Select start time",
                        controller: TextEditingController(
                          text: returnVal.startTime?.format(context) ?? "",
                        ),
                        onTap: () async {
                          final res = await showCustomTimePicker(context,
                              initialTime: returnVal.startTime);
                          if (res == null) return;
                          setState(() {
                            returnVal.startTime = res;
                          });
                        },
                      ),
                    ),
                    labelWithField(
                      "End Time",
                      TextInputWidget(
                        width: 300,
                        rightIcon: HeroIcons.clock,
                        isReadOnly: true,
                        hintText: "Select end time",
                        controller: TextEditingController(
                          text: returnVal.endTime?.format(context) ?? "",
                        ),
                        onTap: () async {
                          final res = await showCustomTimePicker(context,
                              initialTime: returnVal.endTime);
                          if (res == null) return;
                          setState(() {
                            returnVal.endTime = res;
                          });
                        },
                      ),
                    ),
                    SpacedColumn(
                      verticalSpace: 16,
                      children: [
                        labelWithField(
                          "Repeats",
                          DropdownWidgetV2(
                            hintText: "Select a repeat",
                            dropdownBtnWidth: 300,
                            dropdownOptionsWidth: 300,
                            isRequired: true,
                            items: workRepeats
                                .map((e) => CustomDropdownValue(name: e.name))
                                .toList(),
                            value: returnVal.repeat != null
                                ? CustomDropdownValue(
                                    name: returnVal.repeat!.name)
                                : null,
                            onChanged: (index) {
                              setState(() {
                                returnVal.days.clear();
                                returnVal.repeat = workRepeats[index];
                              });
                            },
                          ),
                        ),
                        if (returnVal.repeat != null)
                          if (returnVal.repeat!.id == 3 ||
                              returnVal.repeat!.id == 4)
                            SpacedColumn(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    KText(
                                        text: 'Week 1',
                                        textColor: ThemeColors.gray2,
                                        fontSize: 14,
                                        fontWeight: FWeight.bold),
                                    KText(
                                        text: '*',
                                        textColor: ThemeColors.red3,
                                        fontSize: 14,
                                        fontWeight: FWeight.bold),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                for (var item in Constants.daysOfTheWeek.keys
                                    .where((value) => value < 8))
                                  chbx(returnVal.days.containsKey(item),
                                      (value) {
                                    setState(() {
                                      if (value) {
                                        returnVal.days[item] =
                                            Constants.daysOfTheWeek[item]!;
                                      } else {
                                        returnVal.days.remove(item);
                                      }
                                    });
                                  }, Constants.daysOfTheWeek[item] ?? ""),
                                const SizedBox(height: 16),
                                if (returnVal.repeat!.id == 4)
                                  Row(
                                    children: [
                                      KText(
                                          text: 'Week 2',
                                          textColor: ThemeColors.gray2,
                                          fontSize: 14,
                                          fontWeight: FWeight.bold),
                                      KText(
                                          text: '*',
                                          textColor: ThemeColors.red3,
                                          fontSize: 14,
                                          fontWeight: FWeight.bold),
                                    ],
                                  ),
                                if (returnVal.repeat!.id == 4)
                                  const SizedBox(height: 16),
                                if (returnVal.repeat!.id == 4)
                                  for (var item in Constants.daysOfTheWeek.keys
                                      .where((value) => value > 7))
                                    chbx(returnVal.days.containsKey(item),
                                        (value) {
                                      setState(() {
                                        if (value) {
                                          returnVal.days[item] =
                                              Constants.daysOfTheWeek[item]!;
                                        } else {
                                          returnVal.days.remove(item);
                                        }
                                      });
                                    }, Constants.daysOfTheWeek[item] ?? ""),
                              ],
                            ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ButtonLarge(
            text: "Cancel",
            onPressed: () {
              onWillPop(context).then((value) {
                if (value) {
                  context.popRoute();
                }
              });
            }),
        ButtonLarge(
            text: "Save",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (returnVal.repeat == null) {
                  showError("Please select a repeat type");
                  return;
                }
                if (returnVal.repeat!.id == 3 || returnVal.repeat!.id == 4) {
                  if (returnVal.days.isEmpty) {
                    showError("Please select at least one day");
                    return;
                  }
                }
                context.popRoute(returnVal);
              }
            }),
      ],
    );
  }

  Widget rowOrColumnWrapper(bool isRow, List<Widget> children) {
    if (isRow) {
      return SpacedRow(
        horizontalSpace: 32,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }
    return SpacedColumn(
      verticalSpace: 16,
      children: children,
    );
  }
}
