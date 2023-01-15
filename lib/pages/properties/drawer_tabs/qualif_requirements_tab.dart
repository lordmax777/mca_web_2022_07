import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import '../../../theme/theme.dart';

class PropertyQualifReqTab extends StatefulWidget {
  final PropertiesMd property;

  PropertyQualifReqTab(this.property, {Key? key}) : super(key: key);

  @override
  State<PropertyQualifReqTab> createState() => _PropertyQualifReqTabState();
}

class _PropertyQualifReqTabState extends State<PropertyQualifReqTab> {
  bool isLoading = false;
  List<PlutoColumn> columns() {
    return [
      PlutoColumn(
        width: 320.0,
        title: "Qualification",
        field: "name",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Minimum Level",
        field: "min_level",
        width: 160.0,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Number of Staff",
        field: "staff_num",
        width: 160.0,
        type: PlutoColumnType.number(),
      ),
    ];
  }

  final List<ShiftQualifReqMd> staff = [];

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
      setState(() {
        isLoading = true;
      });
      if (shiftId != -1) {
        List<ShiftQualifReqMd> res =
            await GetPropertiesAction.fetchShiftQualif(shiftId);
        staff.addAll(res);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: KText(
            mainAxisSize: MainAxisSize.min,
            text: "Please wait loading...",
            textColor: ThemeColors.gray2,
            fontSize: 24.0),
      );
    } else if (staff.isEmpty) {
      return Center(
        child: KText(
            mainAxisSize: MainAxisSize.min,
            text: "No Qualification",
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

  PlutoRow _buildItem(ShiftQualifReqMd e) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: e.qualificationName),
      "min_level": PlutoCell(value: e.levelName),
      "staff_num": PlutoCell(value: e.numberOfStaff),
    });
  }
}
