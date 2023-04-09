import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/models/shift_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../../theme/theme.dart';

class ScheduleShiftSettingsTab extends StatefulWidget {
  final List<ShiftMd> selectedShifts;
  final AppState state;

  const ScheduleShiftSettingsTab({
    Key? key,
    required this.selectedShifts,
    required this.state,
  }) : super(key: key);

  @override
  State<ScheduleShiftSettingsTab> createState() =>
      _ScheduleShiftSettingsTabState();
}

class _ScheduleShiftSettingsTabState extends State<ScheduleShiftSettingsTab> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
