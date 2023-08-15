import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';

import 'create_schedule_popup.dart';

class TimingPopup extends StatefulWidget {
  final TimeData data;
  final bool isDateRequired;
  const TimingPopup(
      {super.key, required this.data, this.isDateRequired = true});

  @override
  State<TimingPopup> createState() => _TimingPopupState();
}

class _TimingPopupState extends State<TimingPopup> {
  late final TimeData data;
  final _formKey = GlobalKey<FormState>();

  bool get isAllDay => data.isAllDay;

  bool get isDateRequired => widget.isDateRequired;

  @override
  void initState() {
    data = widget.data.copyWith();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ListMd>(
      converter: (store) => store.state.generalState.lists,
      builder: (context, vm) => AlertDialog(
        title: const Text('Edit Timing'),
        scrollable: true,
        content: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                label('Start Date', isRequired: isDateRequired),
                DefaultTextField(
                    width: double.infinity,
                    enabled: false,
                    validator: !isDateRequired
                        ? null
                        : (p0) {
                            if (data.start == null) {
                              return 'Start date is required';
                            }
                            return null;
                          },
                    onTap: () {
                      showDatePicker(
                        context: context,
                        firstDate: kDebugMode ? DateTime(2020) : DateTime.now(),
                        initialDate: data.start!,
                        lastDate: DateTime(2030),
                      ).then((value) {
                        if (value != null) {
                          data.start = value;
                          setState(() {});
                        }
                      });
                    },
                    controller: TextEditingController(
                        text: data.start?.companyFormatDateTime())),
                if (data.showAltDate) label('Alt Start Date'),
                if (data.showAltDate)
                  DefaultTextField(
                      width: double.infinity,
                      enabled: false,
                      onTap: () {
                        showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate:
                                    data.altStartDate ?? DateTime.now(),
                                lastDate: DateTime(2030),
                                cancelText: "Clear and Close")
                            .then((value) {
                          data.altStartDate = value;
                          setState(() {});
                        });
                      },
                      controller: TextEditingController(
                          text: data.altStartDate?.companyFormatDateTime())),
                const SizedBox(height: 8),
                label('All day'),
                DefaultSwitch(
                  value: isAllDay,
                  onChanged: (value) {
                    if (value == true) {
                      data.startTime = const TimeOfDay(hour: 0, minute: 0);
                      data.endTime = const TimeOfDay(hour: 23, minute: 59);
                    } else {
                      data.startTime = null;
                      data.endTime = null;
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(height: 8),
                label('Start Time', isRequired: isDateRequired),
                DefaultTextField(
                  width: double.infinity,
                  validator: !isDateRequired
                      ? null
                      : (p0) {
                          if (data.startTime == null) {
                            return 'Start time is required';
                          }
                          return null;
                        },
                  enabled: false,
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: data.startTime ?? TimeOfDay.now(),
                    ).then((value) {
                      if (value != null) {
                        data.startTime = value;
                        setState(() {});
                      }
                    });
                  },
                  controller: TextEditingController(
                      text: data.startTime?.format(context) ?? ''),
                ),
                const SizedBox(height: 8),
                label('End Time', isRequired: isDateRequired),
                DefaultTextField(
                  width: double.infinity,
                  validator: !isDateRequired
                      ? null
                      : (p0) {
                          if (data.endTime == null) {
                            return 'End time is required';
                          }
                          return null;
                        },
                  enabled: false,
                  onTap: () {
                    showTimePicker(
                      context: context,
                      initialTime: data.endTime ?? TimeOfDay.now(),
                    ).then((value) {
                      if (value != null) {
                        data.endTime = value;
                        setState(() {});
                      }
                    });
                  },
                  controller: TextEditingController(
                      text: data.endTime?.format(context)),
                ),
                const SizedBox(height: 8),
                label('Repeats', isRequired: isDateRequired),
                DefaultDropdown(
                  valueId: data.repeat?.id,
                  width: double.infinity,
                  items: [
                    for (var item in vm.workRepeats)
                      DefaultMenuItem(
                        id: item.id,
                        title: item.name,
                        subtitle: "${item.days} day(s)",
                      ),
                  ],
                  onChanged: (value) {
                    data.repeat = vm.workRepeats
                        .firstWhereOrNull((e) => e.id == value.id);
                    setState(() {});
                  },
                ),
                if (data.showRepeatDays) const SizedBox(height: 8),
                if (data.showRepeatDays)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label('Week 1', isRequired: true),
                      for (var item in data.week1.asMap.entries)
                        DefaultCheckbox(
                          label: item.key,
                          value: item.value,
                          onChanged: (value) {
                            data.week1.updateValueByKey(item.key);
                            setState(() {});
                          },
                        ),
                      if (data.showWeek2) const SizedBox(height: 8),
                      if (data.showWeek2) label('Week 2', isRequired: true),
                      if (data.showWeek2)
                        for (var item in data.week2.asMap.entries)
                          DefaultCheckbox(
                            label: item.key,
                            value: item.value,
                            onChanged: (value) {
                              data.week2.updateValueByKey(item.key);
                              setState(() {});
                            },
                          ),
                    ],
                  )
              ]),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: isDateRequired && data.repeat == null
                ? null
                : () {
                    if (!_formKey.currentState!.validate()) return;
                    if (isDateRequired) {
                      if (data.showRepeatDays) {
                        if (!data.week1.isAnyChecked) {
                          context.showError(
                              'Please select at least one day in week 1');
                          return;
                        }
                        if (data.showWeek2 && !data.week2.isAnyChecked) {
                          context.showError(
                              'Please select at least one day in week 2');
                          return;
                        }
                      }
                    }
                    context.pop(data);
                  },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
