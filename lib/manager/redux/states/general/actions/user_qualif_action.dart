final class GetUserQualifAction {
  final int userId;

  const GetUserQualifAction(this.userId);
}

final class PostUserQualifAction {
  final int userId;
  final int? userQualifId;
  final int qualifId;
  final int levelId;
  final DateTime achievementDate;
  final String? comment;
  final DateTime? expiryDate;
  final String certificateNumber;
  final List<int>? certificateBytes;

  const PostUserQualifAction({
    required this.userId,
    this.userQualifId,
    required this.qualifId,
    required this.levelId,
    required this.achievementDate,
    this.comment,
    this.expiryDate,
    this.certificateBytes,
    required this.certificateNumber,
  });
}

final class DeleteUserQualifAction {
  final int userId;
  final int userQualifId;

  const DeleteUserQualifAction(
      {required this.userId, required this.userQualifId});
}

final class ApproveUserQualificationAction {
  final int userQualificationId;
  final int userId;

  const ApproveUserQualificationAction({
    required this.userQualificationId,
    required this.userId,
  });
}
