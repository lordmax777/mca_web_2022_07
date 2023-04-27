import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';

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
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:mix/mix.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:get/get.dart';
import 'package:retrofit/retrofit.dart';
import '../../general_controller.dart';
import '../../models/location_item_md.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../sets/state_value.dart';
import '../states/general_state.dart';

import 'package:dio/dio.dart' as dio;

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
      // case OnAddLocationAction:
      //   return _onAddLocationAction(store.state, action);
      // case OnAddClientAction:
      //   return _onAddClientAction(store.state, action);
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
      next(UpdateGeneralStateAction(locationAddresses: list));
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
  return await Get.showOverlay(
      asyncFunction: () async {
        try {
          final dio.Dio apiClient = DioClientForRetrofit(
                  bearerToken: state.authState.authRes.data?.access_token,
                  contentType: "multipart/form-data")
              .init();

          final data = <String, dynamic>{};

          if (action.storageItems.isEmpty) {
            showError('Please add item/service(s)', titleMsg: "Warning");
            return null;
          }
          if (action.email.isEmpty) {
            showError('Please add email', titleMsg: "Warning");
            return null;
          }
          final dio.FormData formData = dio.FormData.fromMap(data);

          formData.fields.add(MapEntry('name', action.name));
          data['name'] = action.name;

          formData.fields.add(MapEntry('email', action.email));
          data['email'] = action.email;

          formData.fields
              .add(MapEntry('payingDays', action.payingDays.toString()));
          data['payingDays'] = action.payingDays;

          formData.fields.add(MapEntry('active', action.active.toString()));
          data['active'] = action.active;

          formData.fields
              .add(MapEntry('currencyId', action.currencyId.toString()));
          data['currencyId'] = action.currencyId;

          formData.fields.add(
              MapEntry('paymentMethodId', action.paymentMethodId.toString()));
          data['paymentMethodId'] = action.paymentMethodId;

          formData.fields
              .add(MapEntry('workRepeatId', action.workRepeatId.toString()));
          data['workRepeatId'] = action.workRepeatId;

          if (action.phone != null && action.phone!.isNotEmpty) {
            formData.fields.add(MapEntry('phone', action.phone!));
            data['phone'] = action.phone;
          }

          for (int i = 0; i < action.storageItems.length; i++) {
            final item = action.storageItems[i];

            formData.fields.add(MapEntry('quoteItem_$i', item.id.toString()));
            data['quoteItem_$i'] = item.id;

            formData.fields
                .add(MapEntry('quoteQuantity_$i', item.quantity.toString()));
            data['quoteQuantity_$i'] = item.quantity;

            formData.fields
                .add(MapEntry('quotePrice_$i', item.outgoingPrice.toString()));
            data['quotePrice_$i'] = item.outgoingPrice;

            formData.fields.add(MapEntry('quoteAuto_$i', item.auto.toString()));
            data['quoteAuto_$i'] = item.auto;
          }

          // formData.fields.removeWhere((element) => element.value == "null");

          logger(
              "FormData: ${formData.fields.map((e) => "${e.key}: ${e.value}").toList()}");

          dio.Response res = await apiClient.post('/api/fe/quotes/${action.id}',
              data: formData);

          final ApiResponse apiResponse = ApiResponse.fromDioResponse(res);

          switch (res.statusCode) {
            case 200:
              if (res.data != null) {
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
        } catch (e) {
          showError("Unknown error occurred!");
          Logger.e(e.toString(), tag: "CreateQuoteAction");
        }
      },
      loadingWidget: const Center(child: CircularProgressIndicator()));
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
//
// Future<CreatedClientReturnValue?> _onAddLocationAction(
//     AppState state, OnAddLocationAction action) async {
//   final CreatedClientReturnValue? data = await showDialog(
//       barrierDismissible: false,
//       context: action.context,
//       builder: (context) => ClientForm(
//             state: state,
//             type: ClientFormType.location,
//           ));
//   if (data != null && data.locationId != null) {
//     return await Get.showOverlay(
//       asyncFunction: () async {
//         try {
//           final ApiResponse createdClient = await action.createClient();
//           if (createdClient.success) {
//             return CreatedClientReturnValue(
//                 clientId: createdClient.data, locationId: data.locationId);
//           } else {
//             showError(createdClient.resMessage ?? "Unknown Error");
//           }
//         } catch (e) {
//           showError(e.toString());
//         }
//       },
//       loadingWidget: const Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
//
// Future<CreatedClientReturnValue?> _onAddClientAction(
//     AppState state, OnAddClientAction action) async {
//   final ApiResponse createdClient =
//       await action.createClient(fetchAllParams: false);
//   if (createdClient.success) {
//     final ApiResponse createdLocation = await action.createLocation();
//     if (createdLocation.success) {
//       return CreatedClientReturnValue(
//           clientId: createdClient.data, locationId: createdLocation.data);
//     } else {
//       await appStore.dispatch(GetAllParamListAction());
//       //Location already exists
//       if (createdLocation.resCode == 409) {
//         return CreatedClientReturnValue(
//             clientId: createdClient.data, locationId: createdLocation.data);
//       }
//       showError(ApiHelpers.getRawDataErrorMessages(createdLocation).isEmpty
//           ? "Error"
//           : ApiHelpers.getRawDataErrorMessages(createdLocation));
//     }
//   } else {
//     showError(
//       ApiHelpers.getRawDataErrorMessages(createdClient).isEmpty
//           ? "Error"
//           : ApiHelpers.getRawDataErrorMessages(createdClient),
//     );
//   }
//   return null;
// }
