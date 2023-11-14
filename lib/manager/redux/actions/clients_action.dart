import '../../manager.dart';

class GetClientsAction {
  const GetClientsAction();
}

class DeleteClientAction {
  final int id;

  const DeleteClientAction(this.id);

  Future<Either<bool, ErrorMd>> fetch(AppState state) async {
    return await apiCall(() async {
      final res = await DependencyManager.instance.apiClient.deleteClient(id);
      return res.response.statusCode == 200;
    });
  }
}
