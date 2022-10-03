import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/router/router.gr.dart';
import 'package:mca_web_2022_07/pages/warehouses/warehouse_drawer.dart';
import 'package:mca_web_2022_07/pages/warehouses/wares_page_new_ware_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/redux/states/general_state.dart';
import '../../theme/theme.dart';
import 'package:faker/faker.dart';

import '../home_page.dart';

class WarehousesListPage extends StatelessWidget {
  const WarehousesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          const PagesTitleWidget(
            title: 'Warehouses',
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
        title: "warehouse",
        field: "warehouse",
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
        width: 300.0,
        title: "Location Name",
        field: "warehouse_name",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 360.0,
        title: "Contact Name",
        field: "contact_name",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          width: 300.0,
          title: "Contact Email",
          field: "contact_email",
          type: PlutoColumnType.text()),
      PlutoColumn(
        width: 250.0,
        title: "Linked Properties",
        field: "linked_properties",
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return KText(
            text: rendererContext.cell.value.toString(),
            textColor: ThemeColors.blue3,
            fontWeight: FWeight.regular,
            fontSize: 14,
            onTap: () {},
            isSelectable: false,
          );
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
            bool searched = element.cells['warehouse_name']?.value
                .toLowerCase()
                .contains(search);
            if (!searched) {
              searched = element.cells['contact_name']?.value
                  .toLowerCase()
                  .contains(search);
              if (!searched) {
                searched = element.cells['contact_email']?.value
                    .toLowerCase()
                    .contains(search);
                if (!searched) {
                  searched = element.cells['linked_properties']?.value
                      .toLowerCase()
                      .contains(search);
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
    for (int i = 0; i < 30; i++) {
      final Map map = {
        "warehouse": faker.guid.guid(),
        "warehouse_name": faker.address.streetAddress(),
        "contact_name": faker.person.name(),
        "contact_email": faker.internet.email(),
        "linked_properties": faker.randomGenerator.integer(50),
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
    appStore
        .dispatch(UpdateGeneralStateAction(endDrawer: const WarehouseDrawer()));
    await Future.delayed(const Duration(milliseconds: 100));
    if (scaffoldKey.currentState != null) {
      if (!scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openEndDrawer();
      }
    }
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
              hintText: 'Search warehouses...',
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
            ButtonMedium(
              text: "New Warehouse",
              icon: const HeroIcon(HeroIcons.plusCircle, size: 20),
              onPressed: () {
                showOverlayPopup(
                    body: const WaresNewWarePopupWidget(), context: context);
              },
            ),
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
      "warehouse": PlutoCell(value: e),
      "warehouse_name": PlutoCell(value: e['warehouse_name']),
      "contact_name": PlutoCell(value: e['contact_name']),
      "contact_email": PlutoCell(value: e['contact_email']),
      "linked_properties": PlutoCell(value: e['linked_properties'].toString()),
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
