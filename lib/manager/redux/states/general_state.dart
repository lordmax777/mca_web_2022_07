import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
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

  // ignore: prefer_const_constructors_in_immutables
  GeneralState({
    required this.paramList,
    required this.locationList,
    required this.drawerStates,
    required this.endDrawer,
  });

  factory GeneralState.initial() {
    return GeneralState(
      endDrawer: null,
      locationList: [],
      drawerStates: DrawerStates(initialIndex: 1, name: const UsersListRoute()),
      paramList: StateValue(
        error: ErrorModel(),
        data: ListAllMd(
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
  }) {
    return GeneralState(
      paramList: paramList ?? this.paramList,
      drawerStates: drawerStates ?? this.drawerStates,
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

  UpdateGeneralStateAction({
    this.paramList,
    this.drawerStates,
    this.endDrawer,
    this.locationList,
  });
}

class GetAllParamListAction {}

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
