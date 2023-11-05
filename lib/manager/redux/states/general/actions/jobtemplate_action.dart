import 'package:dio/dio.dart';

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

class SaveJobTemplateAction {
  int? id;
  final String name;
  final bool active;
  final int? clientId;
  final String? comment;
  final List<JobTemplateItemMd> items;

  SaveJobTemplateAction({
    this.id,
    required this.name,
    this.comment,
    required this.active,
    this.clientId,
    required this.items,
  }) {
    id = id ?? 0;
  }

  Future<Either<int, ErrorMd>> fetch(AppState state) async {
    return await apiCall(() async {
      final Dio apiClient = DependencyManager.instance.dioClient.dio
        ..options.contentType = "multipart/form-data";

      final FormData formData = FormData();
      formData.fields.add(MapEntry("name", name));
      formData.fields.add(MapEntry("active", active.toString()));
      if (clientId != null) {
        formData.fields.add(MapEntry("client_id", clientId.toString()));
      }
      if (comment != null) {
        formData.fields.add(MapEntry("comment", comment!));
      }
      formData.fields.add(MapEntry("number_of_items", items.length.toString()));
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        formData.fields.add(MapEntry("item_id_$i", item.itemId.toString()));
        formData.fields.add(MapEntry("price_$i", item.price.toString()));
        formData.fields.add(MapEntry("quantity_$i", item.quantity.toString()));
        formData.fields.add(MapEntry("comment_$i", item.comment.toString()));
        formData.fields.add(MapEntry("combine_$i", item.combine.toString()));
      }
      logger(
          "FormData: ${formData.fields.map((e) => "${e.key}: ${e.value}").toList()}",
          hint: "FormData fields <->");

      Response res =
          await apiClient.post('/api/fe/jobtemplates/$id', data: formData);
      return res.data;
    });
  }
}
