import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../comps/modals/custom_date_picker.dart';
import '../../../comps/modals/custom_time_picker.dart';
import '../../../manager/model_exporter.dart';
import '../../../theme/theme.dart';
import '../create_shift_popup.dart';

// Shift details form
class ShiftDetailsForm extends StatefulWidget {
  final AppState state;
  final GlobalKey<FormState> formKey;

  const ShiftDetailsForm(this.state, this.formKey, {Key? key})
      : super(key: key);

  @override
  State<ShiftDetailsForm> createState() => ShiftDetailsFormState();
}

class ShiftDetailsFormState extends State<ShiftDetailsForm> {
  AppState get state => widget.state;

  List<ListClients> get clients =>
      state.generalState.paramList.data?.clients ?? [];
  List<ListLocation> get locations =>
      state.generalState.paramList.data?.locations ?? [];
  List<ListStorage> get warehouses =>
      state.generalState.paramList.data?.storages ?? [];
  List<ListStorageItem> get products =>
      state.generalState.paramList.data?.storage_items ?? [];
  List<ChecklistTemplateMd> get checklistTemplates =>
      state.generalState.checklistTemplates.data ?? [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32,
        children: [
          SpacedRow(
            horizontalSpace: MediaQuery.of(context).size.width * 0.05,
            mainAxisSize: MainAxisSize.min,
            children: [
              labelWithField(
                "Title",
                TextInputWidget(
                  width: 300,
                ),
              ),
              labelWithField(
                "Client",
                DropdownWidgetV2(
                  hasSearchBox: true,
                  dropdownBtnWidth: 300,
                  dropdownOptionsWidth: 300,
                  items: clients.map((e) => e.name),
                  onChanged: (index) {},
                ),
              ),
              labelWithField(
                "Location",
                DropdownWidgetV2(
                  hasSearchBox: true,
                  dropdownBtnWidth: 300,
                  dropdownOptionsWidth: 300,
                  items: locations.map((e) => e.name),
                  onChanged: (index) {},
                ),
              ),
              labelWithField(
                "Active",
                toggle(false, (val) {}),
              ),
            ],
          ),
          SpacedRow(
            horizontalSpace: MediaQuery.of(context).size.width * 0.05,
            mainAxisSize: MainAxisSize.min,
            children: [
              labelWithField(
                "Date",
                TextInputWidget(
                  width: 300,
                  rightIcon: HeroIcons.calendar,
                  isReadOnly: true,
                  hintText: "Select date",
                  onTap: () async {
                    final date = await showCustomDatePicker(context);
                    logger("date: $date");
                  },
                ),
              ),
              labelWithField(
                "All day",
                toggle(false, (val) {}),
              ),
              labelWithField(
                "Start Time",
                TextInputWidget(
                  width: 300,
                  rightIcon: HeroIcons.clock,
                  isReadOnly: true,
                  hintText: "Select start time",
                  onTap: () async {
                    final res = await showCustomTimePicker(context);
                    logger("date: $res");
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
                  onTap: () async {
                    final res = await showCustomTimePicker(context);
                    logger("date: $res");
                  },
                ),
              ),
              labelWithField(
                "Schedule Later",
                radio(false, (val) {}),
              ),
              labelWithField(
                "Repeat",
                radio(false, (val) {}),
              ),
            ],
          ),
          SpacedRow(
            horizontalSpace: MediaQuery.of(context).size.width * 0.05,
            mainAxisSize: MainAxisSize.min,
            children: [
              labelWithField(
                "Warehouse",
                DropdownWidgetV2(
                  hasSearchBox: true,
                  dropdownBtnWidth: 300,
                  dropdownOptionsWidth: 300,
                  items: warehouses.map((e) => e.name),
                  onChanged: (index) {},
                ),
              ),
              labelWithField(
                "Checklist Template",
                DropdownWidgetV2(
                  hasSearchBox: true,
                  dropdownBtnWidth: 300,
                  dropdownOptionsWidth: 300,
                  items: checklistTemplates.map((e) => e.name),
                  onChanged: (index) {},
                ),
              ),
              labelWithField(
                "Paid Hours",
                TextInputWidget(
                  width: 300,
                  hintText: "0.00",
                  rightIcon: HeroIcons.dollar,
                  keyboardType: TextInputType.number,
                ),
              ),
              labelWithField(
                "Split Time",
                toggle(false, (val) {}),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
