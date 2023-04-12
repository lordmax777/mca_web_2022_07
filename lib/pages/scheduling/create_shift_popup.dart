import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/modals/custom_date_picker.dart';
import 'package:mca_web_2022_07/comps/modals/custom_time_picker.dart';
import 'package:mca_web_2022_07/manager/models/list_all_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../theme/theme.dart';
import '../../manager/model_exporter.dart';

Future<T?> showCreateShiftPopup<T>(BuildContext context, String type) {
  return showDialog<T>(
    context: context,
    builder: (_) {
      switch (type) {
        case "shift":
          return const _CreateShiftPopup();
        default:
          return const _CreateShiftPopup();
      }
    },
  );
}

Future<bool> _onWillPop(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text('Are you sure you want to discard changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}

class _CreateShiftPopup extends StatefulWidget {
  const _CreateShiftPopup({Key? key}) : super(key: key);

  @override
  State<_CreateShiftPopup> createState() => _CreateShiftPopupState();
}

class _CreateShiftPopupState extends State<_CreateShiftPopup>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<Tab> _tabs = const [
    Tab(text: "Shift details"),
    Tab(text: "Staff & Timing"),
    Tab(text: "Site details"),
  ];

  final _shiftDetailsFormKey = GlobalKey<FormState>();
  final _staffTimingFormKey = GlobalKey<FormState>();
  final _siteDetailsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) => AlertDialog(
          contentPadding: const EdgeInsets.all(36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create Shift',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  IconButton(
                    onPressed: () {
                      _onWillPop(context).then((value) {
                        if (value) {
                          Navigator.of(context).pop();
                        }
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              TabBar(
                controller: _tabController,
                tabs: _tabs,
                labelColor: ThemeColors.MAIN_COLOR,
                unselectedLabelColor: ThemeColors.gray7,
                indicatorColor: ThemeColors.MAIN_COLOR,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: Theme.of(context).textTheme.headlineSmall,
              ),
              const Divider(
                thickness: 1,
                height: 1,
                color: ThemeColors.gray10,
              ),
            ],
          ),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        _ShiftDetailsForm(state, _shiftDetailsFormKey),
                        _StaffAndTimingForm(state, _staffTimingFormKey),
                        const Center(child: Text('Site details')),
                      ],
                    ),
                  ),
                ],
              )),
          actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
          actions: [
            ButtonLarge(
                text: 'Cancel',
                onPressed: () {
                  _onWillPop(context).then((value) {
                    if (value) {
                      Navigator.of(context).pop();
                    }
                  });
                }),
            ButtonLarge(text: 'Create/Save', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

Widget _labelWithField(String label, Widget child) {
  return SpacedColumn(
    verticalSpace: 0,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: ThemeText.md1,
      ),
      child
    ],
  );
}

Widget _toggle(bool value, Function(bool) onToggle) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: ToggleCheckboxWidget(
        value: value,
        width: 64.0,
        height: 32.0,
        toggleSize: 26.0,
        padding: 1.0,
        inactiveColor: ThemeColors.gray11,
        onToggle: onToggle),
  );
}

// Shift details form
class _ShiftDetailsForm extends StatefulWidget {
  final AppState state;
  final GlobalKey<FormState> formKey;

  const _ShiftDetailsForm(this.state, this.formKey, {Key? key})
      : super(key: key);

  @override
  State<_ShiftDetailsForm> createState() => _ShiftDetailsFormState();
}

class _ShiftDetailsFormState extends State<_ShiftDetailsForm> {
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
      child: SpacedRow(
        // mainAxisAlignment: MainAxisAlignment.center,
        horizontalSpace: MediaQuery.of(context).size.width * 0.05,
        children: [
          SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalSpace: MediaQuery.of(context).size.height * 0.05,
            children: [
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * 0.05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Title",
                    TextInputWidget(
                      width: 300,
                    ),
                  ),
                  _labelWithField(
                    "Client",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: clients.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * 0.05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
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
                  _labelWithField(
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
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * 0.05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Location",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: locations.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  _labelWithField(
                    "Schedule Later",
                    _toggle(false, (val) {}),
                  ),
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * 0.05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
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
                  _labelWithField(
                    "All day",
                    _toggle(false, (val) {}),
                  ),
                ],
              ),
            ],
          ),
          SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalSpace: MediaQuery.of(context).size.height * 0.05,
            children: [
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * .05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Warehouse",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: warehouses.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  _labelWithField(
                    "Repeat",
                    _toggle(false, (val) {}),
                  ),
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * .05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Products and Services",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: products.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  _labelWithField(
                    "Split Time",
                    _toggle(false, (val) {}),
                  ),
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * .05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Checklist Template",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: checklistTemplates.map((e) => e.name),
                      onChanged: (index) {},
                    ),
                  ),
                  _labelWithField(
                    "Split Time",
                    _toggle(false, (val) {}),
                  ),
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * .05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Paid Hours",
                    TextInputWidget(
                      width: 300,
                      hintText: "0.00",
                      rightIcon: HeroIcons.dollar,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  _labelWithField(
                    "Active",
                    _toggle(false, (val) {}),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Staff & Timing Form
class _StaffAndTimingForm extends StatefulWidget {
  final AppState appState;
  final GlobalKey<FormState> formKey;

  const _StaffAndTimingForm(this.appState, this.formKey, {Key? key})
      : super(key: key);

  @override
  State<_StaffAndTimingForm> createState() => _StaffAndTimingFormState();
}

class _StaffAndTimingFormState extends State<_StaffAndTimingForm> {
  AppState get state => widget.appState;

  List<ListGroup> get departments =>
      state.generalState.paramList.data?.groups ?? [];
  List<ListQualification> get qualifications =>
      state.generalState.paramList.data?.qualifications ?? [];
  List<ListQualificationLevel> get qualificationLevels =>
      state.generalState.paramList.data?.qualification_levels ?? [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SpacedRow(
        horizontalSpace: MediaQuery.of(context).size.width * 0.05,
        children: [
          SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalSpace: MediaQuery.of(context).size.height * 0.05,
            children: [
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * 0.05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Start Break Time",
                    TextInputWidget(
                      width: 300,
                      rightIcon: HeroIcons.clock,
                      isReadOnly: true,
                      hintText: "Select time",
                      onTap: () async {
                        final res = await showCustomTimePicker(context);
                        logger("date: $res");
                      },
                    ),
                  ),
                  _labelWithField(
                    "End Break Time",
                    TextInputWidget(
                      width: 300,
                      rightIcon: HeroIcons.clock,
                      isReadOnly: true,
                      hintText: "Select time",
                      onTap: () async {
                        final res = await showCustomTimePicker(context);
                        logger("date: $res");
                      },
                    ),
                  ),
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * 0.05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Strict Break Time",
                    TextInputWidget(
                      width: 300,
                      rightIcon: HeroIcons.clock,
                      isReadOnly: true,
                      hintText: "Select time",
                      onTap: () async {
                        final res = await showCustomTimePicker(context);
                        logger("date: $res");
                      },
                    ),
                  ),
                  _labelWithField(
                    "Earliest Start Time",
                    TextInputWidget(
                      width: 300,
                      rightIcon: HeroIcons.clock,
                      isReadOnly: true,
                      hintText: "Select time",
                      onTap: () async {
                        final res = await showCustomTimePicker(context);
                        logger("date: $res");
                      },
                    ),
                  ),
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * 0.05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Auto Logout Finish Time",
                    TextInputWidget(
                      width: 300,
                      rightIcon: HeroIcons.clock,
                      isReadOnly: true,
                      hintText: "Select time",
                      onTap: () async {
                        final res = await showCustomTimePicker(context);
                        logger("date: $res");
                      },
                    ),
                  ),
                  _labelWithField(
                    "Break Not Available After",
                    TextInputWidget(
                      width: 300,
                      rightIcon: HeroIcons.clock,
                      isReadOnly: true,
                      hintText: "Select time",
                      onTap: () async {
                        final res = await showCustomTimePicker(context);
                        logger("date: $res");
                      },
                    ),
                  ),
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * 0.05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Special Rate",
                    TextInputWidget(
                      width: 300,
                      rightIcon: HeroIcons.pound,
                      hintText: "Enter Amount",
                    ),
                  ),
                  _labelWithField(
                    "Department",
                    DropdownWidgetV2(
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: departments.map((e) => e.name),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ],
          ),
          SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalSpace: MediaQuery.of(context).size.height * 0.05,
            children: [
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * .05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Number of Staff",
                    TextInputWidget(
                      width: 300,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  _labelWithField(
                    "Maximum Staff",
                    TextInputWidget(
                      width: 300,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SpacedRow(
                horizontalSpace: MediaQuery.of(context).size.width * .05,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _labelWithField(
                    "Qualification",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: qualifications.map((e) => e.title),
                      onChanged: (index) {},
                    ),
                  ),
                  _labelWithField(
                    "Min Level",
                    DropdownWidgetV2(
                      hasSearchBox: true,
                      dropdownBtnWidth: 300,
                      dropdownOptionsWidth: 300,
                      items: qualificationLevels.map((e) => e.level),
                      onChanged: (index) {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
