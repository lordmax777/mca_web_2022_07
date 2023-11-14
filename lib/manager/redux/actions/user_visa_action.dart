final class GetUserVisasAction {
  final int userId;

  const GetUserVisasAction(this.userId);
}

final class PostUserVisaAction {
  final int userId;
  final int? visaId;
  final int typeId;
  final bool hasExpireDate;
  final DateTime endDate;
  final DateTime startDate;
  final String documentNumber;
  final String? notes;

  const PostUserVisaAction(
    this.userId, {
    this.visaId,
    required this.typeId,
    required this.documentNumber,
    required this.hasExpireDate,
    required this.endDate,
    required this.startDate,
    this.notes,
  });
}

final class DeleteUserVisaAction {
  final int userId;
  final int visaId;

  const DeleteUserVisaAction(this.userId, this.visaId);
}
