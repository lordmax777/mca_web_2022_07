// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/sets/state_value.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../theme/theme.dart';
import '../../home_page.dart';
import '../new_prop_tabs/edit_shift_staff_req_popup.dart';

class StaffReqController extends GetxController {
  StaffReqController({required this.property});
  final PropertiesMd property;
  //Etc
  final List<Tab> tabs = const [Tab(text: 'Departments'), Tab(text: 'Groups')];

  List<PlutoRow> get allRows =>
      gridStateManager != null ? gridStateManager!.rows : [];

  List<PlutoColumn> columns(BuildContext context) {
    return [
      PlutoColumn(
        title: "",
        field: "id",
        hide: true,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Department Name",
        field: "name",
        width: PlutoGridSettings.columnWidth + 700,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Number of Staff",
        field: "staff_number",
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: "Maximum Staff",
        field: "max_staff",
        type: PlutoColumnType.number(),
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

  PlutoGridStateManager? gridStateManager;

  //Functions
  void setSm(PlutoGridStateManager sm) async {
    gridStateManager = sm;
    fetch();
  }

  void get toggleLoading =>
      gridStateManager!.setShowLoading(!gridStateManager!.showLoading);

  void _onEditClick(
      BuildContext context, PlutoColumnRendererContext ctx) async {
    final res = await showOverlayPopup(
        body: EditShiftStaffReqPopup(staff: ctx.cell.value), context: context);
    if (res != null) {
      replaceRow(res, ctx.rowIdx);
      update();
    }
  }

  void replaceRow(ShiftStaffReqMd e, [int? idx]) {
    final row = _buildItem(e);
    if (idx != null) {
      gridStateManager!.removeRows([gridStateManager!.refRows[idx]]);
    }
    gridStateManager!.insertRows(idx ?? 0, [row]);
  }

  PlutoRow _buildItem(ShiftStaffReqMd e) {
    return PlutoRow(cells: {
      "id": PlutoCell(value: e.groupId.toString()),
      "name": PlutoCell(value: e.group),
      "staff_number": PlutoCell(value: e.min),
      "max_staff": PlutoCell(value: e.max),
      "action": PlutoCell(value: e),
    });
  }

  Future<void> fetch() async {
    toggleLoading;
    final int id = property.id ?? -1;
    if (id != -1) {
      List<ShiftStaffReqMd> res = await GetPropertiesAction.fetchShiftStaff(id);
      List<PlutoRow> rows = res.map((e) => _buildItem(e)).toList();
      gridStateManager!.appendRows(rows);
    }
    toggleLoading;
  }
}
