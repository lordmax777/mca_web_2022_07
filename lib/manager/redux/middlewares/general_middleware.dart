import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/models/approval_md.dart';
import 'package:mca_web_2022_07/manager/models/approval_user_qualification_md.dart';

import 'package:mca_web_2022_07/manager/models/list_all_md.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/rest/dio_client_for_retrofit.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/deps_list_controller.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/groups_list_controller.dart';
import 'package:mca_web_2022_07/pages/handover_types/controllers/handover_controller.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/locations_controller.dart';
import 'package:mca_web_2022_07/pages/qualifications/controllers/qualifs_list_controller.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/client_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/storage_item_form.dart';
import 'package:mca_web_2022_07/pages/scheduling/popup_forms/timing_form.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:mix/mix.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:get/get.dart';
import 'package:retrofit/retrofit.dart';
import '../../../utils/global_functions.dart';
import '../../general_controller.dart';
import '../../models/inventory_md.dart';
import '../../models/location_item_md.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../sets/state_value.dart';
import '../states/general_state.dart';

import 'package:dio/dio.dart' as dio;

import '../states/schedule_state.dart';

class GeneralMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case OpenDrawerAction:
        return (action as OpenDrawerAction).call(store, action, next);
      case GetAllParamListAction:
        return _getAllParamList(store.state, action, next);
      // case GetAllLocationsAction:
      //   return GetAllLocationsAction.fetch(store.state, action, next);
      case GetWarehousesAction:
        return GetWarehousesAction.fetch(store.state, action, next);
      case GetAllStorageItemsAction:
        return GetAllStorageItemsAction.fetch(store.state, action, next);
      case GetChecklistTemplatesAction:
        return GetChecklistTemplatesAction.fetch(store.state, action, next);
      case GetPropertiesAction:
        return GetPropertiesAction.fetch(store.state, action, next);
      case GetLocationAddressesAction:
        return _getLocationAddresses(store.state, action, next);
      case GetClientInfosAction:
        return _getClientInfosAction(store.state, action, next);
      case GetQuotesAction:
        return _getQuotesAction(store.state, action, next);
      case CreateQuoteAction:
        return _createQuoteAction(store.state, action, next);
      case OnAddStorageItemAction:
        return _onAddStorageItemAction(store.state, action);
      case OnCreateNewStorageItemAction:
        return _onCreateNewStorageItemAction(store.state, action);
      case OnCreateNewClientTap:
        return _onCreateNewClientTap(store.state, action);

      // case OnAddLocationAction:
      //   return _onAddLocationAction(store.state, action);
      // case OnAddClientAction:
      //   return _onAddClientAction(store.state, action);

      case GetApprovalAction:
        return _getApprovalAction(store.state, action, next);
      case GetApprovalUserQualificationsAction:
        return _getApprovalUserQualificationsAction(store.state, action, next);
      case GetInventoryList:
        return _getInventoryList(store.state, action, next);
      case CreateJobAction:
        return _createJobAction(store.state, action);
      case ChangeQuoteStatusAction:
        return _changeQuoteStatusAction(store.state, action);
      default:
        return next(action);
    }
  }

  Future<StateValue<ListAllMd>> _getAllParamList(
      AppState state, GetAllParamListAction action, NextDispatcher next) async {
    StateValue<ListAllMd> stateValue = StateValue(
        data: ListAllMd.init(),
        error:
            ErrorModel<GetAllParamListAction>(isLoading: true, action: action));

    next(UpdateGeneralStateAction(paramList: stateValue));

    final ApiResponse res = await restClient().getLists().nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final r = res.data;
      ListAllMd l = stateValue.data!;
      for (var e in r['currencies']) {
        l.currencies.add(ListCurrency.fromJson(e));
      }
      for (var e in r['countries']) {
        l.countries.add(ListCountry.fromJson(e));
      }
      for (var e in r['ethnics']) {
        l.ethnics.add(ListEthnic.fromJson(e));
      }
      for (var e in r['handover_types']) {
        l.handover_types.add(ListHandoverType.fromJson(e));
      }
      for (var e in r['groups']) {
        l.groups.add(ListGroup.fromJson(e));
      }
      for (var e in r['jobtitles']) {
        l.jobtitles.add(ListJobTitle.fromJson(e));
      }
      for (var e in r['locations']) {
        l.locations.add(ListLocation.fromJson(e));
      }
      for (var e in r['qualifications']) {
        l.qualifications.add(ListQualification.fromJson(e));
      }
      for (var e in r['qualification_levels']) {
        l.qualification_levels.add(ListQualificationLevel.fromJson(e));
      }
      for (var e in r['religions']) {
        l.religions.add(ListReligion.fromJson(e));
      }
      for (var e in r['request_types']) {
        l.request_types.add(ListRequestType.fromJson(e));
      }
      for (var e in r['shifts']) {
        l.shifts.add(ListShift.fromJson(e));
      }
      for (var e in r['statuses']) {
        l.statuses.add(ListStatus.fromJson(e));
      }
      for (var e in r['storages']) {
        l.storages.add(ListStorage.fromJson(e));
      }
      for (var e in r['storage_items']) {
        l.storage_items.add(ListStorageItem.fromJson(e));
      }
      for (var e in r['visas']) {
        l.visas.add(ListVisa.fromJson(e));
      }
      for (var e in r['roles']) {
        l.roles.add(ListRole.fromJson(e));
      }
      for (var e in r['login_methods']) {
        l.login_methods.add(LoginMethods.fromJson(e));
      }
      for (var e in r['marital_statuses']) {
        l.marital_statuses.add(MaritalStatuses.fromJson(e));
      }
      for (var e in r['contract_starts']) {
        l.contract_starts.add(ContractStarts.fromJson(e));
      }
      for (var e in r['contract_types']) {
        l.contract_types.add(ContractTypes.fromJson(e));
      }
      for (var e in r['holiday_calculation_types']) {
        l.holiday_calculation_types.add(HolidayCalculationTypes.fromJson(e));
      }
      for (var e in r['colour_schemas']) {
        l.color_schemas.add(ColorSchemas.fromJson(e));
      }
      for (var e in r['taxes']) {
        l.taxes.add(ListTaxes.fromJson(e));
      }
      for (var e in r['special_rates']) {
        l.special_rates.add(ListSpecialRate.fromJson(e));
      }
      for (var e in r['clients']) {
        l.clients.add(ListClients.fromJson(e));
      }
      for (var e in r['services']) {
        l.services.add(ListServices.fromJson(e));
      }
      for (var e in r['payment_methods']) {
        l.payment_methods.add(ListPaymentMethods.fromJson(e));
      }
      for (var e in r['work_repeats']) {
        l.work_repeats.add(ListWorkRepeats.fromJson(e));
      }

      final userColor = l.color_schemas
          .firstWhere((element) =>
              element.id ==
              GeneralController.to.loggedInUserValue.colourSchemaId!)
          .colour1
          .substring(1);
      final color = "0xFF$userColor";
      ThemeColors.MAIN_COLOR = Color(int.parse(color));

      final DepartmentsController departmentsController = Get.find();
      final GroupsController groupsController = Get.find();
      final QualifsController qualifsController = Get.find();
      final HandoverTypesController handoverTypesController = Get.find();
      departmentsController.setList(l.groups);
      groupsController.setList(l.jobtitles);
      qualifsController.setList(l.qualifications);
      handoverTypesController.setList(l.handover_types);

      stateValue.error.isError = false;
      stateValue.data = l;

      next(UpdateGeneralStateAction(paramList: stateValue));
    } else {
      stateValue.error.retries = state.generalState.paramList.error.retries + 1;

      next(UpdateGeneralStateAction(paramList: stateValue));
    }
    return stateValue;
  }
}

Future<List<LocationAddress>> _getLocationAddresses(AppState state,
    GetLocationAddressesAction action, NextDispatcher next) async {
  try {
    final ApiResponse res =
        await restClient().getLocationsOrSingle().nocodeErrorHandler();

    if (res.success) {
      final r = res.data;
      final List<LocationAddress> list = [];
      for (var e in r) {
        list.add(LocationAddress.fromJson(e));
      }
      LocationsController.to.setList(list);
      next(UpdateGeneralStateAction(locations: list));
      return list;
    }
    return [];
  } catch (e) {
    Logger.e(e.toString(), tag: "GetLocationAddressesAction");
    return [];
  }
}

Future<List<ClientInfoMd>> _getClientInfosAction(
    AppState state, GetClientInfosAction action, NextDispatcher next) async {
  try {
    final ApiResponse res =
        await restClient().getClients(action.id ?? 0).nocodeErrorHandler();

    if (res.success) {
      final r = res.data;
      final List<ClientInfoMd> list = [];
      for (var e in r) {
        list.add(ClientInfoMd.fromJson(e));
      }
      next(UpdateGeneralStateAction(clientInfos: list));
      return list;
    }
    return [];
  } catch (e) {
    Logger.e(e.toString(), tag: "GetClientInfosAction");
    return [];
  }
}

Future<List<QuoteInfoMd>> _getQuotesAction(
    AppState state, GetQuotesAction action, NextDispatcher next) async {
  try {
    final ApiResponse res =
        await restClient().getQuotes(action.id ?? 0).nocodeErrorHandler();

    if (res.success) {
      final r = res.data['quotes'];
      final List<QuoteInfoMd> list = [];
      for (var e in r) {
        list.add(QuoteInfoMd.fromJson(e));
      }
      next(UpdateGeneralStateAction(quotes: list));
      return list;
    }
    return [];
  } catch (e) {
    Logger.e(e.toString(), tag: "GetQuotesAction");
    return [];
  }
}

Future<ApiResponse?> _createQuoteAction(
    AppState state, CreateQuoteAction action, NextDispatcher next) async {
  try {
    final dio.Dio apiClient = DioClientForRetrofit(
            bearerToken: state.authState.authRes.data?.access_token,
            contentType: "multipart/form-data")
        .init();

    if (action.storageItems.isEmpty) {
      showError('Please add item/service(s)', titleMsg: "Warning");
      return null;
    }
    if (action.email.isEmpty) {
      showError('Please add email', titleMsg: "Warning");
      return null;
    }
    final dio.FormData formData = dio.FormData();

    formData.fields.add(MapEntry('name', action.name));

    if (action.company != null && action.company!.isNotEmpty) {
      formData.fields.add(MapEntry('company', action.company!));
    }

    formData.fields.add(MapEntry('email', action.email));

    if (action.phone != null && action.phone!.isNotEmpty) {
      formData.fields.add(MapEntry('phone', action.phone!));
    }

    formData.fields.add(MapEntry('payingDays', action.payingDays.toString()));

    formData.fields.add(MapEntry('active', action.active.toString()));

    formData.fields.add(MapEntry('currencyId', action.currencyId.toString()));

    formData.fields
        .add(MapEntry('paymentMethodId', action.paymentMethodId.toString()));

    formData.fields
        .add(MapEntry('workRepeatId', action.workRepeatId.toString()));

    if (action.addressLine1 != null && action.addressLine1!.isNotEmpty) {
      formData.fields.add(MapEntry('addressLine1', action.addressLine1!));
    }

    if (action.addressLine2 != null && action.addressLine2!.isNotEmpty) {
      formData.fields.add(MapEntry('addressLine2', action.addressLine2!));
    }

    if (action.addressCity != null && action.addressCity!.isNotEmpty) {
      formData.fields.add(MapEntry('addressCity', action.addressCity!));
    }

    if (action.addressCounty != null && action.addressCounty!.isNotEmpty) {
      formData.fields.add(MapEntry('addressCounty', action.addressCounty!));
    }

    if (action.addressPostcode != null && action.addressPostcode!.isNotEmpty) {
      formData.fields.add(MapEntry('addressPostcode', action.addressPostcode!));
    }

    if (action.addressCountry != null && action.addressCountry!.isNotEmpty) {
      formData.fields.add(MapEntry('addressCountry', action.addressCountry!));
    }

    if (action.notes != null && action.notes!.isNotEmpty) {
      formData.fields.add(MapEntry('notes', action.notes!));
    }

    if (action.workAddressLine1 != null &&
        action.workAddressLine1!.isNotEmpty) {
      formData.fields
          .add(MapEntry('workAddressLine1', action.workAddressLine1!));
    }

    if (action.workAddressLine2 != null &&
        action.workAddressLine2!.isNotEmpty) {
      formData.fields
          .add(MapEntry('workAddressLine2', action.workAddressLine2!));
    }

    if (action.workAddressCity != null && action.workAddressCity!.isNotEmpty) {
      formData.fields.add(MapEntry('workAddressCity', action.workAddressCity!));
    }

    if (action.workAddressCounty != null &&
        action.workAddressCounty!.isNotEmpty) {
      formData.fields
          .add(MapEntry('workAddressCounty', action.workAddressCounty!));
    }

    if (action.workAddressPostcode != null &&
        action.workAddressPostcode!.isNotEmpty) {
      formData.fields
          .add(MapEntry('workAddressPostcode', action.workAddressPostcode!));
    }

    if (action.workAddressCountry != null &&
        action.workAddressCountry!.isNotEmpty) {
      formData.fields
          .add(MapEntry('workAddressCountry', action.workAddressCountry!));
    }

    if (action.workStartDate != null && action.workStartDate!.isNotEmpty) {
      formData.fields.add(MapEntry(
          'workStartDate', action.workStartDate!.toDate()!.formattedDate));
    }
    if (action.altWorkStartDate != null &&
        action.altWorkStartDate!.isNotEmpty) {
      formData.fields.add(MapEntry('altWorkStartDate',
          action.altWorkStartDate!.toDate()!.formattedDate));
    }
    if (action.workStartTime != null && action.workStartTime!.isNotEmpty) {
      formData.fields.add(MapEntry('workStartTime', action.workStartTime!));
    }
    if (action.workFinishTime != null && action.workFinishTime!.isNotEmpty) {
      formData.fields.add(MapEntry('workFinishTime', action.workFinishTime!));
    }

    formData.fields
        .add(MapEntry('workRepeatId', action.workRepeatId.toString()));

    if (action.workDays != null && action.workDays!.isNotEmpty) {
      String week1 = "";
      String week2 = "";

      for (var day in action.workDays!) {
        if (action.workRepeatId == 3) {
          //Week
          week1 +=
              "${Constants.daysOfTheWeek.keys.firstWhere((element) => element == day)},";
        }
        if (action.workRepeatId == 4) {
          //Fortnightly
          if (day > 7) {
            week2 +=
                "${Constants.daysOfTheWeek.keys.firstWhere((element) => element == day)}${action.workDays?.last == day ? "" : ","}";
          } else {
            week1 +=
                "${Constants.daysOfTheWeek.keys.firstWhere((element) => element == day)}${action.workDays?.last == day ? "" : ","}";
          }
        }
      }
      if (week1.isNotEmpty) {
        formData.fields.add(MapEntry('workDays', week1));
      }
      if (week2.isNotEmpty) {
        formData.fields.add(MapEntry('workDays2', week2));
      }
    }
    if (action.userIds != null && action.userIds!.isNotEmpty) {
      final usrs = action.userIds!.join(',');
      formData.fields.add(MapEntry('user_ids', usrs));
    }
    // return null;

    for (int i = 0; i < action.storageItems.length; i++) {
      final item = action.storageItems[i];

      formData.fields.add(MapEntry('quoteItem_$i', item.id.toString()));

      formData.fields
          .add(MapEntry('quoteQuantity_$i', item.quantity.toString()));

      formData.fields
          .add(MapEntry('quotePrice_$i', item.outgoingPrice.toString()));

      formData.fields.add(MapEntry('quoteAuto_$i', item.auto.toString()));
    }

    if (action.quoteComments != null && action.quoteComments!.isNotEmpty) {
      formData.fields.add(MapEntry('quoteComments', action.quoteComments!));
    }

    if (action.clientId != null) {
      formData.fields.add(MapEntry('client_id', action.clientId!.toString()));
    }
    if (action.locationId != null) {
      formData.fields
          .add(MapEntry('location_id', action.locationId!.toString()));
    }
    if (action.clientContractId != null) {
      formData.fields.add(
          MapEntry('client_contract_id', action.clientContractId!.toString()));
    }
    if (action.shiftId != null) {
      formData.fields.add(MapEntry('shift_id', action.shiftId!.toString()));
    }

    formData.fields.removeWhere((element) => element.value == "null");

    logger(
        "FormData: ${formData.fields.map((e) => "${e.key}: ${e.value}").toList()}");

    dio.Response res =
        await apiClient.post('/api/fe/quotes/${action.id}', data: formData);

    final ApiResponse apiResponse = ApiResponse.fromDioResponse(res);

    switch (res.statusCode) {
      case 200:
        if (res.data != null) {
          await appStore.dispatch(GetAllStorageItemsAction());
          await appStore.dispatch(GetQuotesAction());
          return apiResponse;
        }
        showError(res.data ?? 'Error');
        break;
      default:
        showError(res.statusMessage ?? 'Error');
    }
  } on dio.DioError catch (e) {
    logger("Response: ${e.response?.data}");
    switch (e.type) {
      case dio.DioErrorType.response:
        showError(e.response?.data ?? 'Error');
        break;
      default:
        showError(e.message);
    }
  } on TypeError catch (e) {
    showError("Unknown error occurred!");
    Logger.e(e.stackTrace, tag: "CreateQuoteAction");
  }
}

Future<StorageItemMd?> _onAddStorageItemAction(
    AppState state, OnAddStorageItemAction action) async {
  final resId = await showDialog<int>(
      barrierDismissible: false,
      context: action.context,
      builder: (context) => StorageItemForm(state: state));
  if (resId == null) return null;
  final item = appStore.state.generalState.storage_items
      .firstWhereOrNull((element) => element.id == resId);
  return item;
}

Future<int?> _onCreateNewStorageItemAction(
    AppState state, OnCreateNewStorageItemAction action) async {
  if (action.title.isEmpty) {
    showError("Please add title");
    return null;
  }
  if (action.customerPrice == null) {
    showError("Please add customer price");
    return null;
  }
  return await Get.showOverlay(
      asyncFunction: () async {
        try {
          final ApiResponse res = await restClient()
              .postStorageItems(
                  id: action.id,
                  name: action.title,
                  taxId: action.taxId,
                  outgoingPrice: action.customerPrice.toString(),
                  service: false,
                  active: true)
              .nocodeErrorHandler();
          if (res.success) {
            await appStore.dispatch(GetAllStorageItemsAction());
            return res.data;
          } else {
            showError(res.resMessage);
          }
        } catch (e) {
          showError(e.toString());
        }
      },
      loadingWidget: const CustomLoadingWidget());
}

Future _onCreateNewClientTap(
    AppState state, OnCreateNewClientTap action) async {
  final data = await showDialog(
      barrierDismissible: false,
      context: action.context,
      builder: (context) {
        switch (action.type) {
          case ClientFormType.timing:
            return TimingForm(
              state: state,
              timingInfo: action.timingInfo,
              quoteInfo: action.quoteInfo,
            );
          default:
            return ClientForm(
              state: state,
              type: action.type,
              selectedClient: action.clientInfo,
            );
        }
      });
  return data;
}

Future<ApprovalMd> _getApprovalAction(
    AppState state, GetApprovalAction action, NextDispatcher next) async {
  try {
    final ApiResponse res =
        await restClient().getApprovals().nocodeErrorHandler();

    if (res.success) {
      final r = ApprovalMd.fromJson(res.data);
      next(UpdateGeneralStateAction(approvals: r));
      return r;
    }
    return ApprovalMd(
      pendingUserQualifications: [],
      requests: [],
      releasable: [],
    );
  } catch (e) {
    Logger.e(e.toString(), tag: "GetApprovalAction");
    return ApprovalMd(
      pendingUserQualifications: [],
      requests: [],
      releasable: [],
    );
  }
}

Future<List<ApprovalUserQualificationMd>> _getApprovalUserQualificationsAction(
    AppState state,
    GetApprovalUserQualificationsAction action,
    NextDispatcher next) async {
  try {
    //
    // final ApiResponse res =
    // await restClient().getQuotes(action.id ?? 0).nocodeErrorHandler();
    //
    // if (res.success) {
    //   final r = res.data['quotes'];
    //   final List<QuoteInfoMd> list = [];
    //   for (var e in r) {
    //     list.add(QuoteInfoMd.fromJson(e));
    //   }
    //   next(UpdateGeneralStateAction(quotes: list));
    //   return list;
    // }
    return [];
  } catch (e) {
    Logger.e(e.toString(), tag: "GetApprovalAction");
    return [];
  }
}

Future<List<InventoryMd>> _getInventoryList(
    AppState state, GetInventoryList action, NextDispatcher next) async {
  try {
    //
    // final ApiResponse res =
    // await restClient().getQuotes(action.id ?? 0).nocodeErrorHandler();
    //
    // if (res.success) {
    //   final r = res.data['quotes'];
    //   final List<QuoteInfoMd> list = [];
    //   for (var e in r) {
    //     list.add(QuoteInfoMd.fromJson(e));
    //   }
    //   next(UpdateGeneralStateAction(quotes: list));
    //   return list;
    // }
    return [];
  } catch (e) {
    Logger.e(e.toString(), tag: "GetInventoryList");
    return [];
  }
}

Future _createJobAction(AppState state, CreateJobAction action) async {
  try {
    final data = action.data;
    final client = data.client;
    final location = data.location;
    final timing = data.timingInfo;
    final gridStateManager = data.gridStateManager;
    final team = data.addedChildren;
    final quote = data.fetchedQuote;
    final bool isUpdate = !data.isCreate;

    if (client == null) {
      showError("Please select client");
      return;
    }
    if (timing.repeatTypeIndex == null) {
      showError("Please select repeat type");
      return;
    }
    if (data.storageItems(state.generalState.storage_items).isEmpty) {
      showError("Please add at least one storage item");
      return;
    }
    if (location == null) {
      showError("Please add location");
      return;
    }
    //1. Create Quote
    ApiResponse? createdQuote;
    if (isUpdate) {
      final ApiResponse? changedQuoteStatus = await appStore.dispatch(
          ChangeQuoteStatusAction(status: "pending", quoteId: quote!.id));
    }
    createdQuote = await appStore.dispatch(
      CreateQuoteAction(
        id: data.quoteId ?? 0,
        name: client.name,
        active: client.active,
        paymentMethodId: int.tryParse(client.paymentMethodId ?? "") ?? 1,
        currencyId: int.tryParse(client.currencyId ?? "") ?? 1,
        payingDays: client.payingDays,
        email: client.email ?? "",
        workRepeatId:
            state.generalState.workRepeats[timing.repeatTypeIndex!].id,
        notes: client.notes,
        phone: client.phone,
        storageItems: data.storageItems(state.generalState.storage_items),
        workStartDate: timing.startDate?.formatDateForApi,
        workStartTime: timing.startTime?.formattedTime,
        workFinishTime: timing.endTime?.formattedTime,
        addressLine1: location.address?.line1,
        addressLine2: location.address?.line2,
        addressCity: location.address?.city,
        addressCounty: location.address?.county,
        addressCountry: location.address?.country,
        addressPostcode: location.address?.postcode,
        clientId: client.id,
        locationId: location.id,
        company: client.company,
        userIds: team.map((e) => e.id).toList(),
      ),
    );

    //2. Change Quote Status to accepted
    if (createdQuote != null && createdQuote.success) {
      final quoteId = createdQuote.data as int;
      final ApiResponse? changedQuoteStatus = await appStore.dispatch(
          ChangeQuoteStatusAction(status: "accept", quoteId: quoteId));
      if (changedQuoteStatus?.success == true) {
        await appStore.dispatch(SCFetchShiftsAction(date: timing.startDate!));
        await appStore.dispatch(SCFetchShiftsWeekAction(
          startDate: timing.startDate!.subtract(const Duration(days: 7)),
          endDate: timing.startDate!,
        ));
        await appStore
            .dispatch(SCFetchShiftsMonthAction(startDate: timing.startDate!));

        return changedQuoteStatus;
      } else {
        showError(changedQuoteStatus?.data ?? "Error");
      }
      //DEPRECATED
      // //3. (Optional) Assign users to the allocation
      // if (changedQuoteStatus != null && changedQuoteStatus.success) {
      //   //TODO: Assign users to the allocation
      //   // final allocationId = changedQuoteStatus.data as int;
      //   // //Get all allocations and find the shift id using allocation id and date
      //   // final ApiResponse res = await restClient()
      //   //     .getShifts(
      //   //       location?.id ?? 0,
      //   //       0,
      //   //       0,
      //   //       DateFormat("yyyy-MM-dd").format(timing.startDate!),
      //   //     )
      //   //     .nocodeErrorHandler();
      //   // //Use shift id
      //   // // final ApiResponse res = await restClient()
      //   // //     .postShifts(
      //   // //       location?.id ?? 0,
      //   // //       805, //TODO: User
      //   // //       106,
      //   // //       DateFormat("yyyy-MM-dd").format(timing.startDate!),
      //   // //       AllocationActions.add.name,
      //   // //     )
      //   // //     .nocodeErrorHandler();
      //   // return res;
      // }
    }
  } on Exception catch (e) {
    Logger.e(e.toString(), tag: "CreateJobAction");
    showError("Something went wrong");
  }
}

Future<ApiResponse?> _changeQuoteStatusAction(
    AppState state, ChangeQuoteStatusAction action) async {
  try {
    final ip_address = await getIpAddress();
    if (ip_address == null) {
      throw Exception("Cannot get IP address");
    }
    final browserId = await getBrowserId();
    if (browserId == null) {
      throw Exception("Cannot get browser id");
    }
    final ApiResponse res = await restClient()
        .updateQuoteStatus(action.quoteId,
            status: action.status, ip_address: ip_address, browser: browserId)
        .nocodeErrorHandler();
    return res;
  } on Exception catch (e) {
    throw Exception("Cannot change Quote status ${e.toString()}");
  }
}
