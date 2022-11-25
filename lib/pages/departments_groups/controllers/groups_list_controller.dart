import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../comps/dropdown_widget1.dart';
import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/sets/state_value.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';
import '../../home_page.dart';

class GroupsController extends GetxController {
  //Etc
  final List<Tab> tabs = const [Tab(text: 'Departments'), Tab(text: 'Groups')];

  //UI Variables
  //UI Variables
  final Rx<CodeMap<bool>> _status = CodeMap<bool>(name: null, code: null).obs;
  CodeMap<bool> get status => _status.value;
  set setStatus(CodeMap<bool> value) => _status.value = value;
  final RxDouble _deleteBtnOpacity = 0.5.obs;
  double get deleteBtnOpacity => _deleteBtnOpacity.value;
  set setDeleteBtnOpacity(double value) {
    _deleteBtnOpacity.value = value;
  }

  final TextEditingController searchController = TextEditingController();

  late PlutoGridStateManager gridStateManager;
  List<PlutoColumn> columns(BuildContext context) {
    return [
      PlutoColumn(
          title: "Group Name",
          field: "group_name",
          enableRowChecked: true,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: ctx.cell.value,
              textColor: ThemeColors.MAIN_COLOR,
              fontWeight: FWeight.regular,
              fontSize: 14,
              mainAxisSize: MainAxisSize.min,
              isSelectable: false,
              onTap: () => _onColumnItemNavigate(ctx),
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

  //Departments
  final RxList<ListJobTitle> _deps = <ListJobTitle>[].obs;
  List<ListJobTitle> get departments => _deps;
  setList(List<ListJobTitle> d) {
    final dd = [...d];
    dd.sort((a, b) => a.name.compareTo(b.name));
    _deps.value = dd;
    return _deps;
  }

//Functions
  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    gridStateManager.setOnRowChecked((event) {
      if (gridStateManager.checkedRows.isNotEmpty) {
        if (gridStateManager.checkedRows.length > 1) {
          resetStatus;
        }
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
            bool searched = element.cells['group_name']?.value
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

  Future<void> _onColumnItemNavigate(PlutoColumnRendererContext ctx) async {
    final ListJobTitle dep = ctx.row.cells['action']!.value;
    appStore.dispatch(
        UpdateGeneralStateAction(endDrawer: DepGroupDrawer(department: dep)));
    await Future.delayed(const Duration(milliseconds: 100));
    if (scaffoldKey.currentState != null) {
      if (!scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openEndDrawer();
      }
    }
  }

  void onOneTapSelect(PlutoGridOnSelectedEvent event) {
    gridStateManager.toggleAllRowChecked(false);
    event.row!.setChecked(!event.row!.checked!);
    if (gridStateManager.checkedRows.isNotEmpty) {
      final item = event.row!.cells['action']!.value as ListJobTitle;
      setStatus = CodeMap(
        name: Constants.userAccountStatusTypes[item.active],
        code: item.active,
      );
      setDeleteBtnOpacity = 1.0;
    } else {
      setDeleteBtnOpacity = 0.5;
      resetStatus;
    }
  }

  void _onEditClick(BuildContext context, PlutoColumnRendererContext ctx) {
    showOverlayPopup(
        body: GroupsNewDepPopupWidget(group: ctx.cell.value), context: context);
  }

  Future<void> onStatusChange(DpItem value) async {
    final List<PlutoRow> selectedRows = gridStateManager.checkedRows;
    if (selectedRows.isEmpty) {
      showError("Please select at least one item!");
      return;
    }
    if (gridStateManager.checkedRows.length > 1) {
      final ids = gridStateManager.checkedRows
          .map<int>((e) => e.cells['action']?.value.id)
          .toList();
      showLoading();
      bool allSuccess = true;
      ApiResponse? resp;
      for (int i = 0; i < ids.length; i++) {
        final item = selectedRows[i].cells['action']!.value as ListJobTitle;

        final ListJobTitle updateableItem = ListJobTitle(
            id: item.id,
            name: item.name,
            active: (value.item as MapEntry<bool, String>).key);

        final ApiResponse res = await restClient()
            .postJobTitle(
              title: updateableItem.name,
              active: updateableItem.active,
              id: updateableItem.id,
            )
            .nocodeErrorHandler();

        if (!res.success) {
          allSuccess = false;
          resp = res;
          break;
        }
      }

      if (allSuccess) {
        gridStateManager.toggleAllRowChecked(false);
        if (allSuccess) {
          resetStatus;
        }
        setDeleteBtnOpacity = 0.5;
        await appStore.dispatch(GetAllParamListAction());
        closeLoading();
      } else {
        await closeLoading();
        showError(resp?.rawError?.data.toString() ?? "Error");
      }

      return;
    }
    final item = selectedRows[0].cells['action']!.value as ListJobTitle;

    final ListJobTitle updateableItem = ListJobTitle(
        id: item.id,
        name: item.name,
        active: (value.item as MapEntry<bool, String>).key);

    if (item.active == (value.item as MapEntry<bool, String>).key) {
      return;
    }

    ApiResponse? success = await GroupsNewDepController.to
        .postDepartment(updateableItem: updateableItem);
    if (success != null && success.success) {
      resetStatus;
    }
  }

  void get resetStatus {
    setStatus = CodeMap<bool>(
      name: null,
      code: null,
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
