import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/manager/models/list_all_md.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../sets/state_value.dart';
import '../states/general_state.dart';

class GeneralMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case GetAllParamListAction:
        return _getAllParamList(store.state, action, next);
      case GetAllLocationsAction:
        return GetAllLocationsAction.fetch(store.state);
      default:
        return next(action);
    }
  }

  Future<StateValue<ListAllMd>> _getAllParamList(
      AppState state, GetAllParamListAction action, NextDispatcher next) async {
    StateValue<ListAllMd> stateValue = StateValue(
        data: ListAllMd(
            holiday_calculation_types: [],
            contract_starts: [],
            contract_types: [],
            countries: [],
            currencies: [],
            locations: [],
            ethnics: [],
            groups: [],
            handover_types: [],
            jobtitles: [],
            qualification_levels: [],
            qualifications: [],
            religions: [],
            request_types: [],
            roles: [],
            shifts: [],
            special_rates: [],
            statuses: [],
            storage_items: [],
            storages: [],
            visas: [],
            login_methods: [],
            marital_statuses: []),
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
