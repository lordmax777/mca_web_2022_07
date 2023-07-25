import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';

final class GetCompanyInfoAction {
  const GetCompanyInfoAction();
}

final class GetAccountUserAvailabilityAction
    with ActionMixin<List<AccountAvailabilityMd>> {
  const GetAccountUserAvailabilityAction();

  @override
  fetch(AppState state) {
    return apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .getAccountUserAvailability();
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
  final DateTime date;

  const DeleteAccountUserAvailabilityAction(this.date);

  @override
  fetch(AppState state) {
    return apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .deleteAccountUserAvailability(date.toApiDateWithDash);
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
        endDate: endDate!.toApiDateWithDash,
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

//SaveCompanyDetailsAction
final class SaveCompanyDetailsAction with ActionMixin<bool> {
  final String? companyName;
  final String? companyEmail;
  final int? annualHolidayEntitlement;
  final String? timezone;
  final int? currencyId;
  final String? logo;
  final int? rotaLength;
  final int? autoLogoutTime;
  final int? lockingTime;
  final int? autoSignOutTime;
  final int? timeValidity;
  final int? maxAttempts;
  final int? colorSchemaId;
  final int? annualHolidayEntitlementWeeks;
  final int? holidayCalculationType;
  final String? yearStart;
  final int? paidSickness;
  final int? periodOfIncapacity;
  final int? minRest;
  final int? lunchtime;
  final int? lunchtimeUnpaid;
  final int? rounding;
  final int? gracePeriod;
  final int? breaks;
  final int? breakTime;
  final int? breakTimeTotal;
  final int? minHoursForLunch;
  final String? lateReminders;
  final String? longBreakReminders;
  final String? signOutReminders;
  final bool? isPhotoRequired;
  final bool? isStrictLocation;
  final int? undoTime;
  final String? locale;
  final bool? status;
  final bool? showTitle;

  const SaveCompanyDetailsAction({
    this.locale,
    this.status,
    this.showTitle,
    this.companyName,
    this.companyEmail,
    this.annualHolidayEntitlement,
    this.timezone,
    this.currencyId,
    this.logo,
    this.rotaLength,
    this.autoLogoutTime,
    this.lockingTime,
    this.autoSignOutTime,
    this.timeValidity,
    this.maxAttempts,
    this.colorSchemaId,
    this.annualHolidayEntitlementWeeks,
    this.holidayCalculationType,
    this.yearStart,
    this.paidSickness,
    this.periodOfIncapacity,
    this.minRest,
    this.lunchtime,
    this.lunchtimeUnpaid,
    this.rounding,
    this.gracePeriod,
    this.breaks,
    this.breakTime,
    this.breakTimeTotal,
    this.minHoursForLunch,
    this.lateReminders,
    this.longBreakReminders,
    this.signOutReminders,
    this.isPhotoRequired,
    this.isStrictLocation,
    this.undoTime,
  });

  @override
  Future<Either<bool, ErrorMd>> fetch(AppState state) {
    final companyInfo = state.generalState.companyInfo;
    return apiCall(() async {
      final res = await DependencyManager.instance.apiClient.postCompanyDetails(
        companyName: companyName ?? companyInfo.name,
        domain: companyInfo.domain,
        companyEmail: companyEmail ?? companyInfo.companyEmail,
        annualHolidayEntitlement:
            annualHolidayEntitlement ?? companyInfo.ahe.toInt(),
        timezone: timezone ?? companyInfo.timezone,
        logo: logo ?? companyInfo.logo,
        rotaLength: rotaLength ?? companyInfo.rotalength.toInt(),
        autoLogoutTime: autoLogoutTime ?? companyInfo.autoLogout.toInt(),
        autoSignOutTime: autoSignOutTime ?? companyInfo.autoSignOut.toInt(),
        timeValidity: timeValidity ?? companyInfo.timeValidity.toInt(),
        maxAttempts: maxAttempts ?? companyInfo.maxAttempts.toInt(),
        colorSchemaId: colorSchemaId ?? companyInfo.colourSchemaId.toInt(),
        annualHolidayEntitlementWeeks:
            annualHolidayEntitlementWeeks ?? companyInfo.ahew.toInt(),
        holidayCalculationType:
            holidayCalculationType ?? companyInfo.hct.toInt(),
        yearStart: yearStart ??
            DateFormat('dd/MM/yyyy')
                .format(DateTime.parse(companyInfo.yearstart)),
        paidSickness: paidSickness ?? companyInfo.paidSickness.toInt(),
        periodOfIncapacity: periodOfIncapacity ?? companyInfo.piw.toInt(),
        minRest: minRest ?? companyInfo.minRest.toInt(),
        lunchtime: lunchtime ?? companyInfo.lunchtime.toInt(),
        lunchtimeUnpaid: lunchtimeUnpaid ?? companyInfo.lunchtimeUnpaid.toInt(),
        rounding: rounding ?? companyInfo.rounding.toInt(),
        gracePeriod: gracePeriod ?? companyInfo.grace.toInt(),
        breaks: breaks ?? companyInfo.breaks.toInt(),
        breakTime: breakTime ?? companyInfo.breakTime.toInt(),
        breakTimeTotal: breakTimeTotal ?? companyInfo.breakTimeTotal.toInt(),
        minHoursForLunch:
            minHoursForLunch ?? companyInfo.minHoursForLunch.toInt(),
        lateReminders: lateReminders ?? companyInfo.lateReminders,
        longBreakReminders:
            longBreakReminders ?? companyInfo.longBreakReminders,
        signOutReminders: signOutReminders ?? companyInfo.signOutReminders,
        isPhotoRequired: isPhotoRequired ?? companyInfo.photoRequired,
        isStrictLocation: isStrictLocation ?? companyInfo.strictLocation,
        undoTime: undoTime ?? companyInfo.undoTime.toInt(),
        locale: locale ?? companyInfo.locale,
        status: status ?? companyInfo.status,
        showTitle: showTitle ?? companyInfo.showTitle,
        lockingTime: lockingTime, //todo:
        // currencyId: currencyId ?? companyInfo.currency.id,//todo:
      );
      await appStore.dispatch(const GetCompanyInfoAction());
      return res.response.statusCode == 200;
    });
  }
}
