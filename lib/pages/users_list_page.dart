import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/show_overlay_popup.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../theme/theme.dart';

List<PlutoColumn> get _cols {
  return [
    PlutoColumn(
        title: "Name",
        field: "name",
        width: 170.0,
        type: PlutoColumnType.text(),
        renderer: (ctx) {
          return KText(
            text: ctx.cell.value,
            textColor: ThemeColors.blue3,
            fontWeight: FWeight.regular,
            fontSize: 14,
            isSelectable: false,
            onTap: () {
              print(ctx.cell.value);
            },
          );
        }),
    PlutoColumn(
        width: 110.0,
        title: "Username",
        field: "username",
        type: PlutoColumnType.text(),
        renderer: (ctx) {
          return KText(
            text: ctx.cell.value,
            textColor: ThemeColors.blue3,
            fontWeight: FWeight.regular,
            fontSize: 14,
            isSelectable: false,
            onTap: () {
              print(ctx.cell.value);
            },
          );
        }),
    PlutoColumn(
        width: 113.0,
        title: "Department",
        field: "department",
        type: PlutoColumnType.text()),
    PlutoColumn(
        width: 266.0,
        title: "Main Location",
        field: "main_location",
        type: PlutoColumnType.text()),
    PlutoColumn(
        width: 85.0,
        title: "Payroll",
        field: "payroll",
        type: PlutoColumnType.text(),
        renderer: (ctx) {
          return KText(
            text: "View",
            textColor: ThemeColors.blue3,
            fontWeight: FWeight.regular,
            fontSize: 14,
            isSelectable: false,
            onTap: () {
              print(ctx.cell.value);
            },
            icon: const HeroIcon(
              HeroIcons.link,
              color: ThemeColors.blue3,
              size: 12,
            ),
          );
        }),
    PlutoColumn(
        width: 85.0,
        title: "Reviews",
        field: "reviews",
        type: PlutoColumnType.text(),
        renderer: (ctx) {
          return KText(
            text: "View",
            textColor: ThemeColors.blue3,
            fontWeight: FWeight.regular,
            fontSize: 14,
            isSelectable: false,
            onTap: () {
              print(ctx.cell.value);
            },
            icon: const HeroIcon(
              HeroIcons.link,
              color: ThemeColors.blue3,
              size: 12,
            ),
          );
        }),
    PlutoColumn(
        width: 85.0,
        title: "Visa",
        field: "visa",
        type: PlutoColumnType.text(),
        renderer: (ctx) {
          return KText(
            text: "View",
            textColor: ThemeColors.blue3,
            fontWeight: FWeight.regular,
            fontSize: 14,
            isSelectable: false,
            onTap: () {
              print(ctx.cell.value);
            },
            icon: const HeroIcon(
              HeroIcons.link,
              color: ThemeColors.blue3,
              size: 12,
            ),
          );
        }),
    PlutoColumn(
        width: 266.0,
        title: "Absences",
        field: "absences",
        type: PlutoColumnType.text()),
    PlutoColumn(
        width: 133.0,
        title: "Preferred Shifts",
        field: "preferred_shifts",
        type: PlutoColumnType.text(),
        renderer: (ctx) {
          return KText(
            text: "View",
            textColor: ThemeColors.blue3,
            fontWeight: FWeight.regular,
            fontSize: 14,
            isSelectable: false,
            onTap: () {
              print(ctx.cell.value);
            },
            icon: const HeroIcon(
              HeroIcons.link,
              color: ThemeColors.blue3,
              size: 12,
            ),
          );
        }),
    PlutoColumn(
        width: 133.0,
        title: "Qualifications",
        field: "qualifications",
        type: PlutoColumnType.text(),
        renderer: (ctx) {
          return KText(
            text: "View",
            textColor: ThemeColors.blue3,
            fontWeight: FWeight.regular,
            fontSize: 14,
            isSelectable: false,
            onTap: () {
              print(ctx.cell.value);
            },
            icon: const HeroIcon(
              HeroIcons.link,
              color: ThemeColors.blue3,
              size: 12,
            ),
          );
        }),
  ];
}

final ValueNotifier<PlutoGridStateManager?> usersPageStateManger =
    ValueNotifier(null);

class UsersListPage extends StatelessWidget {
  const UsersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onDispose: (_) => usersPageStateManger.dispose(),
      builder: (_, state) => SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: SpacedColumn(verticalSpace: 16.0, children: [
            PagesTitleWidget(
              title: 'User Management',
              onRightBtnClick: () {},
            ),
            _Body(),
          ]),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  _Body({Key? key}) : super(key: key);

  final GlobalKey _actionsMenuKey = GlobalKey();
  final GlobalKey _columnsMenuKey = GlobalKey();

  final List<ColumnHiderValues> columnHideValues = _cols
      .map<ColumnHiderValues>(
          (e) => ColumnHiderValues(value: e.field, label: e.title))
      .toList();

  @override
  Widget build(BuildContext context) {
    return TableWrapperWidget(
        child: SizedBox(
      width: double.infinity,
      // height: 794,
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          ValueListenableBuilder(
              valueListenable: usersPageStateManger,
              builder: (_, PlutoGridStateManager? sm, __) {
                return _body();
              }),
          const Divider(
            color: ThemeColors.gray11,
            thickness: 1.0,
          ),
          _footer(),
        ],
      ),
    ));
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInputWidget(
              defaultBorderColor: ThemeColors.gray11,
              width: 360,
              leftIcon: HeroIcons.search),
          SpacedRow(horizontalSpace: 16.0, children: [
            PopupMenuButton(
              key: _actionsMenuKey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              tooltip: "Show Actions",
              itemBuilder: (_) {
                return const [
                  PopupMenuItem(value: 'import', child: Text('Import File')),
                  PopupMenuItem(value: 'export', child: Text('Export File')),
                  PopupMenuItem(
                      value: 'import_employees',
                      child: Text('Import Employees')),
                ];
              },
              onSelected: (value) {
                print(value);
              },
              child: ButtonMediumSecondary(
                  leftIcon: const HeroIcon(
                    HeroIcons.downSmall,
                    size: 20,
                    color: ThemeColors.gray2,
                  ),
                  text: "Actions",
                  onPressed: () {
                    dynamic state = _actionsMenuKey.currentState;
                    state.showButtonMenu();
                  }),
            ),
            TableColumnHiderWidget(
                gKey: _columnsMenuKey,
                columns: columnHideValues,
                onChanged: (value) {
                  print(value.isChecked);
                  if (usersPageStateManger.value != null) {
                    PlutoGridStateManager state = usersPageStateManger.value!;
                    PlutoColumn _c = state.refColumns.originalList
                        .firstWhere((e) => e.field == value.value);
                    state.hideColumn(_c, !value.isChecked);
                  }
                }),
          ]),
        ],
      ),
    );
  }

  Widget _body() {
    return UsersListTable(
      rows: [
        PlutoRow(cells: {
          "name": PlutoCell(
            value: "Bianca",
          ),
          "username": PlutoCell(
            value: "30000",
          ),
          "department": PlutoCell(
            value: "Managers",
          ),
          "main_location": PlutoCell(
            value: "18-20 Laystall Street EC1 R4PG",
          ),
          "payroll": PlutoCell(
            value: "Dummy Payroll",
          ),
          "reviews": PlutoCell(
            value: "Dummy Reviews",
          ),
          "visa": PlutoCell(
            value: "Dummy Visa",
          ),
          "absences": PlutoCell(
            value: "Dummy Absences",
          ),
          "preferred_shifts": PlutoCell(
            value: "Dummy Preferred Shifts",
          ),
          "qualifications": PlutoCell(
            value: "Dummy Qualifications",
          ),
        }),
        PlutoRow(cells: {
          "name": PlutoCell(
            value: "Bianca",
          ),
          "username": PlutoCell(
            value: "30000",
          ),
          "department": PlutoCell(
            value: "Managers",
          ),
          "main_location": PlutoCell(
            value: "18-20 Laystall Street EC1 R4PG",
          ),
          "payroll": PlutoCell(
            value: "Dummy Payroll",
          ),
          "reviews": PlutoCell(
            value: "Dummy Reviews",
          ),
          "visa": PlutoCell(
            value: "Dummy Visa",
          ),
          "absences": PlutoCell(
            value: "Dummy Absences",
          ),
          "preferred_shifts": PlutoCell(
            value: "Dummy Preferred Shifts",
          ),
          "qualifications": PlutoCell(
            value: "Dummy Qualifications",
          ),
        }),
        PlutoRow(cells: {
          "name": PlutoCell(
            value: "Bianca",
          ),
          "username": PlutoCell(
            value: "30000",
          ),
          "department": PlutoCell(
            value: "Managers",
          ),
          "main_location": PlutoCell(
            value: "18-20 Laystall Street EC1 R4PG",
          ),
          "payroll": PlutoCell(
            value: "Dummy Payroll",
          ),
          "reviews": PlutoCell(
            value: "Dummy Reviews",
          ),
          "visa": PlutoCell(
            value: "Dummy Visa",
          ),
          "absences": PlutoCell(
            value: "Annual Holiday Entitlement: None",
          ),
          "preferred_shifts": PlutoCell(
            value: "Dummy Preferred Shifts",
          ),
          "qualifications": PlutoCell(
            value: "Dummy Qualifications",
          ),
        }),
        PlutoRow(cells: {
          "name": PlutoCell(
            value: "Bianca",
          ),
          "username": PlutoCell(
            value: "30000",
          ),
          "department": PlutoCell(
            value: "Managers",
          ),
          "main_location": PlutoCell(
            value: "18-20 Laystall Street EC1 R4PG",
          ),
          "payroll": PlutoCell(
            value: "Dummy Payroll",
          ),
          "reviews": PlutoCell(
            value: "Dummy Reviews",
          ),
          "visa": PlutoCell(
            value: "Dummy Visa",
          ),
          "absences": PlutoCell(
            value: "Annual Holiday Entitlement: None",
          ),
          "preferred_shifts": PlutoCell(
            value: "Dummy Preferred Shifts",
          ),
          "qualifications": PlutoCell(
            value: "Dummy Qualifications",
          ),
        }),
        PlutoRow(cells: {
          "name": PlutoCell(
            value: "Bianca",
          ),
          "username": PlutoCell(
            value: "30000",
          ),
          "department": PlutoCell(
            value: "Managers",
          ),
          "main_location": PlutoCell(
            value: "18-20 Laystall Street EC1 R4PG",
          ),
          "payroll": PlutoCell(
            value: "Dummy Payroll",
          ),
          "reviews": PlutoCell(
            value: "Dummy Reviews",
          ),
          "visa": PlutoCell(
            value: "Dummy Visa",
          ),
          "absences": PlutoCell(
            value: "Annual Holiday Entitlement: None",
          ),
          "preferred_shifts": PlutoCell(
            value: "Dummy Preferred Shifts",
          ),
          "qualifications": PlutoCell(
            value: "Dummy Qualifications",
          ),
        }),
        PlutoRow(cells: {
          "name": PlutoCell(
            value: "Bianca",
          ),
          "username": PlutoCell(
            value: "30000",
          ),
          "department": PlutoCell(
            value: "Managers",
          ),
          "main_location": PlutoCell(
            value: "18-20 Laystall Street EC1 R4PG",
          ),
          "payroll": PlutoCell(
            value: "Dummy Payroll",
          ),
          "reviews": PlutoCell(
            value: "Dummy Reviews",
          ),
          "visa": PlutoCell(
            value: "Dummy Visa",
          ),
          "absences": PlutoCell(
            value: "Annual Holiday Entitlement: None",
          ),
          "preferred_shifts": PlutoCell(
            value: "Dummy Preferred Shifts",
          ),
          "qualifications": PlutoCell(
            value: "Dummy Qualifications",
          ),
        }),
        PlutoRow(cells: {
          "name": PlutoCell(
            value: "Bianca",
          ),
          "username": PlutoCell(
            value: "30000",
          ),
          "department": PlutoCell(
            value: "Managers",
          ),
          "main_location": PlutoCell(
            value: "18-20 Laystall Street EC1 R4PG",
          ),
          "payroll": PlutoCell(
            value: "Dummy Payroll",
          ),
          "reviews": PlutoCell(
            value: "Dummy Reviews",
          ),
          "visa": PlutoCell(
            value: "Dummy Visa",
          ),
          "absences": PlutoCell(
            value: "Dummy Absences",
          ),
          "preferred_shifts": PlutoCell(
            value: "Dummy Preferred Shifts",
          ),
          "qualifications": PlutoCell(
            value: "Dummy Qualifications",
          ),
        }),
      ],
      cols: _cols,
    );
  }

  Widget _footer() {
    return Container(
      // color: Colors.redAccent[100],
      padding: const EdgeInsets.only(
          left: 16.0, right: 32.0, top: 16.0, bottom: 16.0),
      child: SpacedRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedRow(
                horizontalSpace: 8.0,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KText(
                      text: "Showing",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                  DropdownWidget(
                    hintText: "Entries",
                    items: const ["1", "2", "10"],
                    dropdownBtnWidth: 120,
                    onChanged: (_) {},
                    value: "10",
                  ),
                  KText(
                      text: "of 200 entries",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                ]),
            TablePaginationWidget(totalPages: 7, onPageChanged: (int i) {}),
          ]),
    );
  }
}
