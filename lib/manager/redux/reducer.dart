import 'package:mca_dashboard/manager/redux/redux.dart';

AppState appReducer(AppState state, dynamic action) {
  var newState = state.copyWith(
    generalState: _generalReducer(state.generalState, action),
  );

  return newState;
}

///
/// General Reducer
///
final _generalReducer = combineReducers<GeneralState>([
  TypedReducer<GeneralState, UpdateGeneralState>(_updateGeneralState),
]);

GeneralState _updateGeneralState(
    GeneralState state, UpdateGeneralState action) {
  if (action.isReset) return GeneralState.initial();
  return state.copyWith(
    formatMd: action.formatMd ?? state.formatMd,
    users: action.users ?? state.users,
    lists: action.lists ?? state.lists,
    locations: action.locations ?? state.locations,
    storageItems: action.storageItems ?? state.storageItems,
    clients: action.clients ?? state.clients,
    properties: action.properties ?? state.properties,
    quotes: action.quotes ?? state.quotes,
    warehouses: action.warehouses ?? state.warehouses,
    companyInfo: action.companyInfo ?? state.companyInfo,
    allocations: action.allocations ?? state.allocations,
    detailsMd: action.detailsMd ?? state.detailsMd,
    checklistTemplates: action.checklistTemplates ?? state.checklistTemplates,
    approvals: action.approvals ?? state.approvals,
    checklists: action.checklists ?? state.checklists,
    languages: action.languages ?? state.languages,
    timesheet: action.timesheet ?? state.timesheet,
    jobTemplates: action.jobTemplates ?? state.jobTemplates,
  );
}
