import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/models/form_model.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/data/shift_details.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/new_property_qualification_popup.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/new_property_staff_popup.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/capacity_tab.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/qualification_requirements_tab.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/shift_details_tab.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/shift_details_tab_2.dart';
import 'package:mca_dashboard/presentation/pages/properties_view/tabs/staff_requirements_tab.dart';
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
  final _dependencies = DependencyManager.instance;

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
            initFetch();
          }
        }
      },
    );
  }

  void initFetch() {
    context.futureLoading(() async {
      final result = await dispatch<List<SpecialRateMd>>(
          GetPropertySpecialRatesAction(data.id!));
      final result1 =
          await dispatch<PropertyDetailMd>(GetPropertyDetailsAction(data.id!));
      if (result.isLeft) {
        for (final rate in result.left) {
          data.customRates.add(CustomRate.from(rate));
        }
        updateUI();
      } else {
        context.showError(result.right.message);
      }
      if (result1.isLeft) {
        propertyDetail = result1.left;
        updateUI();
      }
      // else {
      // context.showError(result1.right.message);
      // }
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
                  formVm: shiftDetailsFormVm,
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
                  shiftDetailsFormVm.formKey.currentState?.saveAndValidate();
                  print(shiftDetailsFormVm.formKey.currentState?.value);
                  // context.pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (!data.isValid(context)) return;
                  context.futureLoading(() async {
                    final success =
                        await dispatch<int?>(PostPropertyAction(data));
                    if (success.isLeft && success.left != null) {
                      final List<String> failedRates = [];

                      for (final rate in data.customRates) {
                        final result = await dispatch<bool>(
                            PostPropertySpecialRatesAction(
                                success.left!, rate));
                        if (result.isRight) {
                          failedRates.add(rate.name.text);
                        }
                      }
                      if (failedRates.isNotEmpty) {
                        context.showError(
                            'Failed to save rates: ${failedRates.join(', ')}',
                            onClose: () {
                          context.pop(true);
                        });
                      } else {
                        context.pop(true);
                      }
                    } else if (success.isRight) {
                      context.showError(success.right.message);
                    } else {
                      context.showError('Something went wrong');
                    }
                  });
                },
                child: const Text('Save'),
              ),
            ]
          : null,
    );
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
