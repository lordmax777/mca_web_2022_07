final class GetApprovalsAction {
  const GetApprovalsAction();
}

final class ApproveRequestAction {
  final int id;

  ///If true then approve else reject
  final bool isAccept;
  final String? comment;

  const ApproveRequestAction(this.id, this.isAccept, {this.comment});
}
