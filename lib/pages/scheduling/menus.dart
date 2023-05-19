import 'package:flutter/cupertino.dart';
import 'package:mca_web_2022_07/comps/simple_popup_menu.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/job_model.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../theme/theme.dart';
import 'models/allocation_model.dart';

class ScheduleMenus {
  static const int moreAppointmentCount = 4;

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

  Future<ApiResponse?> showMoreAppointmentsPopup<T>(
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
    for (int i = 0; i < appointments.length; i++) {
      //Get all the hidden appointments
      final Appointment app = appointments[i];
      items.add(PopupMenuItem(
        value: app,
        enabled: false,
        textStyle: const TextStyle(color: Colors.black),
        key: ValueKey(app),
        height: 30,
        padding: const EdgeInsets.symmetric(vertical: .5),
        child: InkWell(
          onTap: () {
            Navigator.of(_context).pop(app);
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              width: double.infinity,
              alignment: Alignment.centerLeft,
              height: 40,
              color: app.color,
              child: Text(app.subject,
                  style: TextStyle(
                      color: app.color.computeLuminance() > 0.5
                          ? Colors.black
                          : Colors.white,
                      fontFamily: ThemeText.fontFamilyM,
                      fontSize: 14))),
        ),
      ));
    }
    final resultFromAppointmentTap = await showMenu<Appointment>(
      context: _context,
      position: pos,
      items: items,
    );
    if (resultFromAppointmentTap == null) return null;
    return await showFormActionsPopup(calendarTapDetails);
  }

  Future<ApiResponse?> showFormActionsPopup(
      CalendarTapDetails calendarTapDetails) async {
    final Appointment? appointment =
        calendarTapDetails.appointments?.first as Appointment?;
    final DateTime? stDate = calendarTapDetails.date;
    return await showFormsMenus(
      _context,
      globalPosition: _position!,
      data: JobModel(
        customStartDate: stDate,
        customEndDate: stDate?.add(const Duration(hours: 1)),
        customResource: appointment == null
            ? null
            : CalendarResource(id: appointment.resourceIds!.first),
        allocation: appointment?.id as AllocationModel?,
      ),
    );
  }
}
