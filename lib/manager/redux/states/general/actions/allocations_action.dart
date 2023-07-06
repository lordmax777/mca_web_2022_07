final class GetAllocationsAction {
  final DateTime date;
  final DateTime? until;
  final int? locationId;
  final int? userId;
  final int? shiftId;

  const GetAllocationsAction({
    required this.date,
    this.until,
    this.locationId = 0,
    this.userId = 0,
    this.shiftId = 0,
  });
}
