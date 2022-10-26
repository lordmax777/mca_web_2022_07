import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/redux/states/general_state.dart';
import '../../theme/theme.dart';
import 'package:faker/faker.dart';

import '../home_page.dart';

class StockItemsListPage extends StatelessWidget {
  const StockItemsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          const PagesTitleWidget(
            title: 'Stock Items',
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

  late PlutoGridStateManager usersPageStateManger;

  bool _isSmLoaded = false;

  int _pageSize = 10;
  int _page = 1;

  final TextEditingController _searchController = TextEditingController();

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
        title: "item",
        field: "item",
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
        title: "Item Name",
        field: "item_name",
        enableEditingMode: true,
        enableAutoEditing: true,
        width: 1000,
        enableRowChecked: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Our Price",
        field: "our_price",
        enableEditingMode: true,
        enableAutoEditing: true,
        titleTextAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.number(),
        renderer: (rendererContext) {
          return UsersListTable.defaultTextWidget(
              "\$${rendererContext.cell.value}",
              textAlign: TextAlign.right);
        },
      ),
      PlutoColumn(
        title: "Customer Price",
        field: "customer_price",
        enableEditingMode: true,
        enableAutoEditing: true,
        titleTextAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.number(),
        renderer: (rendererContext) {
          return UsersListTable.defaultTextWidget(
              "\$${rendererContext.cell.value}",
              textAlign: TextAlign.right);
        },
      ),
      PlutoColumn(
        title: "Tax",
        field: "tax",
        titleTextAlign: PlutoColumnTextAlign.right,
        type: PlutoColumnType.number(),
        renderer: (rendererContext) {
          return UsersListTable.defaultTextWidget(
              "${rendererContext.cell.value}%",
              textAlign: TextAlign.right);
        },
      ),
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
      usersPageStateManger.setOnChanged(_onEdit);
    });
  }

  void _onEdit(PlutoGridOnChangedEvent event) {}

  void _setFilter() {
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        if (usersPageStateManger.page > 1) {
          usersPageStateManger.setPage(1);
        }
        usersPageStateManger.setFilter(
          (element) {
            final String search = _searchController.text.toLowerCase();
            bool searched = element.cells['item_name']?.value
                .toLowerCase()
                .contains(search);
            if (!searched) {
              searched = element.cells['our_price']!.value
                  .toString()
                  .toLowerCase()
                  .contains(search);
              if (!searched) {
                searched = element.cells['customer_price']!.value
                    .toString()
                    .toLowerCase()
                    .contains(search);
                if (!searched) {
                  searched = element.cells['tax']!.value
                      .toString()
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
        "item": faker.guid.guid(),
        "item_name": faker.company.name(),
        "our_price": faker.randomGenerator.integer(100000),
        "customer_price": faker.randomGenerator.integer(100000),
        "tax": faker.randomGenerator.integer(100),
      };
      items.add(map);
    }
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
              hintText: 'Search stock items...',
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
              text: "New Item",
              icon: const HeroIcon(HeroIcons.plusCircle, size: 20),
              onPressed: () {
                showOverlayPopup(
                    body: const StocksNewItemPopupWidget(), context: context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body() {
    return StockItemsListTable(
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
      "item": PlutoCell(value: e),
      "item_name": PlutoCell(value: e['item_name']),
      "our_price": PlutoCell(value: e['our_price']),
      "customer_price": PlutoCell(value: e['customer_price']),
      "tax": PlutoCell(value: e['tax']),
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
