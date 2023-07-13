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

final class GetChecklistPdfAction {
  final List<int> ids;

  const GetChecklistPdfAction({
    required this.ids,
  });

  Future<Either<String, ErrorMd>> fetch(
      AppState state, GetChecklistPdfAction action) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .getChecklistPdfs(id: action.ids.join(','));
      try {
        final data = res.data['data'];
        return data;
      } catch (e) {
        Logger.e(e.toString(), tag: 'GetChecklistPdfAction');
        throw const ErrorMd(
            message: 'Error while downloading pdf', data: null, code: null);
      }
    });
  }
}
