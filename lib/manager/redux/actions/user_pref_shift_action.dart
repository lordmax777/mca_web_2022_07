final class GetUserPrefShiftsAction {
  final int userId;
  const GetUserPrefShiftsAction(this.userId);
}

final class PostUserPrefShiftsAction {
  final int userId;
  final int shiftId;
  final int dayId;
  final int weekId;
  final int? timingId;

  const PostUserPrefShiftsAction(
    this.userId, {
    required this.shiftId,
    required this.dayId,
    required this.weekId,
    this.timingId,
  });
}

final class DeleteUserPrefShiftsAction {
  final int userId;
  final int timingid;
  const DeleteUserPrefShiftsAction(this.userId, this.timingid);
}
