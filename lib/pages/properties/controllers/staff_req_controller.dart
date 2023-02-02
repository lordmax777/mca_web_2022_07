// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';
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

  List<Map<String, dynamic>> get createdList => allRows
      .where((element) =>
          element.cells['state']!.value == RowState.created &&
          !element.cells['state']!.value.toString().startsWith("-"))
      .map((e) => {
            "id": e.cells['id']!.value,
            "name": e.cells['name']!.value,
            "staff_number": e.cells['staff_number']!.value,
            "max_staff": e.cells['max_staff']!.value
          })
      .toList();

  void toggleLoading(Function callback) async {
    gridStateManager!.setShowLoading(true);
    await callback();
    gridStateManager!.setShowLoading(false);
  }

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
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Maximum Staff",
        field: "max_staff",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "State",
        field: "state",
        hide: !kDebugMode,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Action",
        field: "action",
        enableSorting: false,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) => GridTableHelpers.getActionRenderer(
          rendererContext,
          title: "Delete",
          icon: HeroIcons.bin,
          color: ThemeColors.red3,
          onTap: (PlutoColumnRendererContext ctx) {
            onDeleteClick(context, ctx);
          },
        ),
      ),
    ];
  }

  PlutoRow _buildItem(ShiftStaffReqMd e, [RowState? state]) {
    return PlutoRow(cells: {
      "id": PlutoCell(value: e.groupId.toString()),
      "name": PlutoCell(value: e.group),
      "staff_number": PlutoCell(value: e.min.toString()),
      "max_staff": PlutoCell(value: e.max?.toString() ?? ""),
      "action": PlutoCell(value: e),
      "state": PlutoCell(value: state ?? RowState.idle),
    });
  }

  PlutoGridStateManager? gridStateManager;

  void setSm(PlutoGridStateManager sm) async {
    gridStateManager = sm;
    toggleLoading(getListRequest);
  }

  void onEditClick(BuildContext context,
      [PlutoColumnRendererContext? ctx]) async {
    var state =
        (ctx?.row.cells["state"]?.value ?? RowState.created) as RowState;
    final res = await showOverlayPopup(
        body: EditShiftStaffReqPopup(staff: ctx?.cell.value), context: context);
    if (res != null) {
      if (state == RowState.idle) {
        state = RowState.updated;
      }
      replaceRow(res, ctx?.rowIdx, state);
      update();
    }
  }

  Future<bool> onDeleteClick(
      BuildContext context, PlutoColumnRendererContext ctx) async {
    if (ctx.row.cells["state"]?.value == RowState.created) {
      gridStateManager!.removeRows([ctx.row]);
      update();
      return true;
    }
    try {
      bool success = false;
      success = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete"),
            content: const Text("Are you sure you want to delete this item?"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  toggleLoading(() async {
                    final int groupId = int.parse(ctx.row.cells["id"]!.value);
                    final res = await deleteStaffRequest(groupId);
                    success = res.success;
                    if (success) {
                      gridStateManager!.removeRows([ctx.row]);
                      update();
                    }
                    Get.back();
                  });
                },
                child: const Text("Delete"),
              ),
            ],
          );
        },
      );
      return success;
    } catch (e) {
      return false;
    }
  }

  void replaceRow(ShiftStaffReqMd e, [int? idx, RowState? state]) {
    final row = _buildItem(e, state);
    if (idx != null) {
      gridStateManager!.removeRows([gridStateManager!.refRows[idx]]);
    }
    gridStateManager!.insertRows(idx ?? 0, [row]);
  }

  void onSave(BuildContext context) async {
    toggleLoading(() async {
      Map created = await createRequest();
      final int createSCount = created['successCount'] ?? 0;
      final int createFCount = created['failCount'] ?? 0;
      final List<String> createdMsgs = created['messages'] ?? [];
      final int total = createdList.length;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Save"),
            content: Text("Total: $total\n"
                "\n"
                "Created: $createSCount/$createFCount\n"
                "${createdMsgs.join('\n')}\n"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      if (createSCount > 0) {
        await getListRequest();
      }
    });
  }

  Future<void> getListRequest() async {
    final int id = property.id ?? -1;
    if (id != -1) {
      gridStateManager!.removeAllRows();
      List<ShiftStaffReqMd> res = await GetPropertiesAction.fetchShiftStaff(id);
      List<PlutoRow> rows = res.map((e) => _buildItem(e)).toList();
      gridStateManager!.appendRows(rows.reversed.toList());
    }
  }

  Future<Map> createRequest() async {
    int failCount = 0;
    int successCount = 0;
    List<String> messages = [];
    for (int i = 0; i < createdList.length; i++) {
      final item = createdList[i];
      final ApiResponse res = await restClient()
          .postPropertiesStaff(
            id: property.id!,
            maxOfStaff: int.tryParse(item['max_staff']),
            groupId: int.parse(item['id']),
            numberOfStaff: int.parse(item['staff_number']),
          )
          .nocodeErrorHandler();
      if (!res.success) {
        failCount++;
        messages.add(ApiHelpers.getRawDataErrorMessages(res));
      } else {
        successCount++;
      }
    }
    return {
      "successCount": successCount,
      "failCount": failCount,
      "messages": messages
    };
  }

  Future<ApiResponse> deleteStaffRequest(int groupId) async {
    final ApiResponse res = await restClient()
        .deletePropertiesStaff(property.id!, groupId)
        .nocodeErrorHandler();

    return res;
  }
}
