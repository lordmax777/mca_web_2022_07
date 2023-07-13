import 'package:either_dart/either.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_dashboard/utils/utils.dart';

import '../../../../manager.dart';

final class GetChecklistsAction {
  final int page;

  const GetChecklistsAction({
    required this.page,
  });

  //GetApprovalsAction
  Future<Either<ChecklistFullMd, ErrorMd>> fetch(
      AppState state, GetChecklistsAction action) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .getChecklists(page: action.page);
      try {
        final data = ChecklistFullMd.fromJson(res.data);
        appStore.dispatch(UpdateGeneralState(checklists: data));
        return data;
      } catch (e) {
        Logger.e(e.toString(), tag: 'GetChecklistsAction');
        return const ChecklistFullMd.init();
      }
    });
  }
}
