import 'package:mca_dashboard/manager/manager.dart';

final class GetAccountUserAvailabilityAction
    with ActionMixin<List<AccountAvailabilityMd>> {
  final String id;

  const GetAccountUserAvailabilityAction(this.id);

  @override
  fetch(AppState state) {
    return apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .getAccountUserAvailability(id);
      try {
        final data = res.data;
        return data
            .map<AccountAvailabilityMd>(
                (e) => AccountAvailabilityMd.fromJson(e))
            .toList();
      } catch (e) {
        return [];
      }
    });
  }
}

final class DeleteAccountUserAvailabilityAction with ActionMixin<bool> {
  final String id;

  const DeleteAccountUserAvailabilityAction(this.id);

  @override
  fetch(AppState state) {
    return apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .deleteAccountUserAvailability(id);
      return res.response.statusCode == 200;
    });
  }
}
