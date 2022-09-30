import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/home_page.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../theme/theme.dart';

class GroupsTab extends StatefulWidget {
  final AppState state;
  const GroupsTab({Key? key, required this.state}) : super(key: key);

  @override
  State<GroupsTab> createState() => _GroupsTabState();
}

class _GroupsTabState extends State<GroupsTab> {
  late PlutoGridStateManager usersPageStateManger;
  bool _isSmLoaded = false;
  final List<Map> items = [
    {
      "group_name": "Cleaners",
      "status": 0,
    },
    {
      "group_name": "Finance",
      "status": 1,
    },
    {
      "group_name": "Managers",
      "status": 1,
    },
    {
      "group_name": "Logistics",
      "status": 0,
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
        title: "department",
        field: "department",
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
          title: "Group Name",
          field: "group_name",
          enableRowChecked: true,
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
        width: 700,
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
      _setFilter();
      _isSmLoaded = true;
    });
  }

  void _setFilter() {
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) {
        usersPageStateManger.setFilter(
          (element) {
            bool searched = element.cells['group_name']?.value
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
            if (!searched) {
              searched = element.cells['status']?.value
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
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
    // _users.clear();
    // _users.addAll(widget.state.usersState.usersList.data!);
  }

  Future<void> _onUserDetailsNavigationClick(
      PlutoColumnRendererContext ctx) async {
    appStore
        .dispatch(UpdateGeneralStateAction(endDrawer: const DepGroupDrawer()));
    await Future.delayed(const Duration(milliseconds: 100));
    if (scaffoldKey.currentState != null) {
      if (!scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openEndDrawer();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    appStore.dispatch(UpdateGeneralStateAction(endDrawer: null));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context),
          _body(),
        ],
      ),
    );
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
              text: "New Group",
              icon: const HeroIcon(
                HeroIcons.plusCircle,
                size: 20,
              ),
              onPressed: () {
                showOverlayPopup(
                    body: const GroupsNewDepPopupWidget(), context: context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body() {
    return DepsListTable(
      onSmReady: _setSm,
      rows: items.map<PlutoRow>(_buildItem).toList(),
      cols: _cols,
    );
  }

  PlutoRow _buildItem(Map e) {
    return PlutoRow(cells: {
      "department": PlutoCell(value: e),
      "group_name": PlutoCell(value: e["group_name"]),
      "status": PlutoCell(value: e["status"] == 0 ? "active" : "inactive"),
      "space": PlutoCell(value: ""),
      "action": PlutoCell(value: ""),
    });
  }
}
