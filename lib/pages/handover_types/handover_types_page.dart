import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/redux/states/general_state.dart';
import '../../theme/theme.dart';
import 'package:faker/faker.dart';

import '../home_page.dart';

class HandoverTypesPage extends StatelessWidget {
  const HandoverTypesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          const PagesTitleWidget(
            title: 'Handover Types',
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
        title: "handover_type",
        field: "handover_type",
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
        title: "Handover Name",
        field: "handover_type_name",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 500,
        title: "",
        field: "space",
        readOnly: true,
        type: PlutoColumnType.text(),
        enableSorting: false,
      ),
      PlutoColumn(
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
            bool searched = element.cells['handover_type_name']?.value
                .toLowerCase()
                .contains(search);
            if (!searched) {
              searched =
                  element.cells['status']?.value.toLowerCase().contains(search);
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
        "handover_type": faker.guid.guid(),
        "handover_type_name": faker.lorem.words(3).join(" "),
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
    // appStore
    //     .dispatch(UpdateGeneralStateAction(endDrawer: const WarehouseDrawer()));
    // await Future.delayed(const Duration(milliseconds: 100));
    // if (scaffoldKey.currentState != null) {
    //   if (!scaffoldKey.currentState!.isDrawerOpen) {
    //     scaffoldKey.currentState!.openEndDrawer();
    //   }
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
              hintText: 'Search handover_types...',
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
              text: "New Handover",
              icon: const HeroIcon(HeroIcons.plusCircle, size: 20),
              onPressed: () {
                showOverlayPopup(
                    body: const HandsNewHandoverPopupWidget(),
                    context: context);
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
      rows: items.map<PlutoRow>(_buildItem).toList(),
      cols: _cols,
    );
  }

  PlutoRow _buildItem(Map e) {
    return PlutoRow(cells: {
      "handover_type": PlutoCell(value: e),
      "handover_type_name": PlutoCell(value: e['handover_type_name']),
      "space": PlutoCell(value: ""),
      "status": PlutoCell(value: e['status'].toString()),
      "action": PlutoCell(value: ""),
    });
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
