import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import '../../../comps/drawer.dart';
import '../../model_exporter.dart';
import '../../router/router.gr.dart';

@immutable
class GeneralState {
  final StateValue<ListAllMd> paramList;
  final DrawerStates drawerStates;
  final Widget? endDrawer;

  // ignore: prefer_const_constructors_in_immutables
  GeneralState({
    required this.paramList,
    required this.drawerStates,
    required this.endDrawer,
  });

  factory GeneralState.initial() {
    return GeneralState(
      endDrawer: null,
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
  }) {
    return GeneralState(
      paramList: paramList ?? this.paramList,
      drawerStates: drawerStates ?? this.drawerStates,
      endDrawer: endDrawer,
    );
  }
}

class UpdateGeneralStateAction {
  StateValue<ListAllMd>? paramList;
  DrawerStates? drawerStates;
  Widget? endDrawer;

  UpdateGeneralStateAction({
    this.paramList,
    this.drawerStates,
    this.endDrawer,
  });
}

class GetAllParamListAction {}
