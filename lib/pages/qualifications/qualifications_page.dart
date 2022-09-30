import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/home_page.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../theme/theme.dart';

class QualificationsPage extends StatelessWidget {
  const QualificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          const PagesTitleWidget(
            title: 'Qualifications',
          ),
          ErrorWrapper(errors: const [], child: _Body(state: state))
        ]),
      ),
    );
  }
}

class _Body extends StatefulWidget {
  final AppState state;

  const _Body({Key? key, required this.state}) : super(key: key);

  @override
  State<_Body> createState() => __BodyState();
}

class __BodyState extends State<_Body> {
  late PlutoGridStateManager usersPageStateManger;
  bool _isSmLoaded = false;
  final List<Map> items = [
    {
      "qualification_name": "Cleaners",
      "levels": 1,
      "expire": 0,
      "comment": "Lorem COmmentofj hsdkfjsdufhsdkuhfksj"
    },
    {
      "qualification_name": "Finance",
      "levels": 0,
      "expire": 1,
      "comment": "Lorem COmmentofj hsdkfjsdufhsdkuhfksj"
    },
    {
      "qualification_name": "Managers",
      "levels": 1,
      "expire": 1,
      "comment": "Lorem COmmentofj hsdkfjsdufhsdkuhfksj"
    },
    {
      "qualification_name": "Logistics",
      "levels": 0,
      "expire": 0,
      "comment": "Lorem COmmentofj hsdkfjsdufhsdkuhfksj"
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
        title: "qualification",
        field: "qualification",
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
        title: "Qualification Name",
        field: "qualification_name",
        enableRowChecked: true,
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
        title: "Expire",
        field: "expire",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Levels",
        field: "levels",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          title: "Comment",
          field: "comment",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return TableTooltipWidget(
                title: "Read Comment", message: ctx.cell.value.toString());
          }),
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
            bool searched = element.cells['qualification_name']?.value
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
            if (!searched) {
              searched = element.cells['expire']?.value
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
              if (!searched) {
                searched = element.cells['levels']?.value
                    .toLowerCase()
                    .contains(_searchController.text.toLowerCase());
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
              hintText: "Search qualifications...",
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
              text: "New Qualification",
              icon: const HeroIcon(
                HeroIcons.plusCircle,
                size: 20,
              ),
              onPressed: () {
                showOverlayPopup(
                    body: const QualifsNewQualifPopupWidget(),
                    context: context);
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
      "qualification": PlutoCell(value: e),
      "qualification_name": PlutoCell(value: e["qualification_name"]),
      "space": PlutoCell(value: ""),
      "expire": PlutoCell(value: e["expire"] == 0 ? "Yes" : "No"),
      "levels": PlutoCell(value: e["levels"] == 0 ? "Yes" : "No"),
      "comment": PlutoCell(value: e["comment"]),
      "action": PlutoCell(value: ""),
    });
  }
}
