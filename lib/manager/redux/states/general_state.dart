import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/locations_controller.dart';
import 'package:mca_web_2022_07/pages/warehouses/controllers/warehouse_controller.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:redux/redux.dart';
import '../../../app.dart';
import '../../../comps/drawer.dart';
import '../../model_exporter.dart';
import '../../models/location_item_md.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../../router/router.gr.dart';
import '../middlewares/users_middleware.dart';
import '../sets/app_state.dart';

@immutable
class GeneralState {
  final StateValue<ListAllMd> paramList;
  final List<LocationsMd> locationList;
  final DrawerStates drawerStates;
  final Widget? endDrawer;
  final StateValue<List<WarehouseMd>> warehouses;
  final StateValue<List<LocationItemMd>> locationItems;
  // ignore: prefer_const_constructors_in_immutables
  GeneralState({
    required this.paramList,
    required this.locationList,
    required this.warehouses,
    required this.drawerStates,
    required this.endDrawer,
    required this.locationItems,
  });

  CodeMap findCountryByName(String? name) {
    CodeMap c = CodeMap(name: null, code: null);
    if (paramList.data != null) {
      for (ListCountry item in (paramList.data?.countries) ?? <ListCountry>[]) {
        if (item.code == name) {
          c = CodeMap(name: item.name, code: item.code);
          break;
        }
      }
    }

    return c;
  }

  factory GeneralState.initial() {
    return GeneralState(
      endDrawer: null,
      locationList: [],
      locationItems: StateValue(
        error: ErrorModel(),
        data: [],
      ),
      warehouses: StateValue(
        error: ErrorModel(),
        data: [],
      ),
      drawerStates: DrawerStates(initialIndex: 1, name: const UsersListRoute()),
      paramList: StateValue(
        error: ErrorModel(),
        data: ListAllMd(
          holiday_calculation_types: [],
          contract_types: [],
          contract_starts: [],
          login_methods: [],
          marital_statuses: [],
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
        ),
      ),
    );
  }

  GeneralState copyWith({
    StateValue<ListAllMd>? paramList,
    DrawerStates? drawerStates,
    Widget? endDrawer,
    List<LocationsMd>? locationList,
    StateValue<List<WarehouseMd>>? warehouses,
    StateValue<List<LocationItemMd>>? locationItems,
  }) {
    return GeneralState(
      paramList: paramList ?? this.paramList,
      drawerStates: drawerStates ?? this.drawerStates,
      warehouses: warehouses ?? this.warehouses,
      locationList: locationList ?? this.locationList,
      endDrawer: endDrawer,
      locationItems: locationItems ?? this.locationItems,
    );
  }
}

class UpdateGeneralStateAction {
  StateValue<ListAllMd>? paramList;
  DrawerStates? drawerStates;
  Widget? endDrawer;
  List<LocationsMd>? locationList;
  StateValue<List<WarehouseMd>>? warehouses;
  StateValue<List<LocationItemMd>>? locationItems;

  UpdateGeneralStateAction({
    this.paramList,
    this.drawerStates,
    this.endDrawer,
    this.locationList,
    this.warehouses,
    this.locationItems,
  });
}

class GetAllParamListAction {}

class GetWarehousesAction {
  static Future<StateValue<List<WarehouseMd>>> fetch(
      AppState state, GetWarehousesAction action, NextDispatcher next) async {
    final controller = WarehouseController.to;
    final StateValue<List<WarehouseMd>> result = StateValue(
      error: ErrorModel<GetWarehousesAction>(
        isLoading: true,
        action: action,
      ),
      data: [],
    );
    next(UpdateGeneralStateAction(warehouses: result));

    final ApiResponse res =
        await restClient().getWarehouses().nocodeErrorHandler();

    result.error.errorCode = res.resCode;
    result.error.errorMessage = res.resMessage;
    result.error.isLoading = false;
    result.error.rawError = res.rawError;

    if (res.success) {
      final List<WarehouseMd> warehouses = res.data['warehouses']
          .map<WarehouseMd>((e) => WarehouseMd.fromJson(e))
          .toList();

      result.data = warehouses;
      result.error.isError = false;

      controller.setList(warehouses);
    } else {
      result.error.retries = state.generalState.warehouses.error.retries + 1;
    }

    next(UpdateGeneralStateAction(warehouses: result));
    return result;
  }
}

class GetAllLocationsAction {
  static Future<StateValue<List<LocationItemMd>>> fetch(
      AppState state, GetAllLocationsAction action, NextDispatcher next) async {
    StateValue<List<LocationItemMd>> stateValue = StateValue(
        data: [],
        error:
            ErrorModel<GetAllLocationsAction>(isLoading: true, action: action));

    next(UpdateGeneralStateAction(locationItems: stateValue));

    final ApiResponse res =
        await restClient().getLocationsOrSingle().nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final List<LocationItemMd> list = res.data
          .map<LocationItemMd>((e) => LocationItemMd.fromJson(e))
          .toList();
      list.sort((a, b) => a.name!.compareTo(b.name!));

      stateValue.error.isError = false;
      stateValue.data = list;
      LocationsController.to.setList(list);
    } else {
      stateValue.error.retries = state.usersState.usersList.error.retries + 1;
    }
    next(UpdateGeneralStateAction(locationItems: stateValue));
    return stateValue;
  }
}
