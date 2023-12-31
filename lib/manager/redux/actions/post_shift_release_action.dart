import 'package:mca_dashboard/manager/manager.dart';
import 'approvals_action.dart';

final class PostShiftReleaseAction {
  final int allocationId;
  final String action;
  final String? comment;

  const PostShiftReleaseAction({
    required this.allocationId,
    required this.action,
    this.comment,
  });

  //ApproveUserQualificationAction
  Future<Either<bool, ErrorMd>> fetch(
      AppState state, PostShiftReleaseAction action) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient.postShiftRelease(
        action.allocationId,
        action: action.action,
        comment: action.comment,
      );
      await appStore.dispatch(const GetApprovalsAction());
      return res.response.statusCode == 200;
    });
  }
}
