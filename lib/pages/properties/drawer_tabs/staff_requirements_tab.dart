import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import '../../../theme/theme.dart';

class PropertyStaffReqTab extends StatelessWidget {
  final PropertiesMd property;

  PropertyStaffReqTab(this.property, {Key? key}) : super(key: key);

  final List<ShiftStaffReqMd> staff = [];
  final List<PlutoRow> fetchedRows = [];

  List<PlutoColumn> columns() {
    return [
      PlutoColumn(
        width: 320.0,
        title: "Department Name",
        field: "name",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Number of Staff",
        field: "staff_num",
        width: 160.0,
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: "Maximum Staff",
        field: "max_staff",
        width: 160.0,
        type: PlutoColumnType.number(),
      ),
    ];
  }

  late PlutoGridStateManager gridStateManager;

  void setSm(PlutoGridStateManager sm) async {
    gridStateManager = sm;
    final shiftId = property.id ?? -1;
    if (shiftId != -1) {
      try {
        gridStateManager.setShowLoading(true);
        List<ShiftStaffReqMd> res =
            await GetPropertiesAction.fetchShiftStaff(shiftId);
        staff.addAll(res);
        gridStateManager.appendRows(staff.map<PlutoRow>(_buildItem).toList());
      } catch (e) {
        gridStateManager.setShowLoading(false);
      } finally {
        gridStateManager.setShowLoading(false);
      }
    }
    gridStateManager.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return UsersListTable(
      onSmReady: setSm,
      rows: [],
      cols: columns(),
    );
  }

  PlutoRow _buildItem(ShiftStaffReqMd e) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: e.group),
      "staff_num": PlutoCell(value: e.min),
      "max_staff": PlutoCell(value: e.max),
    });
  }
}
