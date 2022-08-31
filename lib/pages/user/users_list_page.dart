import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/auth_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/auth_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state.dart';
import 'package:mca_web_2022_07/manager/router/router.gr.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../manager/model_exporter.dart';
import '../../manager/redux/sets/state_value.dart';
import '../../manager/redux/states/general_state.dart';
import '../../theme/theme.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) async {
        await fetch(GetAccessTokenAction(
            domain: Constants.domain,
            username: Constants.username,
            password: Constants.password));
        await fetch(GetAllParamListAction());
        await fetch(GetUsersListAction());
      },
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          PagesTitleWidget(
            title: 'User Management',
            onRightBtnClick: () async {
              appStore.dispatch(UpdateUsersStateAction(
                  isNewUser: true,
                  saveableUserDetails: UserDetailSaveMd(
                      firstName: TextEditingController(),
                      lastName: TextEditingController(),
                      addressLine1: TextEditingController(),
                      addressCity: TextEditingController(),
                      addressPostcode: TextEditingController())));
              context.navigateTo(UserDetailsRoute());
            },
          ),
          ErrorWrapper(errors: [
            state.authState.authRes.error,
            state.usersState.usersList.error,
            state.generalState.paramList.error,
          ], child: _Body(state: state))
        ]),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  AppState state;
  _Body({Key? key, required this.state}) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final GlobalKey _actionsMenuKey = GlobalKey();
  final GlobalKey _columnsMenuKey = GlobalKey();

  final List<UserRes> _users = [];
  final List<ColumnHiderValues> columnHideValues = [];

  late PlutoGridStateManager usersPageStateManger;

  bool _isSmLoaded = false;

  int _pageSize = 10;
  int _page = 1;

  final TextEditingController _searchController = TextEditingController();

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
              mainAxisSize: MainAxisSize.min,
              isSelectable: false,
              onTap: () => _onUserDetailsNavigationClick(ctx),
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
              onTap: () => _onUserDetailsNavigationClick(ctx),
            );
          }),
      PlutoColumn(
          width: 130.0,
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
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "View",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onUserDetailsNavigationClick(ctx, index: 1),
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
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "View",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onUserDetailsNavigationClick(ctx, index: 2),
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
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "View",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onUserDetailsNavigationClick(ctx, index: 3),
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
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "View",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onUserDetailsNavigationClick(ctx, index: 4),
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
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "View",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onUserDetailsNavigationClick(ctx, index: 5),
              icon: const HeroIcon(
                HeroIcons.link,
                color: ThemeColors.blue3,
                size: 12,
              ),
            );
          }),
    ];
  }

  void _setSm(PlutoGridStateManager sm) {
    setState(() {
      usersPageStateManger = sm;
      usersPageStateManger.setPage(0);
      usersPageStateManger.setPageSize(10);
      usersPageStateManger.setPage(_page);
      // usersPageStateManger.sortAscending(_cols.first);
      _setFilter();
      _isSmLoaded = true;
    });
  }

  void _setFilter() {
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        if (usersPageStateManger.page > 1) {
          usersPageStateManger.setPage(1);
        }
        usersPageStateManger.setFilter(
          (element) {
            final String _search = _searchController.text.toLowerCase();
            bool searched = element.cells['name']?.value
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
            if (!searched) {
              searched = element.cells['username']?.value
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
              if (!searched) {
                searched = element.cells['department']?.value
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase());
                if (!searched) {
                  searched = element.cells['main_location']?.value
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());
                }
              }
            }
            return searched;
          },
        );
        return;
      }
      usersPageStateManger.setFilter((element) => true);
    });
  }

  @override
  void initState() {
    super.initState();
    columnHideValues.clear();
    columnHideValues.addAll(_cols
        .skipWhile((value) => value.hide)
        .toList()
        .map<ColumnHiderValues>(
            (e) => ColumnHiderValues(value: e.field, label: e.title))
        .toList());
    _users.clear();
    _users.addAll(widget.state.usersState.usersList.data!);
  }

  void _onUserDetailsNavigationClick(PlutoColumnRendererContext ctx,
      {int index = 0}) {
    appStore.dispatch(UpdateUsersStateAction(
        isNewUser: false, selectedUser: ctx.row.cells['user']?.value));
    context.navigateTo(UserDetailsRoute(tabIndex: index));
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
              controller: _searchController,
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
                  PlutoGridStateManager state = usersPageStateManger;
                  PlutoColumn _c = state.refColumns.originalList
                      .firstWhere((e) => e.field == value.value);
                  state.hideColumn(_c, !value.isChecked);
                }),
          ]),
        ],
      ),
    );
  }

  Widget _body() {
    return UsersListTable(
      onSmReady: _setSm,
      rows: widget.state.usersState.usersList.data!
          .map<PlutoRow>(
            _buildItem,
          )
          .toList(),
      cols: _cols,
    );
  }

  PlutoRow _buildItem(UserRes e) {
    final params = appStore.state.generalState.paramList.data!;
    final String name = "${e.firstName} ${e.lastName}";
    String dep = e.groupId ?? "-";
    for (var el in params.groups) {
      if (dep != "-") {
        if (e.groupAdmin) {
          dep = "Admin";
        }
        if (el.id == int.tryParse(dep)) {
          dep = el.name;
          if (e.groupAdmin) {
            dep = '$dep & Admin';
          }
        }
      }
    }
    String loc = e.locationId ?? "-";
    for (var el in params.locations) {
      if (loc != "-") {
        if (e.locationAdmin) {
          loc = "Admin";
        }
        if (el.id == int.tryParse(loc)) {
          loc = el.name;
          if (e.locationAdmin) {
            loc = '$loc & Admin';
          }
        }
      }
    }

    return PlutoRow(cells: {
      "user": PlutoCell(value: e),
      "name": PlutoCell(value: name),
      "username": PlutoCell(value: e.username),
      "department": PlutoCell(value: dep),
      "main_location": PlutoCell(value: loc),
      "payroll": PlutoCell(value: "-"),
      "reviews": PlutoCell(value: "-"),
      "visa": PlutoCell(value: "-"),
      "absences": PlutoCell(value: "-"),
      "preferred_shifts": PlutoCell(value: "-"),
      "qualifications": PlutoCell(value: "-"),
    });
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
                  // MyWidget(),
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
