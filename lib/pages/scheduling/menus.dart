import 'package:flutter/cupertino.dart';
import 'package:mca_web_2022_07/comps/simple_popup_menu.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
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

  Future<bool> showMoreAppointmentsPopup(
      CalendarTapDetails calendarTapDetails) async {
    final List<Appointment> appointments = (calendarTapDetails.appointments
            ?.map((e) => e as Appointment)
            .toList()) ??
        <Appointment>[];

    if (_position == null) return false;
    if (appointments.isEmpty || appointments.length < 3) return false;

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
            margin: const EdgeInsets.symmetric(vertical: 1),
            width: double.infinity,
            alignment: Alignment.centerLeft,
            height: 40,
            decoration: BoxDecoration(
              // color: app.color,
              border: Border.all(
                color: Colors.black,
                width: .5,
              ),
            ),
            child: Text(
              app.subject,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: ThemeText.fontFamilyM,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ));
    }
    final resultFromAppointmentTap = await showMenu<Appointment>(
      context: _context,
      position: pos,
      items: items,
    );
    if (resultFromAppointmentTap == null) return false;
    final res = await showFormActionsPopup(
        resultFromAppointmentTap, calendarTapDetails.date);
    return res;
  }

  Future<bool> showFormActionsPopup(
    Appointment? appointment,
    DateTime? date, {
    Future<List<Appointment>?> Function(JobModel? createdjob)?
        onJobCreateSuccess,
    Future<void> Function()? onJobDeleteSuccess,
    CalendarResource? customResource,
  }) async {
    final DateTime? stDate = date;
    CalendarResource? resource = appointment == null
        ? customResource
        : CalendarResource(id: appointment.resourceIds!.first);

    final res = await showFormsMenus(
      _context,
      globalPosition: _position!,
      onJobCreateSuccess: onJobCreateSuccess,
      onJobDeleteSuccess: onJobDeleteSuccess,
      data: JobModel(
        customStartDate: stDate,
        customEndDate: stDate?.add(const Duration(hours: 1)),
        customResource: resource,
        allocation: appointment?.id as AllocationModel?,
      ),
    );
    return res;
  }
}
