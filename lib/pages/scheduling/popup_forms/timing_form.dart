import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
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

class CreatedTimingReturnValue {
  DateTime? startDate;
  DateTime? altStartDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isAllDay = false;
  int? repeatTypeIndex;
  List<int> repeatDays = [];
}

class TimingForm extends StatefulWidget {
  final AppState state;
  final QuoteInfoMd? quoteInfo;
  const TimingForm({
    Key? key,
    required this.state,
    this.quoteInfo,
  }) : super(key: key);

  @override
  State<TimingForm> createState() => _TimingFormState();
}

class _TimingFormState extends State<TimingForm> {
  final ScrollController scrollController = ScrollController();

  QuoteInfoMd? get quote => widget.quoteInfo;

  AppState get state => widget.state;

  CompanyMd get company => GeneralController.to.companyInfo;

  final _formKey = GlobalKey<FormState>();

  final returnVal = CreatedTimingReturnValue();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (quote != null) {
        returnVal.startDate = quote!.workStartDate?.toDate("-");
        returnVal.altStartDate = quote!.altWorkStartDate?.toDate("-");
        returnVal.startTime = quote!.workStartTime?.formattedTime;
        returnVal.endTime = quote!.workFinishTime?.formattedTime;
        if (quote!.workStartTime == null && quote!.workFinishTime == null) {
          if (quote!.workStartTime?.formattedTime ==
                  const TimeOfDay(hour: 0, minute: 0) &&
              quote!.workFinishTime?.formattedTime ==
                  const TimeOfDay(hour: 23, minute: 59)) {
            returnVal.isAllDay = true;
          }
        }
        final workIndex = state.generalState.workRepeats
            .indexWhere((element) => element.id == quote!.workRepeat);
        if (workIndex != -1) {
          returnVal.repeatTypeIndex = workIndex;
        }
        returnVal.repeatDays = quote!.workDays;
        setState(() {});
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
                          text: returnVal.startDate?.formattedDate ?? "",
                        ),
                        onTap: () async {
                          final date = await showCustomDatePicker(context);
                          if (date == null) return;

                          setState(() {
                            returnVal.startDate = date;
                          });
                        },
                      ),
                    ),
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
                          final date = await showCustomDatePicker(context);

                          if (date == null) return;

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
                          if (returnVal.isAllDay) {
                            returnVal.startTime =
                                const TimeOfDay(hour: 0, minute: 0);
                            returnVal.endTime =
                                const TimeOfDay(hour: 23, minute: 59);
                          } else {
                            returnVal.startTime = null;
                            returnVal.endTime = null;
                          }
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
                            if (returnVal.endTime ==
                                    const TimeOfDay(hour: 23, minute: 59) &&
                                returnVal.startTime ==
                                    const TimeOfDay(hour: 0, minute: 0)) {
                              returnVal.isAllDay = true;
                            } else {
                              returnVal.isAllDay = false;
                            }
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
                            if (returnVal.endTime ==
                                    const TimeOfDay(hour: 23, minute: 59) &&
                                returnVal.startTime ==
                                    const TimeOfDay(hour: 0, minute: 0)) {
                              returnVal.isAllDay = true;
                            } else {
                              returnVal.isAllDay = false;
                            }
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
                            value: returnVal.repeatTypeIndex != null
                                ? CustomDropdownValue(
                                    name:
                                        workRepeats[returnVal.repeatTypeIndex!]
                                            .name)
                                : null,
                            onChanged: (index) {
                              setState(() {
                                returnVal.repeatTypeIndex = index;
                              });
                            },
                          ),
                        ),
                        if (returnVal.repeatTypeIndex != null)
                          if (workRepeats[returnVal.repeatTypeIndex!].id == 3)
                            SpacedColumn(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    KText(
                                        text: 'Days ',
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
                                for (var item
                                    in Constants.daysOfTheWeek.entries)
                                  chbx(returnVal.repeatDays.contains(item.key),
                                      (value) {
                                    setState(() {
                                      if (value) {
                                        returnVal.repeatDays.add(item.key);
                                      } else {
                                        returnVal.repeatDays.remove(item.key);
                                      }
                                    });
                                  }, item.value),
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
                if (returnVal.repeatTypeIndex == null) {
                  showError("Please select a repeat type");
                  return;
                }
                if (returnVal.repeatTypeIndex == 2) {
                  if (returnVal.repeatDays.isEmpty) {
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
