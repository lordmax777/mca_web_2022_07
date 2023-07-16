import 'dart:convert';

import '../../../../manager.dart';

final class GetChecklistsAction {
  final int page;
  final int? pageSize;
  final String? filterTitle;
  final bool? filterStatus;
  final String? filterShift;
  final String? filterDate;
  final String? filterUser;

  const GetChecklistsAction({
    required this.page,
    this.pageSize,
    this.filterTitle,
    this.filterStatus,
    this.filterShift,
    this.filterDate,
    this.filterUser,
  });

  //GetApprovalsAction
  Future<Either<ChecklistFullMd, ErrorMd>> fetch(
      AppState state, GetChecklistsAction action) async {
    return await apiCall(() async {
      final Map<String, String> query = {};
      if (action.filterTitle != null) {
        query['title'] = action.filterTitle!;
      }
      if (action.filterStatus != null) {
        query['status'] = action.filterStatus!.toString();
      }
      if (action.filterShift != null) {
        query['shift'] = action.filterShift!.toLowerCase();
      }
      if (action.filterDate != null) {
        query['date'] = action.filterDate!;
      }
      if (action.filterUser != null) {
        query['user'] = action.filterUser!.toLowerCase();
      }
      // query['datetime'] = "10:50";
      logger('query $query');
      String? encodedQuery;
      if (query.isNotEmpty) {
        encodedQuery = base64.encode(utf8.encode(jsonEncode(query)));
      }

      final res = await DependencyManager.instance.apiClient.getChecklists(
          page: action.page, pageSize: action.pageSize, filters: encodedQuery);
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

final class GetChecklistImagesAction {
  final List<int> ids;

  const GetChecklistImagesAction({
    required this.ids,
  });

  Future<Either<List<ChecklistDamageImageMd>, ErrorMd>> fetch(
      AppState state, GetChecklistImagesAction action) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .getChecklistImages(id: action.ids.join(','));
      try {
        final data = res.data['images'];
        final images = data
            .map<ChecklistDamageImageMd>(
                (e) => ChecklistDamageImageMd.fromJson(e))
            .toList();
        return images;
      } catch (e) {
        Logger.e(e.toString(), tag: 'GetChecklistImagesAction');
        throw const ErrorMd(
            message: 'Error while getting images', data: null, code: null);
      }
    });
  }
}
