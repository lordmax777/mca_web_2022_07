import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/elements/save_button.dart';
import 'package:mca_dashboard/presentation/form/models/form_model.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/data/shift_details.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/new_property_qualification_popup.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/new_property_staff_popup.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/capacity_tab.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/qualification_requirements_tab.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/shift_details_tab.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/shift_details_tab_2.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/staff_requirements_tab.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';
import 'package:pluto_grid/pluto_grid.dart';

class NewPropertyPopup extends StatefulWidget {
  final PropertyMd? model;

  const NewPropertyPopup({super.key, this.model});

  @override
  State<NewPropertyPopup> createState() => _NewPropertyPopupState();
}

class _NewPropertyPopupState extends State<NewPropertyPopup>
    with
        SingleTickerProviderStateMixin,
        TableFocusNodeMixin<NewPropertyPopup, PropertyStaffMd,
            PropertyQualificationMd> {
  late ShiftDetailsData data;

  bool get isCreate => data.isCreate;
  PropertyDetailMd? propertyDetail;

  late final TabController _tabController;
  final List<Tab> tabs = [
    const Tab(text: 'Shift Details'),
    const Tab(text: 'Staff Requirements'),
    const Tab(text: 'Qualification Requirements'),
    const Tab(text: 'Capacity'),
  ];

  @override
  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    data.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    data = ShiftDetailsData.from(widget.model);
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      updateUI();
    });
    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          if (!isCreate) {
            final model = widget.model!;
            shiftDetailsFormVm.formKey.currentState?.patchValue({
              "shiftName": model.title,
              "locationId": model.locationId?.toString(),
              "clientId": model.clientId?.toString(),
              "storageId": model.warehouseId?.toString(),
              "days": (model.days is List
                      ? WeekDaysMd.fromList(model.days)
                      : model.days is Map
                          ? WeekDaysMd.fromMap(model.days)
                          : WeekDaysMd())
                  .asListString,
              "templateId": model.checklistTemplateId?.toString(),
              "active": model.active,
              "checklist": model.checklist,
              "startTime": model.startTime?.timeToDateTime,
              "finishTime": model.finishTime?.timeToDateTime,
              "startBreak": model.startBreak?.timeToDateTime,
              "finishBreak": model.finishBreak?.timeToDateTime,
              "strictBreak": model.strictBreak,
              "fpStartTime": model.fpStartTime?.timeToDateTime,
              "fpFinishTime": model.fpFinishTime?.timeToDateTime,
              "fpStartBreak": model.fpStartBreak?.timeToDateTime,
              "fpFinishBreak": model.fpFinishBreak?.timeToDateTime,
              "minWorkTime": model.minWorkTime?.toString(),
              "minPaidTime": model.minPaidTime?.toString(),
              "splitTime": model.splitTime,
            });
            initFetch();
          }
        }
      },
    );
  }

  final List<SpecialRateMd> specialRates = [];

  void initFetch() {
    context.futureLoading(() async {
      final result = await dispatch<List<SpecialRateMd>>(
          GetPropertySpecialRatesAction(data.id!));
      final result1 =
          await dispatch<PropertyDetailMd>(GetPropertyDetailsAction(data.id!));
      if (result.isLeft) {
        specialRates.addAll(result.left);
        for (int i = 0; i < result.left.length; i++) {
          final rate = result.left[i];
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            // shiftDetailsFormVm.formKey.currentState?.patchValue({
            //   "specialRateId$i": rate.id.toString(),
            //   "specialRateName$i": rate.name,
            //   "specialRateRate$i": rate.rate.toString(),
            //   "specialRateMinWorkTime$i": rate.minWorkTime.toString(),
            //   "specialRateMinPaidTime$i": rate.paidTime.toString(),
            //   "specialRateSplitTime$i": rate.splitTime,
            // });
          });
        }
      } else {
        context.showError(result.right.message);
      }
      if (result1.isLeft) {
        propertyDetail = result1.left;
      }
      updateUI();
    });
  }

  final shiftDetailsFormVm = FormModel();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      contentPadding: const EdgeInsets.all(8),
      content: SizedBox(
        width: context.width,
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              titleSpacing: 0.0,
              title: Text(
                  '${isCreate ? "New" : "Update"} ${appStore.state.generalState.propertyName}'),
              bottom: isCreate
                  ? null
                  : TabBar(
                      controller: _tabController,
                      tabs: tabs,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.grey[500],
                    ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                ShiftDetailsTab2(
                  specialRates: specialRates,
                  isCreate: isCreate,
                  formVm: shiftDetailsFormVm,
                  onSaveCustomRate: (i) async {
                    shiftDetailsFormVm.saveAndValidate();
                    if (!shiftDetailsFormVm.isValid) return;
                    final name = shiftDetailsFormVm.value["specialRateName$i"];
                    final rate = shiftDetailsFormVm.value["specialRateRate$i"];
                    final minWorkTime =
                        shiftDetailsFormVm.value["specialRateMinWorkTime$i"];
                    final minPaidTime =
                        shiftDetailsFormVm.value["specialRateMinPaidTime$i"];
                    final splitTime =
                        shiftDetailsFormVm.value["specialRateSplitTime$i"];
                    final result = await dispatch<int>(
                        PostPropertySpecialRatesAction(data.id,
                            name: name,
                            splitTime: splitTime,
                            minWorkTime: minWorkTime,
                            minPaidTime: minPaidTime,
                            rate: rate));
                    if (result.isRight) {
                      context.showError(result.right.message);
                    } else if (result.isLeft) {
                      specialRates[i] = SpecialRateMd(
                          id: result.left, name: name, splitTime: splitTime);
                      context.showSuccess("Saved");
                      updateUI();
                    }
                  },
                  onRemoveCustomRate: (id) {
                    shiftDetailsFormVm.save();
                    final foundId = specialRates[id].id;
                    if (data.id != null && foundId != 0) {
                      context.futureLoading(() async {
                        final success = await dispatch<bool>(
                            DeletePropertySpecialRateAction(data.id!, foundId));
                        if (success.isRight) {
                          context.showError(success.right.message);
                        } else {
                          specialRates.removeAt(id);
                          updateUI();
                        }
                      });
                    } else {
                      specialRates.removeAt(id);
                      updateUI();
                    }
                  },
                  onAddCustomRate: () {
                    specialRates.add(
                        const SpecialRateMd(id: 0, name: "", splitTime: false));
                    updateUI();
                  },
                ),
                StaffRequirementsTab(
                    onLoaded: onLoaded,
                    onDelete: (p0) =>
                        onDelete(() => deleteSelected(p0), showError: false),
                    onEdit: (p0) {
                      onEdit((p0) => NewPropertyStaffPopup(shiftId: data.id!),
                          null);
                    },
                    rows: stateManager == null ? [] : stateManager!.rows,
                    focusNode: focusNode),
                QualificationRequirementsTab(
                    onLoaded: onLoaded1,
                    onDelete: (p0) =>
                        onDelete1(() => deleteSelected1(p0), showError: false),
                    onEdit: (p0) {
                      onEdit1(
                          (p0) =>
                              NewPropertyQualificationPopup(shiftId: data.id!),
                          null);
                    },
                    rows: stateManager1 == null ? [] : stateManager1!.rows,
                    focusNode: focusNode1),
                if (propertyDetail == null)
                  const SizedBox()
                else
                  CapacityTab(
                    model: propertyDetail!,
                    onSaved: (value) {
                      context.futureLoading(() async {
                        final success =
                            await dispatch<bool>(PostPropertyDetailsAction(
                          shiftId: data.id!,
                          notes: value.notes,
                          bedrooms: value.bedrooms,
                          bathrooms: value.bathrooms,
                          maxSleeps: value.maxSleeps,
                          minSleeps: value.minSleeps,
                        ));
                        if (success.isLeft && success.left) {
                          propertyDetail = value;
                          updateUI();
                        } else if (success.isRight) {
                          context.showError(success.right.message);
                        } else {
                          context.showError("Failed to save capacity");
                        }
                      });
                    },
                  ),
              ],
            )),
      ),
      actions: _tabController.index == 0
          ? [
              ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => onSave(true),
                child: const Text('Save As New'),
              ),
              ElevatedButton(
                onPressed: onSave,
                child: const Text('Save'),
              ),
            ]
          : null,
    );
  }

  void onSave([bool saveAsNew = false]) async {
    shiftDetailsFormVm.saveAndValidate();
    if (!shiftDetailsFormVm.isValid) return;

    context.futureLoading(() async {
      final unavDays = shiftDetailsFormVm.value['days'] ?? [];
      WeekDaysMd days = WeekDaysMd();
      days = days.fromListString(days.asListString
        ..removeWhere((element) => unavDays.contains(element)));

      final success = await dispatch<int?>(PostPropertyAction(
        id: saveAsNew ? null : widget.model?.id,
        title: shiftDetailsFormVm.value['shiftName'],
        locationId: int.parse(shiftDetailsFormVm.value['locationId']),
        clientId: int.parse(shiftDetailsFormVm.value['clientId']),
        storageId: int.parse(shiftDetailsFormVm.value['storageId']),
        templateId: int.parse(shiftDetailsFormVm.value['templateId']),
        active: shiftDetailsFormVm.value['active'],
        checklist: shiftDetailsFormVm.value['checklist'],
        startTime: shiftDetailsFormVm.value['startTime'],
        finishTime: shiftDetailsFormVm.value['finishTime'],
        startBreak: shiftDetailsFormVm.value['startBreak'],
        finishBreak: shiftDetailsFormVm.value['finishBreak'],
        strictBreak: shiftDetailsFormVm.value['strictBreak'],
        fpStartTime: shiftDetailsFormVm.value['fpStartTime'],
        splitTime: shiftDetailsFormVm.value['splitTime'],
        fpFinishTime: shiftDetailsFormVm.value['fpFinishTime'],
        fpStartBreak: shiftDetailsFormVm.value['fpStartBreak'],
        fpFinishBreak: shiftDetailsFormVm.value['fpFinishBreak'],
        minWorkTime: shiftDetailsFormVm.value['minWorkTime'],
        minPaidTime: shiftDetailsFormVm.value['minPaidTime'],
        days: days,
      ));
      if (success.isLeft && success.left != null) {
        final List<String> failedRates = [];
        if (isCreate) {
          final fieldNameKeys = shiftDetailsFormVm.value.keys
              .where((element) => element.startsWith('specialRateName'))
              .toList();
          final fieldRateKeys = shiftDetailsFormVm.value.keys
              .where((element) => element.startsWith('specialRateRate'))
              .toList();
          final fieldMinWorkTimeKeys = shiftDetailsFormVm.value.keys
              .where((element) => element.startsWith('specialRateMinWorkTime'))
              .toList();
          final fieldMinPaidTimeKeys = shiftDetailsFormVm.value.keys
              .where((element) => element.startsWith('specialRateMinPaidTime'))
              .toList();
          final fieldSplitTimeKeys = shiftDetailsFormVm.value.keys
              .where((element) => element.startsWith('specialRateSplitTime'))
              .toList();
          final fieldIdKeys = shiftDetailsFormVm.value.keys
              .where((element) => element.startsWith('specialRateId'))
              .toList();

          for (int i = 0; i < fieldMinPaidTimeKeys.length; i++) {
            final name = shiftDetailsFormVm.value[fieldNameKeys[i]];
            final rate = shiftDetailsFormVm.value[fieldRateKeys[i]];
            final minWorkTime =
                shiftDetailsFormVm.value[fieldMinWorkTimeKeys[i]];
            final minPaidTime =
                shiftDetailsFormVm.value[fieldMinPaidTimeKeys[i]];
            final splitTime = shiftDetailsFormVm.value[fieldSplitTimeKeys[i]];
            final id = shiftDetailsFormVm.value[fieldIdKeys[i]];
            final result = await dispatch<int>(PostPropertySpecialRatesAction(
                success.left!,
                name: name,
                splitTime: splitTime,
                minWorkTime: minWorkTime,
                minPaidTime: minPaidTime,
                rate: rate));
            if (result.isRight) {
              failedRates.add(name);
            }
          }
        }

        if (failedRates.isNotEmpty) {
          context.showError('Failed to save rates: ${failedRates.join(', ')}',
              onClose: () {
            context.pop(true);
          });
        } else {
          context.pop(true);
        }
      } else if (success.isRight) {
        try {
          final data = jsonDecode(success.right.data) as Map;
          if (data.containsKey("errors")) {
            print(data["errors"]);
            if (data["errors"] is Map) {
              for (final error in data["errors"].entries) {
                shiftDetailsFormVm.invalidateField(
                    error.key, error.value.join(", "));
              }
            } else {
              context.showError(data["errors"].join(", "));
            }
          }
        } catch (e) {
          context.showError(success.right.message);
        }
      } else {
        context.showError('Something went wrong');
      }
    });
  }

  @override
  Future<List<PropertyStaffMd>?> fetch() async {
    final success =
        await dispatch<List<PropertyStaffMd>>(GetPropertyStaffAction(data.id!));
    if (success.isLeft) {
      return success.left;
    } else {
      context.showError("Something went wrong");
    }
    return null;
  }

  @override
  PlutoRow buildRow(PropertyStaffMd model) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: model.group),
      "number_of_staff": PlutoCell(value: model.min),
      "max_number_of_staff": PlutoCell(value: model.max),
      "action": PlutoCell(value: model),
    });
  }

  Future<bool> deleteSelected(PlutoRow? singleRow) async {
    final selected = [...stateManager!.checkedRows];
    if (singleRow != null) {
      selected.clear();
      selected.add(singleRow);
    }
    if (selected.isEmpty) {
      return false;
    }
    final List<String> delFailed = [];
    for (final row in selected) {
      final id = row.cells['action']!.value.id;
      final res = await dispatch<bool>(DeletePropertyStaffAction(data.id!, id));
      if (res.isRight) {
        delFailed.add(row.cells['name']!.value + " (${res.right.message})");
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete\n${delFailed.join("\n")}");
    }
    return delFailed.isEmpty;
  }

  @override
  Future<List<PropertyQualificationMd>?> fetch1() async {
    final success = await dispatch<List<PropertyQualificationMd>>(
        GetPropertyQualificationAction(data.id!));
    if (success.isLeft) {
      return success.left;
    } else {
      context.showError("Something went wrong");
    }
    return null;
  }

  @override
  PlutoRow buildRow1(PropertyQualificationMd model) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: model.qualification),
      "min_level": PlutoCell(value: model.level),
      "number_of_staff": PlutoCell(value: model.numberOfStaff),
      "action": PlutoCell(value: model),
    });
  }

  Future<bool> deleteSelected1(PlutoRow? singleRow) async {
    final selected = [...stateManager1!.checkedRows];
    if (singleRow != null) {
      selected.clear();
      selected.add(singleRow);
    }
    if (selected.isEmpty) {
      return false;
    }
    final List<String> delFailed = [];
    for (final row in selected) {
      final id = row.cells['action']!.value.id;
      final res =
          await dispatch<bool>(DeletePropertyQualificationAction(data.id!, id));
      if (res.isRight) {
        delFailed.add(row.cells['name']!.value);
      }
    }
    if (delFailed.isNotEmpty) {
      context.showError("Failed to delete ${delFailed.join(", ")}");
    }
    return delFailed.isEmpty;
  }
}
