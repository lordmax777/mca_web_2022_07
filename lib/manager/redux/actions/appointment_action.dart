final class GetAppointmentAction {
  final DateTime startDate;
  final DateTime? endDate;
  final int? locationId;
  final int? userId;
  final int? shiftId;

  const GetAppointmentAction({
    required this.startDate,
    this.endDate,
    this.locationId = 0,
    this.userId = 0,
    this.shiftId = 0,
  });
}
