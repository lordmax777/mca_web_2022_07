import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mca_dashboard/manager/redux/actions/fetch_lists_action.dart';
import 'package:mca_dashboard/manager/redux/actions/quotes_action.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';

import '../../manager.dart';

final class PostQuoteAction {
  final PersonalData personalData;
  final AddressData addressData;
  final AddressData? workAddressData;
  final TimeData timingData;
  final TeamData teamData;
  final GuestData guestData;
  final QuoteData quoteData;
  final ProductData productData;
  final bool isQuote;

  const PostQuoteAction({
    required this.personalData,
    required this.addressData,
    required this.workAddressData,
    required this.timingData,
    required this.teamData,
    required this.guestData,
    required this.quoteData,
    required this.productData,
    required this.isQuote,
  });
}

class PostQuoteAction2 {
  final int? quoteId;
  final String? jobTitle;
  final ClientMd client;
  AddressMd get invoiceAddress => client.address;
  final LocationMd workLocation;
  AddressMd get workAddress => workLocation.address;
  final String? quoteComment;
  final List<UserMd>? team;
  final DateTime? workStartDate;
  final DateTime? workStartTime;
  final DateTime? workEndTime;
  final String? repeatId;
  final List<String>? week1;
  final List<String>? week2;
  final DateTime? repeatUntilDate;
  final String? packageName;
  final String? checklistTemplateId;
  final ProductData products;
  final bool? active;
  final String? workLocationId;

  PostQuoteAction2({
    required this.jobTitle,
    required this.client,
    required this.workLocation,
    required this.quoteComment,
    required this.products,
    this.quoteId,
    this.team,
    this.active = true,
    this.workStartDate,
    this.workStartTime,
    this.workEndTime,
    this.repeatId,
    this.week1,
    this.week2,
    this.repeatUntilDate,
    this.packageName,
    this.checklistTemplateId,
    this.workLocationId,
  });

  final deps = DependencyManager.instance;
  Future<Either<int?, ErrorMd>> call(AppState state) async {
    return await apiCall(() async {
      final Dio apiClient = deps.dioClient.dio
        ..options.contentType = "multipart/form-data";
      final FormData formData = FormData();

      //Job Title
      String? jobName;
      if (jobTitle != null && jobTitle!.isNotEmpty) {
        jobName = jobTitle;
      } else {
        final workAddress =
            "${workLocation.address.line1}, ${workLocation.address.city}, ${workLocation.address.postcode}, ${workLocation.address.getCountryMd(state.generalState.lists.countries)?.name}";
        final firstProduct =
            products.items(state.generalState.storageItems).first.name;
        final clientName = client.name;
        jobName = "$workAddress - $firstProduct - $clientName";
      }
      if (jobName!.length > 20) {
        jobName = jobName.substring(0, 20);
      }
      formData.fields.add(MapEntry("name", jobName));

      //client_id
      formData.fields.add(MapEntry("client_id", client.id.toString()));
      //company
      if (client.company != null) {
        formData.fields.add(MapEntry("company", client.company!));
      }
      //email
      if (client.email != null) {
        formData.fields.add(MapEntry("email", client.email!));
      }
      //phone
      if (client.phone != null) {
        formData.fields.add(MapEntry("phone", client.phone!));
      }
      //notes
      if (client.notes.isNotEmpty) {
        formData.fields.add(MapEntry("notes", client.notes));
      }
      //Invoice address
      if (invoiceAddress.line1.isNotEmpty) {
        formData.fields.add(MapEntry("addressLine1", invoiceAddress.line1));
      }
      if (invoiceAddress.line2.isNotEmpty) {
        formData.fields.add(MapEntry("addressLine2", invoiceAddress.line2));
      }
      if (invoiceAddress.city.isNotEmpty) {
        formData.fields.add(MapEntry("addressCity", invoiceAddress.city));
      }
      if (invoiceAddress.county.isNotEmpty) {
        formData.fields.add(MapEntry("addressCounty", invoiceAddress.county));
      }
      if (invoiceAddress.postcode.isNotEmpty) {
        formData.fields
            .add(MapEntry("addressPostcode", invoiceAddress.postcode));
      }
      if (invoiceAddress.country.isNotEmpty) {
        formData.fields.add(MapEntry("addressCountry", invoiceAddress.country));
      }
      //Work address
      formData.fields.add(MapEntry("location_id", workLocation.id.toString()));
      if (workAddress.line1.isNotEmpty) {
        formData.fields.add(MapEntry("workAddressLine1", workAddress.line1));
      }
      if (workAddress.line2.isNotEmpty) {
        formData.fields.add(MapEntry("workAddressLine2", workAddress.line2));
      }
      if (workAddress.city.isNotEmpty) {
        formData.fields.add(MapEntry("workAddressCity", workAddress.city));
      }
      if (workAddress.county.isNotEmpty) {
        formData.fields.add(MapEntry("workAddressCounty", workAddress.county));
      }
      if (workAddress.postcode.isNotEmpty) {
        formData.fields
            .add(MapEntry("workAddressPostcode", workAddress.postcode));
      }
      if (workAddress.country.isNotEmpty) {
        formData.fields
            .add(MapEntry("workAddressCountry", workAddress.country));
      }
      if (workAddress.latitude != null) {
        formData.fields.add(
            MapEntry("workLocationLatitude", workAddress.latitude.toString()));
      }
      if (workAddress.longitude != null) {
        formData.fields.add(MapEntry(
            "workLocationLongitude", workAddress.longitude.toString()));
      }
      if (workAddress.radius != null) {
        formData.fields
            .add(MapEntry("workLocationRadius", workAddress.radius.toString()));
      }
      if (workLocation.ipaddress.isNotEmpty) {
        formData.fields.add(MapEntry("workStaticIpAddresses",
            workLocation.ipaddress.map((e) => e.ipAddress).join(",")));
      }

      //CurrencyId
      if (client.currencyId != null) {
        formData.fields.add(MapEntry("currencyId", client.currencyId!));
      }
      //payment method id
      if (client.paymentMethodId != null) {
        formData.fields
            .add(MapEntry("paymentMethodId", client.paymentMethodId!));
      }
      //paying days
      formData.fields.add(MapEntry("payingDays", client.payingDays.toString()));
      //Work start date
      if (workStartDate != null) {
        formData.fields
            .add(MapEntry("workStartDate", workStartDate!.toApiDateWithSlash));
      }
      //Work start time
      if (workStartTime != null) {
        formData.fields
            .add(MapEntry("workStartTime", workStartTime!.toApiTime));
      }
      //Work end time
      if (workEndTime != null) {
        formData.fields.add(MapEntry("workFinishTime", workEndTime!.toApiTime));
      }
      //Work repeat id
      formData.fields.add(MapEntry("repeatId", repeatId ?? "1"));

      //Work repeat week1
      if (week1 != null) {
        formData.fields
            .add(MapEntry('workDays', WeekDaysMd.fromList(week1!).week1Str));

        if (week2 != null) {
          formData.fields
              .add(MapEntry('workDays2', WeekDaysMd.fromList(week2!).week2Str));
        }
      }
      //active
      formData.fields
          .add(MapEntry("active", active?.toString() ?? true.toString()));
      //repeatUntilDate //todo: after imre adds to api, recheck the name
      if (repeatUntilDate != null) {
        formData.fields
            .add(MapEntry("repeatUntilDate", repeatUntilDate!.toApiDateTime));
      }
      //quoteComments
      if (quoteComment != null) {
        formData.fields.add(MapEntry("quoteComments", quoteComment!));
      }
      //products
      for (int i = 0;
          i < products.items(state.generalState.storageItems).length;
          i++) {
        final item = products.items(state.generalState.storageItems)[i];

        formData.fields.add(MapEntry('quoteItem_$i', item.id.toString()));
        formData.fields
            .add(MapEntry('quoteQuantity_$i', item.quantity.toString()));
        formData.fields
            .add(MapEntry('quotePrice_$i', item.outgoingPrice.toString()));
        formData.fields.add(MapEntry('quoteAuto_$i', item.auto.toString()));
      }
      //team
      if (team != null && team!.isNotEmpty) {
        ///[
        ///"user_id": 1,
        ///"special_rate": 0.5,
        ///"special_start_time": "09:00",
        ///"special_finish_time": "09:00",
        /// ]
        final teamList = team!
            .map((e) => {
                  "user_id": e.id,
                  "special_rate": e
                      .specialPrice, //todo: need to be id which actually is selected from dp. ask imre to add this
                  "special_start_time": e.specialStartTime?.toApiTime,
                  "special_finish_time": e.specialFinishTime?.toApiTime,
                }..removeWhere((key, value) => value == null))
            .toList();

        formData.fields.add(MapEntry('user_ids',
            "[${teamList.map((e) => jsonEncode(e)).toList().join(",")}]"));
      }
      //package name
      if (packageName != null) {
        formData.fields.add(MapEntry("jobTemplateName", packageName!));
      }
      //discount //todo: get answer on chat
      // if (client.discount != null) {
      //   formData.fields.add(MapEntry("discount", client.discount.toString()));
      // }
      //checklist template id
      if (checklistTemplateId != null) {
        formData.fields
            .add(MapEntry("checklist_template_id", checklistTemplateId!));
      }

      formData.fields.removeWhere((element) => element.value == "null");

      logger(
          "FormData: ${formData.fields.map((e) => "${e.key}: ${e.value}").toList()}");

      Response res = await apiClient.post('/api/fe/quotes/${quoteId ?? 0}',
          data: formData);

      await Future.wait([
        appStore.dispatch(const GetListsAction()) as Future,
        appStore.dispatch(const GetQuotesAction()) as Future,
      ]);
      return res.data;
    });
  }
}

class MakeJobFromQuoteAction {
  final int quoteId;
  final DateTime? date;

  const MakeJobFromQuoteAction({
    required this.quoteId,
    this.date,
  });

  Future<Either<int?, ErrorMd>> call(AppState state) {
    return apiCall(() async {
      final res = await DependencyManager.instance.apiClient
          .makeJobFromQuote(quoteId, date: date?.toApiDateWithDash);
      if (res.response.statusCode == 200) {
        if (res.data is num) {
          return res.data;
        }
      }
      return null;
    });
  }
}
