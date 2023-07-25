import 'package:mca_dashboard/manager/manager.dart';

class GetListsAction {
  const GetListsAction();
}

class GetLanguagesAction with ActionMixin<List<LanguageMd>> {
  const GetLanguagesAction();

  @override
  Future<Either<List<LanguageMd>, ErrorMd>> fetch(AppState state) {
    return apiCall(() async {
      try {
        final res = await DependencyManager.instance.apiClient.getLanguages();
        final List<LanguageMd> data = res.data['languages']
            .map<LanguageMd>((e) => LanguageMd.fromJson(e))
            .toList();
        appStore.dispatch(UpdateGeneralState(languages: data));
        return data;
      } catch (e) {
        return [];
      }
    });
  }
}
