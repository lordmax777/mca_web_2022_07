import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';
import '../../home.dart';

class HandoverTypesController extends GetxController {
  static HandoverTypesController get to => Get.find();

  List<PlutoColumn> columns(BuildContext context) {
    return [
      PlutoColumn(
        title: "Handover Name",
        field: "handover_name",
        width: PlutoGridSettings.columnWidth + 700,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Status",
        field: "status",
        type: PlutoColumnType.text(),
        enableSorting: false,
        renderer: GridTableHelpers.getStatusRenderer,
      ),
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

  final RxList<ListHandoverType> _deps = <ListHandoverType>[].obs;
  List<ListHandoverType> get departments => _deps;
  setList(List<ListHandoverType> d) {
    final dd = [...d];
    dd.sort((a, b) => a.title.compareTo(b.title));
    _deps.value = dd;
    return _deps;
  }

  final TextEditingController searchController = TextEditingController();
  late PlutoGridStateManager gridStateManager;
  final List<PlutoRow> inactiveRows = [];
  final RxBool _isShowInactive = false.obs;
  bool get isShowInactive => _isShowInactive.value;
  void setShowInactive(bool val) {
    if (val) {
      gridStateManager.appendRows(inactiveRows);
    } else {
      gridStateManager.removeRows(inactiveRows);
    }
    // ignore: invalid_use_of_visible_for_testing_member
    searchController.notifyListeners();
    _isShowInactive.value = val;
  }

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    inactiveRows.addAll(gridStateManager.refRows.where((element) =>
        !(element.cells["action"]!.value as ListHandoverType).active));
    if (!isShowInactive) {
      gridStateManager.removeRows(inactiveRows);
    }
    _setFilter();
  }

  void _setFilter() {
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        gridStateManager.setFilter(
          (element) {
            bool searched = element.cells['handover_name']?.value
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
            if (!searched) {
              searched = element.cells['status']?.value
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase());
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
    showOverlayPopup(
        body: HandsNewHandoverPopupWidget(group: ctx.cell.value),
        context: context);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
