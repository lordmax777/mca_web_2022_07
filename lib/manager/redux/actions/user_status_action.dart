final class GetUserStatusAction {
  final int userId;

  const GetUserStatusAction({required this.userId});
}

final class PostUserStatusAction {
  final int userId;
  final int statusId;
  final int shiftId;
  final int locationId;
  final String? comments;

  const PostUserStatusAction(
      {required this.userId,
      required this.statusId,
      required this.shiftId,
      required this.locationId,
      this.comments});
}

final class GetUserMobileAction {
  final int userId;

  const GetUserMobileAction({required this.userId});
}

final class DeleteUserMobileAction {
  final int userId;

  const DeleteUserMobileAction({required this.userId});
}
