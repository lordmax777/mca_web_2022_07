import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/user_pref_shift_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown.dart';
import 'package:mca_dashboard/presentation/global_widgets/spaced_column.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:mca_dashboard/utils/global_functions.dart';

class ShiftPopup extends StatefulWidget {
  final UserPreferredShiftMd? item;
  final UserMd user;

  const ShiftPopup({super.key, this.item, required this.user});

  @override
  State<ShiftPopup> createState() => _ShiftPopupState();
}

class _ShiftPopupState extends State<ShiftPopup> with FormsMixin<ShiftPopup> {
  UserPreferredShiftMd? get item => widget.item;
  UserMd get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text("Add Shift"),
          const Spacer(),
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, vm) {
          final weeks = vm.companyInfo.weeks;
          final shifts =
              [...vm.lists.shifts].where((element) => element.active);
          return Form(
            key: formKey,
            child: SpacedColumn(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              verticalSpace: 32.0,
              children: [
                UserCard(title: "", items: [
                  UserCardItem(
                    title: "Week",
                    isRequired: true,
                    dropdown: UserCardDropdown(
                        valueId: selected1?.id,
                        items: [
                          for (var week in weeks)
                            DefaultMenuItem(
                              id: week,
                              title: week.toString(),
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            selected1 = value;
                          });
                        }),
                  ),
                  UserCardItem(
                    title: "Day",
                    isRequired: true,
                    dropdown: UserCardDropdown(
                        valueId: selected2?.id,
                        items: [
                          for (int i = 1;
                              i <= WeekDaysMd().asMap.entries.length;
                              i++)
                            DefaultMenuItem(
                              id: i,
                              title: WeekDaysMd()
                                  .asMap
                                  .keys
                                  .toList()[i - 1]
                                  .toString()
                                  .toUpperCase(),
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            selected2 = value;
                          });
                        }),
                  ),
                  UserCardItem(
                    title: "Shift",
                    isRequired: true,
                    dropdown: UserCardDropdown(
                        valueId: selected3?.id,
                        items: [
                          for (var shift in shifts)
                            DefaultMenuItem(
                              id: shift.id,
                              title: shift.name.toString(),
                              subtitle: shift.getLocationMd(vm.locations)?.name,
                            )
                        ],
                        onChanged: (value) {
                          setState(() {
                            selected3 = value;
                          });
                        }),
                  ),
                ]),
              ],
            ),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: context.pop,
          child: const Text("Cancel"),
        ),
        TextButton(
            child: const Text("Save"),
            onPressed: () async {
              if (selected1 == null || selected2 == null || selected3 == null) {
                context.showError("Please fill all required fields");
                return;
              }
              if (formKey.currentState!.validate()) {
                context.futureLoading(() async {
                  final created = await dispatch<bool>(PostUserPrefShiftsAction(
                    user.id,
                    weekId: selected1!.id,
                    dayId: selected2!.id == 7 ? 0 : selected2!.id,
                    shiftId: selected3!.id,
                    timingId: item?.id,
                  ));
                  if (created.isLeft) {
                    context.pop(true);
                  } else {
                    DependencyManager.instance.navigation
                        .showFail(created.right.message);
                  }
                });
              }
            }),
      ],
    );
  }
}
