// ignore_for_file: invalid_use_of_protected_member

import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';

import '../../../manager/model_exporter.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/router/router.dart';
import '../../../theme/theme.dart';
import '../../home.dart';
import '../checklist_drawer.dart';

class ChecklistController extends GetxController {
  static ChecklistController to = Get.find();

  List<PlutoColumn> columns(BuildContext context) {
    return [
      PlutoColumn(
        title: "Checklist Name",
        field: "name",
        width: 500,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        width: 500,
        title: "Title",
        field: "title",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          title: "Sections",
          field: "sections",
          type: PlutoColumnType.number(),
          renderer: (rendererContext) => GridTableHelpers.getActionRenderer(
              rendererContext,
              title: rendererContext.cell.value,
              icon: HeroIcons.link,
              onTap: (PlutoColumnRendererContext ctx) =>
                  _onColumnItemNavigate(ctx))),
      PlutoColumn(
        title: "Action",
        field: "action",
        enableSorting: false,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) => GridTableHelpers.getActionRenderer(
          rendererContext,
          onTap: (PlutoColumnRendererContext ctx) => _onEditClick(context, ctx),
        ),
      ),
    ];
  }

  //Departments
  final RxList<ChecklistTemplateMd> _deps = <ChecklistTemplateMd>[].obs;
  List<ChecklistTemplateMd> get departments => _deps;
  setList(List<ChecklistTemplateMd> d) {
    final dd = [...d];
    dd.sort((a, b) => a.title.compareTo(b.title));
    _deps.value = dd;
    return _deps;
  }

  final TextEditingController searchController = TextEditingController();
  late PlutoGridStateManager gridStateManager;

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    _setFilter();
  }

  void _setFilter() {
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        gridStateManager.setFilter(
          (element) {
            bool searched = element.cells['name']?.value
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
            if (!searched) {
              searched = element.cells['title']?.value
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase());
              if (!searched) {
                searched = element.cells['sections']!.value
                    .toString()
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }
            }
            return searched;
          },
        );
        return;
      }
      gridStateManager.setFilter((element) => true);
    });
  }

  void _onEditClick(BuildContext context, PlutoColumnRendererContext ctx) {
    context.pushRoute(NewChecklistTemplateRoute(checklist: ctx.cell.value));
  }

  Future<void> _onColumnItemNavigate(PlutoColumnRendererContext ctx) async {
    final ChecklistTemplateMd group = ctx.row.cells['action']!.value;
    appStore.dispatch(
        UpdateGeneralStateAction(endDrawer: ChecklistDrawer(checklist: group)));
    await Future.delayed(const Duration(milliseconds: 100));
    if (Constants.scaffoldKey.currentState != null) {
      if (!Constants.scaffoldKey.currentState!.isDrawerOpen) {
        Constants.scaffoldKey.currentState!.openEndDrawer();
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
