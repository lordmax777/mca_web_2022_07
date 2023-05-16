import 'package:auto_route/auto_route.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';

import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';
import '../../properties/new_prop_tabs/edit_shift_staff_req_popup.dart';
import '../models/create_shift_type.dart';
import '../scheduling_page.dart';

class StaffRequirementForm extends StatefulWidget {
  final int shiftId;
  const StaffRequirementForm({Key? key, required this.shiftId})
      : super(key: key);

  @override
  State<StaffRequirementForm> createState() => _StaffRequirementFormState();
}

class _StaffRequirementFormState extends State<StaffRequirementForm> {
  late final PlutoGridStateManager gridStateManager;
  List<PlutoRow> get checkedRows => gridStateManager.checkedRows;

  List<PlutoColumn> cols(AppState state) {
    return [
      PlutoColumn(
        title: "",
        field: "depModel",
        type: PlutoColumnType.text(),
        hide: true,
      ),
      PlutoColumn(
        title: "Department",
        field: "department",
        type: PlutoColumnType.text(),
        enableRowChecked: true,
        width: 200,
      ),
      PlutoColumn(
        title: "Number of Staff (min)",
        field: "min",
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: "Number of Staff (max)",
        field: "max",
        type: PlutoColumnType.number(),
        renderer: (rendererContext) {
          return UsersListTable.defaultTextWidget(
              rendererContext.cell.value == 0
                  ? "-"
                  : rendererContext.cell.value);
        },
      ),
      PlutoColumn(
        title: "Action",
        field: "delete_btn",
        width: 50,
        textAlign: PlutoColumnTextAlign.center,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return GridTableHelpers.getActionRenderer(
            rendererContext,
            icon: HeroIcons.bin,
            title: "Delete",
            color: Colors.red,
            onTap: (value) => _onDelete(value.row),
          );
        },
      ),
    ];
  }

  void _onDelete(PlutoRow row) async {
    try {
      final int groupId =
          (row.cells['depModel']!.value as ShiftStaffReqMd).groupId;
      gridStateManager.setShowLoading(true);
      final ApiResponse res = await restClient()
          .deletePropertiesStaff(widget.shiftId!, groupId)
          .nocodeErrorHandler();
      gridStateManager.setShowLoading(false);
      if (res.success) {
        gridStateManager.removeRows([row]);
      } else {
        showError(res.resMessage ?? "Error deleting staff requirement");
      }
    } on Exception catch (e) {
      Logger.e(e.toString(), tag: "StaffRequirementForm._onDelete");
      showError("Error deleting staff requirement");
    }
  }

  void _onCreate([ShiftStaffReqMd? staff]) async {
    try {
      final ShiftStaffReqMd? item = await showOverlayPopup(
          body: EditShiftStaffReqPopup(
            staff: staff,
            exceptedIds: [
              ...(gridStateManager.rows
                  .map((e) =>
                      (e.cells['depModel']!.value as ShiftStaffReqMd).groupId)
                  .toList())
            ],
          ),
          context: context);
      if (item == null) return;
      gridStateManager.setShowLoading(true);
      final ApiResponse res = await restClient()
          .postPropertiesStaff(
            id: widget.shiftId,
            maxOfStaff: item.max,
            groupId: item.groupId,
            numberOfStaff: item.min,
          )
          .nocodeErrorHandler();
      if (res.success) {
        gridStateManager.appendRows([_buildRow(item)]);
      } else {
        _onCreate(item);
        showError(res.resMessage ?? "Error creating staff requirement");
      }
      gridStateManager.setShowLoading(false);
    } on Exception catch (e) {
      Logger.e(e.toString(), tag: "StaffRequirementForm._onCreate");
      showError("Error creating staff requirement");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SpacedColumn(
          verticalSpace: 16.0,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: PagesTitleWidget(
                title: 'Staff Requirements',
                btnText: "Add",
                titleButton: addIcon(
                  tooltip: "Refresh Table",
                  icon: HeroIcons.refresh,
                  onPressed: _onLoad,
                ),
                buttons: [
                  ButtonMedium(
                      bgColor: ThemeColors.red3,
                      text: "Delete Selected",
                      icon: const HeroIcon(
                        HeroIcons.bin,
                        size: 20,
                      ),
                      onPressed: () {
                        for (var i in checkedRows) {
                          _onDelete(i);
                        }
                      }),
                ],
                onRightBtnClick: _onCreate,
              ),
            ),
            _table(state),
          ],
        ),
      ),
    );
  }

  PlutoRow _buildRow(ShiftStaffReqMd group) {
    return PlutoRow(
      cells: {
        "depModel": PlutoCell(value: group),
        "department": PlutoCell(value: group.group),
        "min": PlutoCell(value: group.min),
        "max": PlutoCell(value: group.max),
        "delete_btn": PlutoCell(value: ""),
      },
    );
  }

  Widget _table(AppState state) {
    return UsersListTable(
        height: MediaQuery.of(context).size.height * 0.7,
        rows: [],
        gridBorderColor: Colors.grey[300]!,
        noRowsText: "No staff requirements",
        onSmReady: (e) async {
          gridStateManager = e;
          _onLoad();
        },
        cols: cols(state));
  }

  void _onLoad() async {
    if (gridStateManager.showLoading) return;
    gridStateManager.setShowLoading(true);
    List<ShiftStaffReqMd> res =
        await GetPropertiesAction.fetchShiftStaff(widget.shiftId ?? -1);
    if (res.isNotEmpty) {
      gridStateManager.removeAllRows();
      for (var item in res) {
        gridStateManager.appendRows([_buildRow(item)]);
      }
    }
    gridStateManager.setShowLoading(false);
  }
}
