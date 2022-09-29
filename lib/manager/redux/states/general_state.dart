import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import '../../../comps/drawer.dart';
import '../../model_exporter.dart';

@immutable
class GeneralState {
  final StateValue<ListAllMd> paramList;
  final DrawerStates drawerStates;

  // ignore: prefer_const_constructors_in_immutables
  GeneralState({
    required this.paramList,
    required this.drawerStates,
  });

  factory GeneralState.initial() {
    return GeneralState(
      drawerStates: DrawerStates(initialIndex: 0, currentPage: "schedule"),
      paramList: StateValue(
        error: ErrorModel(),
        data: ListAllMd(
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
  }) {
    return GeneralState(
      paramList: paramList ?? this.paramList,
      drawerStates: drawerStates ?? this.drawerStates,
    );
  }
}

class UpdateGeneralStateAction {
  StateValue<ListAllMd>? paramList;
  DrawerStates? drawerStates;

  UpdateGeneralStateAction({
    this.paramList,
    this.drawerStates,
  });
}

class GetAllParamListAction {}
