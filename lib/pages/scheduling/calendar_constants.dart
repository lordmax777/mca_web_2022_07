import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

abstract class CalendarConstants {
  static double fullHeight(BuildContext context) =>
      MediaQuery.of(context).size.height - 80;

  static double tableHeight(BuildContext context) =>
      MediaQuery.of(context).size.height - 146;

  static const double resourceWidth = 120;

  static const double shiftHeight = 50;

  static double shiftWidth(BuildContext context) =>
      (MediaQuery.of(context).size.width - resourceWidth) * .0409;

  static int resourceCount(BuildContext context) =>
      (tableHeight(context) / (shiftHeight * 3)).ceil();

  static Color openShiftAppointmentColor = Colors.blueGrey;

  static CalendarResource openCalendarResource = CalendarResource(
    id: "OPEN",
    displayName: "Open Shift",
    color: CalendarConstants.openShiftAppointmentColor,
  );
}
