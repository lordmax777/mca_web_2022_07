import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../theme/theme.dart';

class ScheduleMenus {
  ScheduleMenus(this._context, this._position);

  final BuildContext _context;
  final Offset? _position;

  RelativeRect? _getPosition() {
    if (_position == null) return null;
    //Positions the menu
    final RenderBox overlay =
        Overlay.of(_context)!.context.findRenderObject() as RenderBox;
    Offset off;
    double left;
    double top;
    double right;
    double bottom;
    off = overlay.globalToLocal(_position!);
    left = off.dx;
    top = off.dy;
    right = MediaQuery.of(_context).size.width - left;
    bottom = MediaQuery.of(_context).size.height - top;
    return RelativeRect.fromLTRB(left, top, right, bottom);
  }

  Future<T?> showMoreAppointmentsPopup<T>(
    CalendarTapDetails calendarTapDetails,
  ) async {
    final List<Appointment> appointments = (calendarTapDetails.appointments
            ?.map((e) => e as Appointment)
            .toList()) ??
        <Appointment>[];
    if (_position == null) return null;
    if (appointments.isEmpty || appointments.length < 3) return null;
    logger(appointments.length);
    final RelativeRect pos = _getPosition()!;
    final List<PopupMenuItem<Appointment>> items = [];
    for (int i = 2; i < appointments.length; i++) {
      //Get all the hidden appointments
      final Appointment app = appointments[i];
      items.add(PopupMenuItem(
        value: app,
        child: Text(app.subject),
      ));
    }
    final resultFromAppointmentTap = await showMenu<Appointment>(
      context: _context,
      position: pos,
      items: items,
    );
    if (resultFromAppointmentTap == null) return null;
    return showMenu(context: _context, position: pos, items: [
      // PopupMenuItem(
      //   value: ,
      //   child: Text(res.subject + "1"),
      // ),
    ]);
  }
}
