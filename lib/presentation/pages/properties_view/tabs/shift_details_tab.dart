import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/data/shift_details.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/create_schedule_popup.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class ShiftDetailsTab extends StatelessWidget {
  final ValueChanged<ShiftDetailsData> onChanged;
  final ShiftDetailsData data;
  const ShiftDetailsTab(
      {super.key, required this.data, required this.onChanged});

  set data(ShiftDetailsData value) {
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, vm) {
          final locations = [...vm.lists.locations];
          final clients = [...vm.lists.clients];
          final warehouses = [...vm.lists.warehouses];
          final checklistTemplates = [...vm.checklistTemplates];

          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16),
            child: SpacedColumn(
              verticalSpace: 16.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: [
                    //Details
                    UserCard(
                      title: "Shift Details",
                      items: [
                        UserCardItem(
                          title:
                              "${appStore.state.generalState.propertyName} name",
                          isRequired: true,
                          controller: data.propertyName,
                        ),
                        UserCardItem(
                          title: "Location",
                          isRequired: true,
                          dropdown: UserCardDropdown(
                            valueId: data.locationId,
                            onChanged: (value) {
                              data = data.copyWith(locationId: value.id);
                            },
                            items: [
                              for (var item in locations)
                                DefaultMenuItem(
                                  id: item.id,
                                  title: item.name,
                                ),
                            ],
                          ),
                        ),
                        UserCardItem(
                          title: "Client",
                          isRequired: true,
                          dropdown: UserCardDropdown(
                            valueId: data.clientId,
                            onChanged: (value) {
                              data = data.copyWith(clientId: value.id);
                            },
                            items: [
                              for (var item in clients)
                                DefaultMenuItem(
                                  id: item.id,
                                  title: item.name,
                                ),
                            ],
                          ),
                        ),
                        UserCardItem(
                          title: "Warehouse",
                          isRequired: true,
                          dropdown: UserCardDropdown(
                            valueId: data.warehouseId,
                            onChanged: (value) {
                              data = data.copyWith(warehouseId: value.id);
                            },
                            items: [
                              for (var item in warehouses)
                                DefaultMenuItem(
                                  id: item.id,
                                  title: item.name,
                                ),
                            ],
                          ),
                        ),
                        UserCardItem(
                          title: "Checklist Template",
                          isRequired: true,
                          dropdown: UserCardDropdown(
                            valueId: data.checklistTemplateId,
                            onChanged: (value) {
                              data =
                                  data.copyWith(checklistTemplateId: value.id);
                            },
                            items: [
                              for (var item in checklistTemplates)
                                DefaultMenuItem(
                                  id: item.id!,
                                  title: item.name,
                                ),
                            ],
                          ),
                        ),
                        UserCardItem(
                            customWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            label('Days', isRequired: true),
                            const SizedBox(height: 8.0),
                            for (var item in data.weekDays.asMap.entries)
                              DefaultCheckbox(
                                label: item.key,
                                value: item.value,
                                onChanged: (value) {
                                  data.weekDays.updateValueByKey(item.key);
                                  data = data.copyWith();
                                },
                              ),
                          ],
                        ))
                      ],
                    ),

                    //Timing
                    UserCard(
                      title: "Timings",
                      items: [
                        UserCardItem(
                          title: "Start Time",
                          simpleText:
                              data.startTime?.format(context) ?? "Select Time",
                          isRequired: true,
                          onSimpleTextTapped: () {
                            showTimePicker(
                              context: context,
                              initialTime: data.startTime ?? TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                data = data.copyWith(startTime: value);
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          title: "End Time",
                          simpleText:
                              data.endTime?.format(context) ?? "Select Time",
                          isRequired: true,
                          onSimpleTextTapped: () {
                            showTimePicker(
                              context: context,
                              initialTime: data.endTime ?? TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                data = data.copyWith(endTime: value);
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          title: "Break Time",
                          simpleText: data.breakStartTime?.format(context) ??
                              "Select Time",
                          onSimpleTextTapped: () {
                            showTimePicker(
                              context: context,
                              initialTime:
                                  data.breakStartTime ?? TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                data = data.copyWith(breakStartTime: value);
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          title: "Break End Time",
                          simpleText: data.breakEndTime?.format(context) ??
                              "Select Time",
                          onSimpleTextTapped: () {
                            showTimePicker(
                              context: context,
                              initialTime: data.breakEndTime ?? TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                data = data.copyWith(breakEndTime: value);
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          title: "Strict Break Time",
                          checked: data.strictBreakTime,
                          onChecked: (value) {
                            data = data.copyWith(strictBreakTime: value);
                          },
                        ),
                        UserCardItem(
                          title: "Mobile Start Time",
                          simpleText: data.mobileStartTime?.format(context) ??
                              "Select Time",
                          onSimpleTextTapped: () {
                            showTimePicker(
                              context: context,
                              initialTime:
                                  data.mobileStartTime ?? TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                data = data.copyWith(mobileStartTime: value);
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          title: "Mobile End Time",
                          simpleText: data.mobileEndTime?.format(context) ??
                              "Select Time",
                          onSimpleTextTapped: () {
                            showTimePicker(
                              context: context,
                              initialTime:
                                  data.mobileEndTime ?? TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                data = data.copyWith(mobileEndTime: value);
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          title: "Mobile Break Start Time",
                          simpleText:
                              data.mobileBreakStartTime?.format(context) ??
                                  "Select Time",
                          onSimpleTextTapped: () {
                            showTimePicker(
                              context: context,
                              initialTime:
                                  data.mobileBreakStartTime ?? TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                data =
                                    data.copyWith(mobileBreakStartTime: value);
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          title: "Mobile Break End Time",
                          simpleText:
                              data.mobileBreakEndTime?.format(context) ??
                                  "Select Time",
                          onSimpleTextTapped: () {
                            showTimePicker(
                              context: context,
                              initialTime:
                                  data.mobileBreakEndTime ?? TimeOfDay.now(),
                            ).then((value) {
                              if (value != null) {
                                data = data.copyWith(mobileBreakEndTime: value);
                              }
                            });
                          },
                        ),
                        UserCardItem(
                          title: "Active",
                          checked: data.active,
                          onChecked: (value) {
                            data = data.copyWith(active: value);
                          },
                        )
                      ],
                    ),

                    //Custom Rates
                  ],
                ),
                SizedBox(
                  width: context.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SpacedRow(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      horizontalSpace: 16.0,
                      children: [
                        for (int i = 0; i < data.customRates.length; i++)
                          UserCard(
                              title: " ",
                              trailing: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  if (data.customRates[i].id == null) {
                                    data.customRates.removeAt(i);
                                    data = data.copyWith();
                                    return;
                                  }
                                  context.futureLoading(() async {
                                    final success = await dispatch<bool>(
                                        DeletePropertySpecialRateAction(
                                            data.id!, data.customRates[i].id!));
                                    if (success.isLeft && success.left) {
                                      data.customRates.removeAt(i);
                                      data = data.copyWith();
                                    } else if (success.isRight) {
                                      context.showError(success.right.message);
                                    } else {
                                      context.showError("Something went wrong");
                                    }
                                  });
                                },
                                label: const Text("Delete"),
                              ),
                              items: [
                                UserCardItem(
                                  title: "Name",
                                  controller: data.customRates[i].name,
                                  isRequired: true,
                                ),
                                UserCardItem(
                                  title: "Rate",
                                  controller: data.customRates[i].rate,
                                  isRequired: true,
                                ),
                                UserCardItem(
                                  title: "Min Work Time (Minutes)",
                                  controller: data.customRates[i].minWorkTime,
                                  isRequired: true,
                                ),
                                UserCardItem(
                                  title: "Paid Time (Minutes)",
                                  controller: data.customRates[i].minPaidTime,
                                  isRequired: true,
                                ),
                                UserCardItem(
                                  title: 'Split Time',
                                  checked: data.customRates[i].splitTime,
                                  onChecked: (value) {
                                    data.customRates[i] =
                                        data.customRates[i].copyWith(
                                      splitTime: value,
                                    );
                                    data = data.copyWith();
                                  },
                                )
                              ]),
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.grey[400]!),
                            borderRadius: BorderRadius.circular(32),
                          ),
                          onPressed: () {
                            data.customRates.add(CustomRate.init());
                            data = data.copyWith();
                          },
                          height: 360,
                          minWidth: 200,
                          child: SpacedColumn(
                            verticalSpace: 8.0,
                            children: const [
                              Icon(Icons.add_circle_outline),
                              Text("Add Rate", style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32.0),
              ],
            ),
          );
        });
  }
}
