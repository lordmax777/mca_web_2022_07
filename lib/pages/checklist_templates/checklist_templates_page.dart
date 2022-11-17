import 'package:auto_route/auto_route.dart';
import 'package:faker/faker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';
import 'package:mca_web_2022_07/pages/home_page.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../theme/theme.dart';

class ChecklistTemplatesPage extends StatelessWidget {
  const ChecklistTemplatesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          const PagesTitleWidget(
            title: 'Checklist Templates',
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
  final List<Map> items = [];

  final TextEditingController _searchController = TextEditingController();

  List<PlutoColumn> get _cols {
    return [
      PlutoColumn(
        title: "checklist",
        field: "checklist",
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
        title: "Checklist Name",
        field: "checklist_name",
        enableRowChecked: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 200,
        title: "",
        field: "space",
        readOnly: true,
        type: PlutoColumnType.text(),
        enableSorting: false,
      ),
      PlutoColumn(
        title: "Title",
        field: "title",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 100,
        title: "Section",
        field: "section",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          width: 100,
          title: "Action",
          field: "action",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "Edit",
              textColor: ThemeColors.MAIN_COLOR,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onUserDetailsNavigationClick(ctx),
              icon: HeroIcon(
                HeroIcons.edit,
                color: ThemeColors.MAIN_COLOR,
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
            bool searched = element.cells['checklist_name']?.value
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
            if (!searched) {
              searched = element.cells['title']?.value
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase());
              if (!searched) {
                searched = element.cells['section']?.value
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
    for (int i = 0; i < 30; i++) {
      items.add({
        "checklist": "",
        "checklist_name": faker.lorem.words(5).join(" "),
        "title": faker.job.title(),
        "section": faker.randomGenerator.integer(30),
      });
    }
    // _users.clear();
    // _users.addAll(widget.state.usersState.usersList.data!);
  }

  Future<void> _onUserDetailsNavigationClick(
      PlutoColumnRendererContext ctx) async {}

  @override
  void dispose() {
    _searchController.dispose();
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
              hintText: "Search templates...",
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
              text: "New Template",
              icon: const HeroIcon(
                HeroIcons.plusCircle,
                size: 20,
              ),
              onPressed: () {
                context.pushRoute(NewChecklistTemplateRoute());
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
      "checklist": PlutoCell(value: e),
      "checklist_name": PlutoCell(value: e["checklist_name"]),
      "space": PlutoCell(value: ""),
      "title": PlutoCell(value: e["title"]),
      "section": PlutoCell(value: e["section"].toString()),
      "action": PlutoCell(value: ""),
    });
  }
}
