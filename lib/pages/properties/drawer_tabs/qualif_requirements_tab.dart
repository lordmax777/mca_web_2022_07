import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import '../../../manager/models/property_md.dart';
import '../../../theme/theme.dart';

class PropertyQualifReqTab extends StatelessWidget {
  final PropertiesMd property;

  PropertyQualifReqTab(this.property, {Key? key}) : super(key: key);

  final List<ShiftQualifReqMd> qualifs = [];

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
        title: "Number Of Staff",
        field: "staff_num",
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
        final List<ShiftQualifReqMd> res =
            await GetPropertiesAction.fetchShiftQualif(shiftId);
        qualifs.addAll(res);
      } catch (e) {
        gridStateManager.setShowLoading(false);
      } finally {
        gridStateManager.setShowLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return UsersListTable(
      onSmReady: setSm,
      rows: qualifs.map<PlutoRow>(_buildItem).toList(),
      cols: columns(),
    );
  }

  PlutoRow _buildItem(ShiftQualifReqMd e) {
    return PlutoRow(cells: {
      'name': PlutoCell(value: e.qualificationName),
      'min_level': PlutoCell(value: e.levelName),
      'staff_num': PlutoCell(value: e.numberOfStaff),
    });
  }
}
