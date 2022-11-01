import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/pages/warehouses/controllers/warehouse_controller.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:redux/redux.dart';
import '../../../app.dart';
import '../../../comps/drawer.dart';
import '../../model_exporter.dart';
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

  // ignore: prefer_const_constructors_in_immutables
  GeneralState({
    required this.paramList,
    required this.locationList,
    required this.warehouses,
    required this.drawerStates,
    required this.endDrawer,
  });

  factory GeneralState.initial() {
    return GeneralState(
      endDrawer: null,
      locationList: [],
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
  }) {
    return GeneralState(
      paramList: paramList ?? this.paramList,
      drawerStates: drawerStates ?? this.drawerStates,
      warehouses: warehouses ?? this.warehouses,
      locationList: locationList ?? this.locationList,
      endDrawer: endDrawer,
    );
  }
}

class UpdateGeneralStateAction {
  StateValue<ListAllMd>? paramList;
  DrawerStates? drawerStates;
  Widget? endDrawer;
  List<LocationsMd>? locationList;
  StateValue<List<WarehouseMd>>? warehouses;

  UpdateGeneralStateAction({
    this.paramList,
    this.drawerStates,
    this.endDrawer,
    this.locationList,
    this.warehouses,
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
  static Future<List<LocationsMd>> fetch(AppState state) async {
    final ApiResponse res =
        await restClient().getAllLocations().nocodeErrorHandler();

    if (res.success) {
      final List<LocationsMd> list =
          res.data.map<LocationsMd>((e) => LocationsMd.fromJson(e)).toList();
      appStore.dispatch(UpdateGeneralStateAction(locationList: list));
      return list;
    } else {
      showError(res.resMessage ?? "Error");
      return [];
    }
  }
}
