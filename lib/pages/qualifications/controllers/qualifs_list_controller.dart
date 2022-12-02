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

class QualifsController extends GetxController {
  //UI Variables
  final RxDouble _deleteBtnOpacity = 0.5.obs;
  final TextEditingController searchController = TextEditingController();

  late PlutoGridStateManager gridStateManager;
  List<PlutoColumn> columns(BuildContext context) {
    return [
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

    _setFilter();
  }

  void _setFilter() {
    searchController.addListener(() {
      gridStateManager.toggleAllRowChecked(false);
      setDeleteBtnOpacity = 0.5;
      if (searchController.text.isNotEmpty) {
        gridStateManager.setFilter(
          (element) {
            bool searched = element.cells['qualification_name']?.value
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
            if (!searched) {
              searched = element.cells['expire']?.value
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase());
              if (!searched) {
                searched = element.cells['levels']?.value
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

  Future<void> _onColumnItemNavigate(PlutoColumnRendererContext ctx) async {
    appStore
        .dispatch(UpdateGeneralStateAction(endDrawer: const DepGroupDrawer()));
    await Future.delayed(const Duration(milliseconds: 100));
    if (scaffoldKey.currentState != null) {
      if (!scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openEndDrawer();
      }
    }
  }

  void _onEditClick(BuildContext context, PlutoColumnRendererContext ctx) {
    showOverlayPopup(
        body: QualifsNewQualifPopupWidget(qualif: ctx.cell.value),
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
          await restClient().deleteQualification(id).nocodeErrorHandler();
      if (!res.success) {
        allSuccess = false;
        resp = res;
        break;
      } else {
        _deps.removeWhere((element) => element.id == id);
      }
    }

    if (allSuccess) {
      gridStateManager.removeRows(gridStateManager.checkedRows);
      gridStateManager.toggleAllRowChecked(false);
      setDeleteBtnOpacity = 0.5;
      // gridStateManager.toggleAllRowChecked(false);
      // setDeleteBtnOpacity = 0.5;
      // await appStore.dispatch(GetAllParamListAction());
      closeLoading();
    } else {
      await closeLoading();
      showError(resp?.rawError?.data.toString() ?? "Error");
    }
  }

  //Departments
  final RxList<ListQualification> _deps = <ListQualification>[].obs;
  List<ListQualification> get departments => _deps;
  setList(List<ListQualification> d) {
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
