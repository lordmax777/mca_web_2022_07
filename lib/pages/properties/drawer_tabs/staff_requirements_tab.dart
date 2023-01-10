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

  final List<ShiftStaffReqMd> staff = [];

  late PlutoGridStateManager gridStateManager;

  void setSm(PlutoGridStateManager sm) async {
    setState(() {
      gridStateManager = sm;
    });
  }

  @override
  void initState() {
    super.initState();
    final shiftId = widget.property.id ?? -1;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (shiftId != -1) {
        List<ShiftStaffReqMd> res =
            await GetPropertiesAction.fetchShiftStaff(shiftId);
        staff.addAll(res);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (staff.isEmpty) {
      return Center(
        child: KText(
            mainAxisSize: MainAxisSize.min,
            text: "Please wait loading...",
            textColor: ThemeColors.gray2,
            fontSize: 24.0),
      );
    }
    return UsersListTable(
      onSmReady: setSm,
      rows: staff.map<PlutoRow>(_buildItem).toList(),
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
