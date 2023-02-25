import 'package:collection/collection.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/models/auth.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../app.dart';
import '../../../theme/theme.dart';
import '../../hive.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../../talker_controller.dart';
import '../sets/state_value.dart';
import '../states/auth_state.dart';

class ScheduleMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case SCDragEndAction:
        return _onDragEnd(store.state.scheduleState, action, next);
      default:
        return next(action);
    }
  }

  void _onDragEnd(
      ScheduleState state, SCDragEndAction action, NextDispatcher next) {
    final appointmentDragEndDetails = action.details;
    final appointments = state.shifts;
    final interval = state.interval;

    final appointment = appointmentDragEndDetails.appointment as Appointment;
    if (appointment.startTime.minute % interval != 0) {
      final found = appointments.firstWhereOrNull((element) =>
          element.id ==
          (appointmentDragEndDetails.appointment as Appointment).id);
      if (found == null) return;
      found.startTime = appointment.startTime
          .subtract(Duration(minutes: appointment.startTime.minute % interval));
      found.endTime = appointment.endTime
          .subtract(Duration(minutes: appointment.endTime.minute % interval));
      next(UpdateScheduleState());
    }
  }
}
