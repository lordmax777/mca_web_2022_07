import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import '../../../theme/theme.dart';

class PropertyStaffReqTab extends StatefulWidget {
  final PropertiesMd property;

  PropertyStaffReqTab(this.property, {Key? key}) : super(key: key);

  @override
  State<PropertyStaffReqTab> createState() => _PropertyStaffReqTabState();
}

class _PropertyStaffReqTabState extends State<PropertyStaffReqTab> {
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
    final shiftId = widget.property.id ?? -1;
    if (shiftId != -1) {
      try {
        List<ShiftStaffReqMd> res =
            await GetPropertiesAction.fetchShiftStaff(shiftId);
        staff.addAll(res);
        gridStateManager.appendRows(staff.map<PlutoRow>(_buildItem).toList());
      } catch (e) {
      } finally {}
    }
    setState(() {});
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
