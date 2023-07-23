import 'package:flutter/material.dart';
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

final class CreateAccountUserAvailabilityAction with ActionMixin<bool> {
  final DateTime startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final bool isFullDay;
  final String? comment;

  const CreateAccountUserAvailabilityAction({
    required this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    required this.isFullDay,
    this.comment,
  });

  @override
  fetch(AppState state) {
    return apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .createAccountUserAvailability(
        startDate: startDate.toApiDateWithDash,
        isFullDay: isFullDay,
        comment: comment,
        startTime: startTime?.toApiTime,
        endDate: endDate?.toApiDateWithDash,
        endTime: endTime?.toApiTime,
      );
      return res.response.statusCode == 200;
    });
  }
}

final class ChangeAccountPasswordAction with ActionMixin<bool> {
  final String oldPassword;
  final String newPassword;

  const ChangeAccountPasswordAction({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  Future<Either<bool, ErrorMd>> fetch(AppState state) {
    return apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .changeAccountPassword(
              oldPassword: oldPassword, newPassword: newPassword);
      return res.response.statusCode == 200;
    });
  }
}

//change account language
final class ChangeAccountLanguageAction with ActionMixin<bool> {
  final String language;

  const ChangeAccountLanguageAction(this.language);

  @override
  Future<Either<bool, ErrorMd>> fetch(AppState state) {
    return apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .changeAccountLanguage(locale: language);
      await appStore.dispatch(const GetDetailsAction());
      return res.response.statusCode == 200;
    });
  }
}
