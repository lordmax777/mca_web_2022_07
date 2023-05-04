import 'package:auto_route/auto_route.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/pages/properties/new_prop_tabs/edit_shift_qualif_req_popup.dart';

import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';
import '../../properties/new_prop_tabs/edit_shift_staff_req_popup.dart';
import '../models/create_shift_type.dart';

class QualificationReqForm extends StatefulWidget {
  final CreateShiftData data;
  const QualificationReqForm({Key? key, required this.data}) : super(key: key);

  @override
  State<QualificationReqForm> createState() => _QualificationReqFormState();
}

class _QualificationReqFormState extends State<QualificationReqForm> {
  CreateShiftData get data => widget.data;
  PlutoGridStateManager get gridStateManager => data.qualifReqGridManager;
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
        title: "Qualification",
        field: "department",
        type: PlutoColumnType.text(),
        enableRowChecked: true,
      ),
      PlutoColumn(
        title: "Min.Level",
        field: "min_level",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Number of Staff",
        field: "min",
        type: PlutoColumnType.number(),
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
          (row.cells['depModel']!.value as ShiftQualifReqMd).qualificationId;
      gridStateManager.setShowLoading(true);
      final ApiResponse res = await restClient()
          .deletePropertiesQualif(data.shiftId!, groupId)
          .nocodeErrorHandler();
      gridStateManager.setShowLoading(false);
      if (res.success) {
        gridStateManager.removeRows([row]);
      } else {
        showError(res.data != null
            ? ApiHelpers.getRawDataErrorMessages(res)
            : "Error deleting qualification requirement");
      }
    } on Exception catch (e) {
      Logger.e(e.toString(), tag: "QualificationReqForm._onDelete");
      showError("Error deleting qualification requirement");
    }
  }

  void _onCreate() async {
    try {
      final ShiftQualifReqMd? item = await showOverlayPopup(
          body: EditShiftQualifReqPopup(
            exceptedIds: [
              ...(gridStateManager.rows
                  .map((e) => (e.cells['depModel']!.value as ShiftQualifReqMd)
                      .qualificationId)
                  .toList())
            ],
          ),
          context: context);
      if (item == null) return;
      gridStateManager.setShowLoading(true);
      final ApiResponse res = await restClient()
          .postPropertiesQualif(
            id: data.shiftId!,
            levelId: item.levelId,
            numberOfStaff: item.numberOfStaff,
            qualificationId: item.qualificationId,
          )
          .nocodeErrorHandler();
      if (res.success) {
        gridStateManager.appendRows([_buildRow(item)]);
      } else {
        showError(res.data != null
            ? ApiHelpers.getRawDataErrorMessages(res)
            : "Error creating qualification requirement");
      }
      gridStateManager.setShowLoading(false);
    } on Exception catch (e) {
      Logger.e(e.toString(), tag: "QualificationReqForm._onCreate");
      showError("Error creating qualification requirement");
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
                title: 'Qualification Requirements',
                btnText: "Add",
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

  PlutoRow _buildRow(ShiftQualifReqMd group) {
    return PlutoRow(
      cells: {
        "depModel": PlutoCell(value: group),
        "department": PlutoCell(value: group.qualificationName),
        "min_level": PlutoCell(value: group.levelName),
        "min": PlutoCell(value: group.numberOfStaff),
        "delete_btn": PlutoCell(value: ""),
      },
    );
  }

  Widget _table(AppState state) {
    return UsersListTable(
        height: MediaQuery.of(context).size.height * 0.7,
        rows: [],
        gridBorderColor: Colors.grey[300]!,
        noRowsText: "No qualification requirements",
        onSmReady: (e) async {
          data.qualifReqGridManager = e;

          gridStateManager.setShowLoading(true);
          List<ShiftQualifReqMd> res =
              await GetPropertiesAction.fetchShiftQualif(data.shiftId ?? -1);
          if (res.isNotEmpty) {
            for (var item in res) {
              e.appendRows([_buildRow(item)]);
            }
          }
          gridStateManager.setShowLoading(false);
        },
        cols: cols(state));
  }
}
