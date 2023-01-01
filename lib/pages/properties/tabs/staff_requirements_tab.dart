import 'package:mca_web_2022_07/manager/models/location_item_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../manager/models/locations_md.dart';
import '../../../manager/models/property_md.dart';
import '../../../theme/theme.dart';

class PropertyStaffReqTab extends StatefulWidget {
  final PropertiesMd property;

  const PropertyStaffReqTab(this.property, {Key? key}) : super(key: key);

  @override
  State<PropertyStaffReqTab> createState() => _PropertyStaffReqTabState();
}

class _PropertyStaffReqTabState extends State<PropertyStaffReqTab> {
  final List<Members> members = [];

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

  @override
  void initState() {
    super.initState();
    _handleDaysTab();
  }

  void _handleDaysTab() {
    final locId = widget.property.locationId ?? -1;
    if (locId != -1) {
      final users = [...appStore.state.generalState.locationItems.data ?? []];
      for (final user in users) {
        if (user.id == locId) {
          members.addAll(user.members ?? []);
        }
      }
    }
  }

  late PlutoGridStateManager gridStateManager;
  bool _isSmLoaded = false;

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    _isSmLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return Center(
          child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: KText(
          text: 'No Staff Requirements',
          fontSize: 18.0,
          mainAxisSize: MainAxisSize.min,
          fontWeight: FWeight.medium,
          textColor: ThemeColors.gray2,
        ),
      ));
    }
    return UsersListTable(
      onSmReady: setSm,
      rows: members.map<PlutoRow>(_buildItem).toList() ?? [],
      cols: columns(),
    );
  }

  PlutoRow _buildItem(Members e) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: e.name ?? "-"),
      "staff_num": PlutoCell(value: e.min ?? 0),
      "max_staff": PlutoCell(value: e.max ?? 0),
    });
  }
}
