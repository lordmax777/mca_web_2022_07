import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import '../../model_exporter.dart';

@immutable
class GeneralState {
  final StateValue<ListAllMd> paramList;

  // ignore: prefer_const_constructors_in_immutables
  GeneralState({
    required this.paramList,
  });

  factory GeneralState.initial() {
    return GeneralState(
      paramList: StateValue(
          error: ErrorModel(),
          data: ListAllMd(
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
          )),
    );
  }

  GeneralState copyWith({
    StateValue<ListAllMd>? paramList,
  }) {
    return GeneralState(
      paramList: paramList ?? this.paramList,
    );
  }
}

class UpdateGeneralStateAction {
  StateValue<ListAllMd>? paramList;

  UpdateGeneralStateAction({
    this.paramList,
  });
}

class GetAllParamListAction {}
