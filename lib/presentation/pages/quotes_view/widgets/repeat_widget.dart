import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/global_widgets/spaced_column.dart';

import '../../scheduling_view/data/week_days_m.dart';

class RepeatWidget extends StatelessWidget {
  final String repeatName;
  final String week1Name;
  final String week2Name;
  final ValueChanged<String?>? onDpChanged;
  final FormModel formVm;
  final String? label;
  const RepeatWidget(
      {super.key,
      required this.repeatName,
      required this.week1Name,
      required this.week2Name,
      this.onDpChanged,
      this.label,
      required this.formVm});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<WorkRepeatMd>>(
      converter: (store) => store.state.generalState.lists.workRepeats,
      builder: (context, workRepeats) => SpacedColumn(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 10,
        children: [
          FormWithLabel(
              labelVm: LabelModel(text: label ?? "Repeat Days"),
              formBuilderField: FormDropdown(
                vm: DropdownModel(
                  name: repeatName,
                  onChanged: onDpChanged,
                  items: workRepeats
                      .map((e) => DpItem(id: e.id.toString(), title: e.name))
                      .toList(),
                ),
              )),
          if (formVm.getValue(repeatName) == "3" ||
              formVm.getValue(repeatName) == "4")
            FormWithLabel(
                labelVm: const LabelModel(text: "Week 1", isRequired: true),
                formBuilderField: FormCheckbox(
                  vm: CheckboxModel(
                      name: week1Name,
                      validator: FormBuilderValidators.minLength(1,
                          errorText: "At least 1 day must be available"),
                      items: WeekDaysMd()
                          .asMap
                          .entries
                          .map((e) => DpItem(
                              id: e.key.toString(), title: e.key.toString()))
                          .toList()),
                )),
          if (formVm.getValue(repeatName) == "4")
            FormWithLabel(
                labelVm: const LabelModel(text: "Week 2", isRequired: true),
                formBuilderField: FormCheckbox(
                  vm: CheckboxModel(
                      name: week2Name,
                      //at least 1 day is required
                      validator: FormBuilderValidators.minLength(1,
                          errorText: "At least 1 day must be available"),
                      items: WeekDaysMd()
                          .asMap
                          .entries
                          .map((e) => DpItem(
                              id: e.key.toString(), title: e.key.toString()))
                          .toList()),
                ))
        ],
      ),
    );
  }
}
