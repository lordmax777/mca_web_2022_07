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
import '../../home_page.dart';

class HandoverTypesController extends GetxController {
  static HandoverTypesController get to => Get.find();
  //UI Variables
  final RxDouble _deleteBtnOpacity = 0.5.obs;
  final TextEditingController searchController = TextEditingController();

  late PlutoGridStateManager gridStateManager;
  List<PlutoColumn> columns(BuildContext context) {
    return [
      PlutoColumn(
        title: "Handover Name",
        field: "handover_name",
        enableRowChecked: true,
        type: PlutoColumnType.text(),
      ),
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
              textColor: ThemeColors.MAIN_COLOR,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onEditClick(context, ctx),
              icon: HeroIcon(
                HeroIcons.edit,
                color: ThemeColors.MAIN_COLOR,
                size: 12,
              ),
            );
          }),
    ];
  }

  double get deleteBtnOpacity => _deleteBtnOpacity.value;
  set setDeleteBtnOpacity(double value) {
    _deleteBtnOpacity.value = value;
  }

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    gridStateManager.setOnRowChecked((event) {
      if (gridStateManager.checkedRows.isNotEmpty) {
        setDeleteBtnOpacity = 1.0;
      } else {
        setDeleteBtnOpacity = 0.5;
      }
    });
    _setFilter();
  }

  void _setFilter() {
    searchController.addListener(() {
      gridStateManager.toggleAllRowChecked(false);
      setDeleteBtnOpacity = 0.5;
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

  Future<void> deleteSelectedRows() async {
    final ids = gridStateManager.checkedRows
        .map<int>((e) => e.cells['action']?.value.id)
        .toList();
    if (ids.isEmpty) return;
    showLoading();
    bool allSuccess = true;
    ApiResponse? resp;
    for (int i = 0; i < ids.length; i++) {
      final id = ids[i];
      final ApiResponse res =
          await restClient().deleteHandoverTypes(id).nocodeErrorHandler();
      if (!res.success) {
        allSuccess = false;
        resp = res;
        break;
      } else {
        _deps.removeWhere((element) => element.id == id);
      }
    }

    await closeLoading();
    if (allSuccess) {
      gridStateManager.removeRows(gridStateManager.checkedRows);
      gridStateManager.toggleAllRowChecked(false);
      setDeleteBtnOpacity = 0.5;
    } else {
      if (resp != null) {
        if (resp.resCode == 401) {
          showError("Can delete only what was created today!");
        } else {
          showError(resp.rawError?.data.toString() ?? "Error");
        }
      }
    }
    update();
  }

  //Departments
  final RxList<ListHandoverType> _deps = <ListHandoverType>[].obs;
  List<ListHandoverType> get departments => _deps;
  setList(List<ListHandoverType> d) {
    final dd = [...d];
    dd.sort((a, b) => a.title.compareTo(b.title));
    _deps.value = dd;
    return _deps;
  }

  //Functions
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}