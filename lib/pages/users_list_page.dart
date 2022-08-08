import 'package:flutter/scheduler.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/auth_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state.dart';
import 'package:mca_web_2022_07/manager/router/router.gr.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../app.dart';
import '../manager/models/model_exporter.dart';
import '../theme/theme.dart';

List<PlutoColumn> get _cols {
  return [
    PlutoColumn(
      title: "user",
      field: "user",
      type: PlutoColumnType.text(),
      hide: true,
    ),
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
              appRouter.navigate(UserDetailsRoute());
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
              appRouter.navigate(UserDetailsRoute());
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

class UsersListPage extends StatelessWidget {
  const UsersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) async {
        await appStore.dispatch(GetAccessTokenAction(
            domain: Constants.domain,
            username: Constants.username,
            password: Constants.password));
        await appStore.dispatch(GetUsersListAction());
        // usersPageStateManger.addListener(() {
        //   if (usersPageStateManger.value != null) {
        //     usersPageStateManger.value!.setPage(1);
        //     usersPageStateManger.value!.setPageSize(10);
        //   }
        // });
      },
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          PagesTitleWidget(
            title: 'User Management',
            onRightBtnClick: () {},
          ),
          if (state.usersState.usersList.isNotEmpty)
            _Body(state: state)
          else
            const CircularProgressIndicator()
        ]),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  AppState state;
  int _itemCount = 0;
  _Body({Key? key, required this.state}) : super(key: key) {
    _itemCount = state.usersState.usersList.length;
  }

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final GlobalKey _actionsMenuKey = GlobalKey();
  final GlobalKey _columnsMenuKey = GlobalKey();

  final List<UserRes> _users = [];

  final List<ColumnHiderValues> columnHideValues = _cols
      .skipWhile((value) => value.hide)
      .toList()
      .map<ColumnHiderValues>(
          (e) => ColumnHiderValues(value: e.field, label: e.title))
      .toList();

  late PlutoGridStateManager usersPageStateManger;
  bool _isSmLoaded = false;

  int _pageSize = 10;
  int _page = 1;

  void _setSm(PlutoGridStateManager sm) {
    setState(() {
      usersPageStateManger = sm;
      usersPageStateManger.setPage(2);
      usersPageStateManger.setPageSize(10);
      usersPageStateManger.setPage(_page);
      _isSmLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _users.clear();
    _users.addAll(widget.state.usersState.usersList);
  }

  @override
  Widget build(BuildContext context) {
    return TableWrapperWidget(
        child: SizedBox(
      width: double.infinity,
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          _body(),
          const Divider(
            color: ThemeColors.gray11,
            thickness: 1.0,
          ),
          if (_isSmLoaded) _footer(usersPageStateManger),
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
              offset: const Offset(0.0, 50.0),
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
                  if (usersPageStateManger != null) {
                    PlutoGridStateManager state = usersPageStateManger;
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
      onSmReady: _setSm,
      footer: _footer,
      rows: widget.state.usersState.usersList
          .map<PlutoRow>(
            (e) => PlutoRow(cells: {
              "user": PlutoCell(value: e),
              "name": PlutoCell(value: "${e.firstName} ${e.lastName}"),
              "username": PlutoCell(value: e.username),
              "department": PlutoCell(value: e.groupId ?? "-"),
              "main_location": PlutoCell(value: e.locationId ?? "-"),
              "payroll": PlutoCell(value: "-"),
              "reviews": PlutoCell(value: "-"),
              "visa": PlutoCell(value: "-"),
              "absences": PlutoCell(value: "-"),
              "preferred_shifts": PlutoCell(value: "-"),
              "qualifications": PlutoCell(value: "-"),
            }),
          )
          .toList(),
      cols: _cols,
    );
  }

  Widget _footer(PlutoGridStateManager stateManager) {
    return Padding(
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
                    items: Constants.tablePageSizes
                        .map<String>((e) => e.toString())
                        .toList(),
                    dropdownBtnWidth: 120,
                    onChanged: (value) =>
                        _onPageSizeChange(value, stateManager),
                    //TODO: if _pageSize is less than the last item of tablePageSizes, show that item instead of last item!
                    value: _pageSize.toString(),
                  ),
                  KText(
                      text: "of ${_users.length} entries",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                ]),
            TablePaginationWidget(
                currentPage: _page,
                totalPages: stateManager
                    .totalPage, //(widget._itemCount / _pageSize).ceil(),
                onPageChanged: (int i) => _onPageChange(i, stateManager)),
          ]),
    );
  }

  void _onPageSizeChange(pageS, PlutoGridStateManager stateManager) {
    _pageSize = int.parse(pageS);
    stateManager.setPageSize(_pageSize);
    usersPageStateManger.setPage(1);
    _page = 1;
    setState(() {});
  }

  void _onPageChange(int page, PlutoGridStateManager stateManager) {
    _page = page;
    stateManager.setPage(_page);
    setState(() {});
  }
}
