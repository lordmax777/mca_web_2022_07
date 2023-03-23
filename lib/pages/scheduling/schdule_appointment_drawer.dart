import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../manager/models/shift_md.dart';
import '../../manager/redux/sets/app_state.dart';

import '../../theme/theme.dart';

class AppointmentDrawer extends StatelessWidget {
  final Appointment appointment;
  const AppointmentDrawer({Key? key, required this.appointment})
      : super(key: key);

  AppointmentIdMd get appid => appointment.id as AppointmentIdMd;
  PropertiesMd get props => appid.property;
  UserRes get userRes => appid.user;
  ShiftMd get shift => appid.allocation;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 640,
        backgroundColor: ThemeColors.white,
        elevation: 0.8,
        child: StoreConnector<AppState, ScheduleState>(
          converter: (store) => store.state.scheduleState,
          builder: (context, state) {
            final isUserView = state.sidebarType == SidebarType.user;
            return SpacedColumn(
              children: [
                _date(),
                // _resource(),
              ],
            );
          },
        ));
  }

  EdgeInsets get _paddingX => const EdgeInsets.symmetric(horizontal: 16);
  EdgeInsets get _paddingH => const EdgeInsets.symmetric(vertical: 16);
  EdgeInsets get _paddingXH => const EdgeInsets.all(16);

  Widget _date() {
    return Padding(
      padding: _paddingXH,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KText(
            text: "Date",
            textColor: ThemeColors.black,
          ),
          HeroIcon(
            HeroIcons.x,
            size: 24,
          )
        ],
      ),
    );
  }
}
