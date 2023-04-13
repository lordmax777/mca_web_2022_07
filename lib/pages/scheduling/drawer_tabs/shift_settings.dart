import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';

import '../../../theme/theme.dart';
import '../schdule_appointment_drawer.dart';

class ScheduleShiftSettingsTab extends StatefulWidget {
  final AppState state;
  final List<CustomProperty> selectedProperties;
  final List<PropertiesMd> allProperties;
  final List<UserRes> allUsers;
  final CustomProperty selectedProperty;

  const ScheduleShiftSettingsTab({
    Key? key,
    required this.state,
    required this.selectedProperty,
    required this.selectedProperties,
    required this.allProperties,
    required this.allUsers,
  }) : super(key: key);

  @override
  State<ScheduleShiftSettingsTab> createState() =>
      _ScheduleShiftSettingsTabState();
}

class _ScheduleShiftSettingsTabState extends State<ScheduleShiftSettingsTab> {
  List<CustomProperty> get selectedProperties => widget.selectedProperties;

  List<PropertiesMd> get allProperties => widget.allProperties;

  List<UserRes> get allUsers => widget.allUsers;

  ScheduleState get scheduleState => widget.state.scheduleState;

  bool get isUserView => scheduleState.sidebarType == SidebarType.user;

  @override
  Widget build(BuildContext context) {
    logger('selectedProperties ${widget.selectedProperty.toJson()}');
    if (selectedProperties.isEmpty) {
      return const Center(
        child: Text(
          'Please select a property to view shift settings',
          style: TextStyle(fontSize: 20),
        ),
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * (0.59),
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Colors.black12,
        ),
        itemBuilder: _itemBuilder,
        itemCount: selectedProperties.length,
      ),
    );
  }

  Widget _itemBuilder(context, index) {
    final _pr = selectedProperties[index];
    final property = allProperties
        .firstWhereOrNull((element) => element.id == _pr.propertyId);
    final user =
        allUsers.firstWhereOrNull((element) => element.id == _pr.userId);
    logger('$isUserView ');
    if (isUserView) {
      return ExpandableItemWidget(
          title: property!.title.toString(), child: Container());
    }
    if (!isUserView) {
      return ExpandableItemWidget(
          title: user!.fullname.toString(), child: Container());
    }
    return SizedBox();
  }
}
