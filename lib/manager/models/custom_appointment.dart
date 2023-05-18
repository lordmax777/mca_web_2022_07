import 'package:mca_web_2022_07/pages/scheduling/models/allocation_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomAppointmentMd extends Appointment {
  CustomAppointmentMd(
      {required super.startTime, required super.endTime, this.id});

  final AllocationModel? id;
}
