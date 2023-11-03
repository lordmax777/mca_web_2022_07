import '../../../../manager.dart';

class GetJobTemplatesAction {
  final int? id;

  const GetJobTemplatesAction({this.id});

  Future<Either<List<JobTemplateMd>, ErrorMd>> fetch(AppState state) async {
    return await apiCall(() async {
      final res =
          await DependencyManager.instance.apiClient.getJobTemplates(id ?? 0);
      if (res.response.statusCode == 200) {
        final data = res.data['jobtemplates'] as List<dynamic>;
        final jobTemplates =
            data.map((e) => JobTemplateMd.fromJson(e)).toList();
        appStore.dispatch(UpdateGeneralState(jobTemplates: jobTemplates));
        return jobTemplates;
      }
      return [];
    });
  }
}
