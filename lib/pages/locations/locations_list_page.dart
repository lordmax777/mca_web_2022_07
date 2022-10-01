import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../theme/theme.dart';
import 'package:faker/faker.dart';

class LocationsListPage extends StatelessWidget {
  const LocationsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          PagesTitleWidget(
            btnText: "New Location",
            title: 'Locations',
            onRightBtnClick: () async {
              // context.navigateTo(UserDetailsRoute());
            },
          ),
          ErrorWrapper(errors: [], child: _Body(state: state))
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
  final GlobalKey _columnsMenuKey = GlobalKey();

  final List<Map> items = [];
  final List<ColumnHiderValues> columnHideValues = [];

  late PlutoGridStateManager usersPageStateManger;

  bool _isSmLoaded = false;

  int _pageSize = 10;
  int _page = 1;

  final TextEditingController _searchController = TextEditingController();

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
        title: "location",
        field: "location",
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
        width: 300.0,
        title: "Location Name",
        field: "location_name",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          width: 360.0,
          title: "Address",
          field: "address",
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
          width: 300.0,
          title: "Contact",
          field: "contact",
          type: PlutoColumnType.text()),
      PlutoColumn(
        width: 250.0,
        title: "Required Staff",
        field: "required_staff",
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return UsersListTable.defaultTextWidget(
              "Cleaners: ${rendererContext.cell.value}");
        },
      ),
      PlutoColumn(
        width: 250.0,
        title: "IP Address",
        field: "ip_address",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        // width: 85.0,
        title: "Status",
        field: "status",
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          final Color color = rendererContext.cell.value == "active"
              ? ThemeColors.green2
              : ThemeColors.gray8;
          return SpacedRow(
              horizontalSpace: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                UsersListTable.defaultTextWidget(rendererContext.cell.value
                    .toString()
                    .replaceFirst(rendererContext.cell.value.toString()[0],
                        rendererContext.cell.value.toString()[0].toUpperCase()))
              ]);
        },
      ),
      PlutoColumn(
          title: "Action",
          field: "action",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "Edit",
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onUserDetailsNavigationClick(ctx),
              icon: const HeroIcon(
                HeroIcons.edit,
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
            final String search = _searchController.text.toLowerCase();
            bool searched = element.cells['location_name']?.value
                .toLowerCase()
                .contains(search);
            if (!searched) {
              searched = element.cells['address']?.value
                  .toLowerCase()
                  .contains(search);
              if (!searched) {
                searched = element.cells['contact']?.value
                    .toLowerCase()
                    .contains(search);
                if (!searched) {
                  searched = element.cells['ip_address']?.value
                      .toLowerCase()
                      .contains(search);
                  if (!searched) {
                    searched = element.cells['status']?.value
                        .toLowerCase()
                        .contains(search);
                    if (!searched) {
                      searched = element.cells['required_staff']?.value
                          .toLowerCase()
                          .contains(search);
                    }
                  }
                }
              }
            }
            return searched;
          },
        );
        _onPageChange(usersPageStateManger.page, usersPageStateManger);
        _onPageSizeChange(
            usersPageStateManger.pageSize.toString(), usersPageStateManger);
        return;
      }

      usersPageStateManger.setFilter((element) => true);
      _onPageChange(usersPageStateManger.page, usersPageStateManger);
      _onPageSizeChange(
          usersPageStateManger.pageSize.toString(), usersPageStateManger);
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 20; i++) {
      final Map map = {
        "location_name": faker.address.streetName(),
        "address": faker.address.streetAddress(),
        "contact": faker.internet.email(),
        "required_staff": faker.randomGenerator.integer(30),
        "ip_address": faker.internet.ipv4Address(),
        "status": faker.randomGenerator.boolean() ? "active" : "inactive",
      };
      items.add(map);
    }
    columnHideValues.clear();
    columnHideValues.addAll(_cols
        .skipWhile((value) => value.hide)
        .toList()
        .map<ColumnHiderValues>(
            (e) => ColumnHiderValues(value: e.field, label: e.title))
        .toList());
  }

  void _onUserDetailsNavigationClick(PlutoColumnRendererContext ctx,
      {int index = 0}) async {
    // appStore.dispatch(UpdateSavedUserStateAction(isInit: true));
    // appStore.dispatch(UpdateUsersStateAction(
    //     // saveableUserDetails: UserDetailSaveMd.init(),
    //     isNewUser: false,
    //     selectedUser: ctx.row.cells['user']?.value));
    // context.navigateTo(UserDetailsRoute(tabIndex: index));
  }

  void _onUserDetailsNavigationClickTest(PlutoColumnRendererContext ctx,
      {int index = 0}) async {
    // for (var i = 0; i < appStore.state.usersState.usersList.data!.length; i++) {
    //   //
    //   appStore.dispatch(UpdateSavedUserStateAction(isInit: true));
    //   appStore.dispatch(UpdateUsersStateAction(
    //       // saveableUserDetails: UserDetailSaveMd.init(),
    //       isNewUser: false,
    //       selectedUser: appStore.state.usersState.usersList.data![i]));
    //   await Future.wait([
    //     fetch(GetUserDetailsDetailAction()),
    //     fetch(GetUserDetailsPhotosAction()),
    //     fetch(GetUserDetailsContractsAction()),
    //     fetch(GetUserDetailsReviewsAction()),
    //     fetch(GetUserDetailsVisasAction()),
    //     fetch(GetUserDetailsPreferredShiftsAction()),
    //     fetch(GetUserDetailsQualifsAction()),
    //     fetch(GetUserDetailsStatusAction()),
    //     fetch(GetUserDetailsMobileAction()),
    //   ]);
    // }
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
              hintText: 'Search locations...',
              defaultBorderColor: ThemeColors.gray11,
              width: 360,
              leftIcon: HeroIcons.search),
          SpacedRow(horizontalSpace: 16.0, children: [
            ButtonMedium(
              bgColor: ThemeColors.red3.withOpacity(0.5),
              text: "Delete Selected",
              icon: const HeroIcon(
                HeroIcons.bin,
                size: 20,
              ),
              onPressed: () {},
            ),
            ButtonMediumSecondary(
              text: "View All Locations",
              leftIcon: const HeroIcon(HeroIcons.pin,
                  size: 20, color: ThemeColors.blue3),
              onPressed: () {},
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
      rows: items
          .map<PlutoRow>(
            _buildItem,
          )
          .toList(),
      cols: _cols,
    );
  }

  PlutoRow _buildItem(Map e) {
    return PlutoRow(cells: {
      "location": PlutoCell(value: e),
      "location_name": PlutoCell(value: e['location_name']),
      "address": PlutoCell(value: e['address']),
      "contact": PlutoCell(value: e['contact']),
      "required_staff": PlutoCell(value: e['required_staff'].toString()),
      "ip_address": PlutoCell(value: e['ip_address']),
      "status": PlutoCell(value: e['status']),
      "action": PlutoCell(value: ""),
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
                      text: "of ${items.length} entries",
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
