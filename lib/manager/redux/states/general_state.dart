import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/models/approval_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/locations_controller.dart';
import 'package:mca_web_2022_07/pages/properties/controllers/properties_controller.dart';
import 'package:mca_web_2022_07/pages/stocks/controllers/stock_items_controller.dart';
import 'package:mca_web_2022_07/pages/warehouses/controllers/warehouse_controller.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:redux/redux.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../comps/drawer.dart';
import '../../../pages/checklist_templates/controllers/checklist_list_controller.dart';
import '../../../pages/scheduling/models/create_shift_type.dart';
import '../../../pages/scheduling/popup_forms/client_form.dart';
import '../../../pages/scheduling/popup_forms/timing_form.dart';
import '../../model_exporter.dart';
import '../../models/approval_md.dart';
import '../../models/inventory_md.dart';
import '../../models/location_item_md.dart';
import '../../models/timesheet_dep_md.dart';
import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../../router/router.dart';
import '../sets/app_state.dart';

@immutable
class GeneralState {
  final StateValue<ListAllMd> paramList;

  List<ListShift> get shifts => paramList.data?.shifts ?? <ListShift>[];

  List<StorageItemMd> get storage_items =>
      (storageItems.data ?? <StorageItemMd>[])
        ..sort((a, b) {
          // sort by this.service == true
          if (a.service == true && b.service == false) {
            return -1;
          } else if (a.service == false && b.service == true) {
            return 1;
          }
          return 0;
        });

  List<ListCurrency> get currencies =>
      paramList.data?.currencies ?? <ListCurrency>[];

  List<ListCountry> get countries =>
      paramList.data?.countries ?? <ListCountry>[];

  List<ListPaymentMethods> get paymentMethods =>
      paramList.data?.payment_methods ?? <ListPaymentMethods>[];

  List<WarehouseMd> get storages => warehouses.data ?? <WarehouseMd>[];

  List<ListTaxes> get taxes => paramList.data?.taxes ?? <ListTaxes>[];

  List<ListWorkRepeats> get workRepeats =>
      paramList.data?.work_repeats ?? <ListWorkRepeats>[];

  List<ListGroup> get groups => (paramList.data?.groups ?? <ListGroup>[])
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  List<ListQualification> get qualifications => (paramList
          .data?.qualifications ??
      <ListQualification>[])
    ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));

  List<ListQualificationLevel> get qualificationLevels => (paramList
          .data?.qualification_levels ??
      <ListQualificationLevel>[])
    ..sort((a, b) => a.level.toLowerCase().compareTo(b.level.toLowerCase()));

  final DrawerStates drawerStates;
  final Widget? endDrawer;
  final StateValue<List<WarehouseMd>> warehouses;
  final StateValue<List<StorageItemMd>> storageItems;
  final StateValue<List<ChecklistTemplateMd>> checklistTemplates;
  final StateValue<List<PropertiesMd>> properties;
  List<PropertiesMd> get allSortedProperties => (properties.data ?? [])
    ..sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  final List<LocationAddress> locations;
  List<LocationAddress> clientBasedLocations(int? clientId) {
    if (clientId == null) return [];
    List<LocationAddress> locs = [];
    List<ListShift> selectedClientShifts = [];
    selectedClientShifts = [
      ...(shifts
          .where((element) =>
              element.client_id != null && element.client_id == clientId)
          .toList())
    ];
    if (selectedClientShifts.isEmpty) locs = [];
    locs = [
      ...(locations
          .where((element) => selectedClientShifts
              .any((shift) => shift.location_id == element.id))
          .toList()),
    ];

    return locs;
  }

  final List<ClientInfoMd> clientInfos;

  final List<QuoteInfoMd> quotes;

  List<QuoteInfoMd> get allSortedQuotes => quotes
    ..sort((a, b) => DateTime.tryParse(b.createdOn)!
        .compareTo(DateTime.tryParse(a.createdOn)!));

  final ApprovalMd approvals;

  // List<ApprovalMd> get allSortedApprovalReq =>
  //     approvals
  //       ..sort((a, b) =>
  //           DateTime.tryParse(b.dateTime!)!
  //               .compareTo(DateTime.tryParse(a.dateTime!)!));

  List<ApprovalPendingUserQlf> get approvalPendingUserQlf =>
      approvals.pendingUserQualifications;

  List<ApprovalRequest> get approvalRequest => approvals.requests;

  List? get approvalShiftRelease => approvals.releasable;

  final List<InventoryMd> inventoryList;
  final List<TimesheetDepMd> timesheetDepList;

  GeneralState({
    required this.paramList,
    required this.warehouses,
    required this.drawerStates,
    required this.endDrawer,
    required this.storageItems,
    required this.checklistTemplates,
    required this.properties,
    required this.locations,
    required this.clientInfos,
    required this.quotes,
    required this.approvals,
    required this.inventoryList,
    required this.timesheetDepList,
  });

  CodeMap<String> findCountryByName(String? name) {
    CodeMap<String> c = CodeMap(name: null, code: null);
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
      storageItems: StateValue(
        error: ErrorModel(),
        data: [],
      ),
      warehouses: StateValue(
        error: ErrorModel(),
        data: [],
      ),
      checklistTemplates: StateValue(
        error: ErrorModel(),
        data: [],
      ),
      drawerStates: DrawerStates(initialIndex: 1, name: const UsersListRoute()),
      paramList: StateValue(
        error: ErrorModel(),
        data: ListAllMd.init(),
      ),
      properties: StateValue(
        error: ErrorModel(),
        data: [],
      ),
      locations: [],
      clientInfos: [],
      quotes: [],
      approvals: ApprovalMd(pendingUserQualifications: [], requests: []),
      inventoryList: [],
      timesheetDepList: [],
    );
  }

  GeneralState copyWith({
    StateValue<ListAllMd>? paramList,
    DrawerStates? drawerStates,
    Widget? endDrawer,
    StateValue<List<WarehouseMd>>? warehouses,
    StateValue<List<StorageItemMd>>? storageItems,
    StateValue<List<ChecklistTemplateMd>>? checklistTemplates,
    StateValue<List<PropertiesMd>>? properties,
    List<LocationAddress>? locations,
    List<ClientInfoMd>? clientInfos,
    List<QuoteInfoMd>? quotes,
    ApprovalMd? approvals,
    List<InventoryMd>? inventoryList,
    List<TimesheetDepMd>? timesheetDepList,
  }) {
    return GeneralState(
      paramList: paramList ?? this.paramList,
      drawerStates: drawerStates ?? this.drawerStates,
      warehouses: warehouses ?? this.warehouses,
      endDrawer: endDrawer,
      storageItems: storageItems ?? this.storageItems,
      checklistTemplates: checklistTemplates ?? this.checklistTemplates,
      properties: properties ?? this.properties,
      locations: locations ?? this.locations,
      clientInfos: clientInfos ?? this.clientInfos,
      quotes: quotes ?? this.quotes,
      approvals: approvals ?? this.approvals,
      inventoryList: inventoryList ?? this.inventoryList,
      timesheetDepList: timesheetDepList ?? this.timesheetDepList,
    );
  }
}

class UpdateGeneralStateAction {
  final StateValue<ListAllMd>? paramList;
  final DrawerStates? drawerStates;
  final Widget? endDrawer;
  final List<LocationsMd>? locationList;
  final StateValue<List<WarehouseMd>>? warehouses;
  final StateValue<List<StorageItemMd>>? storageItems;
  final StateValue<List<ChecklistTemplateMd>>? checklistTemplates;
  final StateValue<List<PropertiesMd>>? properties;
  final List<LocationAddress>? locations;
  final List<ClientInfoMd>? clientInfos;
  final List<QuoteInfoMd>? quotes;
  final ApprovalMd? approvals;
  final List<InventoryMd>? inventoryList;
  final List<TimesheetDepMd>? timesheetDepList;

  UpdateGeneralStateAction({
    this.paramList,
    this.drawerStates,
    this.endDrawer,
    this.locationList,
    this.warehouses,
    this.storageItems,
    this.checklistTemplates,
    this.properties,
    this.locations,
    this.clientInfos,
    this.quotes,
    this.approvals,
    this.inventoryList,
    this.timesheetDepList,
  });
}

class OpenDrawerAction {
  OpenDrawerAction(this.widget);

  final Widget widget;

  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    store.dispatch(UpdateGeneralStateAction(endDrawer: widget));
    await Future.delayed(const Duration(milliseconds: 100));
    if (Constants.scaffoldKey.currentState != null) {
      if (!Constants.scaffoldKey.currentState!.isDrawerOpen) {
        Constants.scaffoldKey.currentState!.openEndDrawer();
      }
    }
  }
}

///Must always be called after all fetched list actions
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
  // static Future<StateValue<List<LocationItemMd>>> fetch(
  //     AppState state, GetAllLocationsAction action, NextDispatcher next) async {
  //   StateValue<List<LocationItemMd>> stateValue = StateValue(
  //       data: [],
  //       error:
  //           ErrorModel<GetAllLocationsAction>(isLoading: true, action: action));
  //
  //   next(UpdateGeneralStateAction(locationItems: stateValue));
  //
  //   final ApiResponse res =
  //       await restClient().getLocationsOrSingle().nocodeErrorHandler();
  //
  //   stateValue.error.errorCode = res.resCode;
  //   stateValue.error.errorMessage = res.resMessage;
  //   stateValue.error.isLoading = false;
  //   stateValue.error.rawError = res.rawError;
  //
  //   if (res.success) {
  //     final List<LocationItemMd> list = res.data
  //         .map<LocationItemMd>((e) => LocationItemMd.fromJson(e))
  //         .toList();
  //     list.sort((a, b) => a.name!.compareTo(b.name!));
  //
  //     stateValue.error.isError = false;
  //     stateValue.data = list;
  //     LocationsController.to.setList(list);
  //   } else {
  //     stateValue.error.retries =
  //         state.generalState.locationItems.error.retries + 1;
  //   }
  //   next(UpdateGeneralStateAction(locationItems: stateValue));
  //   return stateValue;
  // }
}

class GetAllStorageItemsAction {
  static Future<StateValue<List<StorageItemMd>>> fetch(AppState state,
      GetAllStorageItemsAction action, NextDispatcher next) async {
    StateValue<List<StorageItemMd>> stateValue = StateValue(
        data: [],
        error: ErrorModel<GetAllStorageItemsAction>(
            isLoading: true, action: action));

    next(UpdateGeneralStateAction(storageItems: stateValue));

    final ApiResponse res =
        await restClient().getStorageItems().nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final List<StorageItemMd> list = res.data['storageitems']
          .map<StorageItemMd>((e) => StorageItemMd.fromJson(e))
          .toList();
      list.sort((a, b) => a.name.compareTo(b.name));

      stateValue.error.isError = false;
      stateValue.data = list;
      StockItemsController.to.setList(list);
    } else {
      stateValue.error.retries =
          state.generalState.storageItems.error.retries + 1;
    }
    next(UpdateGeneralStateAction(storageItems: stateValue));
    return stateValue;
  }
}

class GetChecklistTemplatesAction {
  static Future<StateValue<List<ChecklistTemplateMd>>> fetch(AppState state,
      GetChecklistTemplatesAction action, NextDispatcher next) async {
    StateValue<List<ChecklistTemplateMd>> stateValue = StateValue(
        data: [],
        error: ErrorModel<GetChecklistTemplatesAction>(
            isLoading: true, action: action));

    next(UpdateGeneralStateAction(checklistTemplates: stateValue));

    final ApiResponse res =
        await restClient().getChecklistTemplates(0).nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;

    if (res.success) {
      final List<ChecklistTemplateMd> list = res.data
          .map<ChecklistTemplateMd>((e) => ChecklistTemplateMd.fromJson(e))
          .toList();
      list.sort((a, b) => a.name.compareTo(b.name));

      stateValue.error.isError = false;
      stateValue.data = list;
      ChecklistController.to.setList(list);
    } else {
      stateValue.error.retries =
          state.generalState.checklistTemplates.error.retries + 1;
    }
    next(UpdateGeneralStateAction(checklistTemplates: stateValue));
    return stateValue;
  }
}

class GetPropertiesAction {
  static Future<StateValue<List<PropertiesMd>>> fetch(
      AppState state, GetPropertiesAction action, NextDispatcher next) async {
    StateValue<List<PropertiesMd>> stateValue = StateValue(
        data: [],
        error:
            ErrorModel<GetPropertiesAction>(isLoading: true, action: action));

    next(UpdateGeneralStateAction(properties: stateValue));

    final ApiResponse res =
        await restClient().getProperties(0.toString()).nocodeErrorHandler();

    stateValue.error.errorCode = res.resCode;
    stateValue.error.errorMessage = res.resMessage;
    stateValue.error.isLoading = false;
    stateValue.error.rawError = res.rawError;
    if (res.success) {
      final List<PropertiesMd> list = [];

      list.addAll(res.data['shifts']
          .map<PropertiesMd>((e) => PropertiesMd.fromJson(e))
          .toList());
      stateValue.error.isError = false;
      stateValue.data = list;
      PropertiesController.to.setList(list);
      next(UpdateScheduleState(
        locationResources: [
          for (int i = 0; i < list.length; i++) list[i],
        ],
      ));
    } else {
      stateValue.error.retries =
          state.generalState.properties.error.retries + 1;
    }
    next(UpdateGeneralStateAction(properties: stateValue));
    return stateValue;
  }

  static Future<List<ShiftStaffReqMd>> fetchShiftStaff(int shiftId) async {
    final List<ShiftStaffReqMd> list = [];

    final ApiResponse res = await restClient()
        .getPropertiesStaff(shiftId.toString())
        .nocodeErrorHandler();
    final data = res.data['staff_requirements'];
    if (res.success) {
      if (data != null) {
        list.addAll(data
            .map<ShiftStaffReqMd>((e) => ShiftStaffReqMd.fromJson(e))
            .toList());
      }
    }
    return list;
  }

  static Future<List<ShiftQualifReqMd>> fetchShiftQualif(int shiftId) async {
    final List<ShiftQualifReqMd> list = [];

    final ApiResponse res = await restClient()
        .getPropertiesQualification(shiftId.toString())
        .nocodeErrorHandler();

    final data = res.data['qualification_requirements'];
    if (res.success) {
      if (data != null) {
        list.addAll(data.map<ShiftQualifReqMd>((e) {
          return ShiftQualifReqMd.fromJson(e);
        }).toList());
      }
    }
    return list;
  }
}

class GetLocationAddressesAction {}

class GetClientInfosAction {
  final int? id;

  GetClientInfosAction({this.id});
}

class GetQuotesAction {
  final int? id;

  GetQuotesAction({this.id});
}

class GetApprovalAction {
  final int? id;

  GetApprovalAction({this.id});
}

class GetInventoryList {
  GetInventoryList();
}

class CreateQuoteAction {
  final int id;
  final String email;
  final String name;
  final String? company;
  final String? phone;
  final String? addressLine1;
  final String? addressLine2;
  final String? addressCity;
  final String? addressCounty;

  //country code
  final String? addressCountry;
  final String? addressPostcode;
  final String? workAddressLine1;
  final String? workAddressLine2;
  final String? workAddressCity;
  final String? workAddressCounty;

  //country code
  final String? workAddressCountry;
  final String? workAddressPostcode;
  final String? notes;
  final int currencyId;
  final int paymentMethodId;
  final int payingDays;
  final bool active;
  final String? workStartDate;
  final String? altWorkStartDate;
  final String? workStartTime;
  final String? workFinishTime;
  final int workRepeatId;
  final String? quoteComments;
  final List<int>? workDays;

  final List<StorageItemMd> storageItems;

  final int? clientId;
  final int? locationId;
  final int? shiftId;
  final int? clientContractId;

  final List<int>? userIds;

  CreateQuoteAction({
    this.id = 0,
    required this.email,
    required this.name,
    required this.storageItems,
    this.company,
    this.phone,
    this.addressLine1,
    this.addressLine2,
    this.addressCity,
    this.addressCounty,
    this.addressCountry,
    this.addressPostcode,
    this.workAddressLine1,
    this.workAddressLine2,
    this.workAddressCity,
    this.workAddressCounty,
    this.workAddressCountry,
    this.workAddressPostcode,
    this.notes,
    required this.currencyId,
    required this.paymentMethodId,
    required this.payingDays,
    required this.active,
    this.workStartDate,
    this.altWorkStartDate,
    this.workStartTime,
    this.workFinishTime,
    required this.workRepeatId,
    this.quoteComments,
    this.clientContractId,
    this.locationId,
    this.clientId,
    this.shiftId,
    this.workDays,
    this.userIds,
  });
}

class OnAddStorageItemAction {
  final BuildContext context;

  OnAddStorageItemAction(this.context);
}

class OnCreateNewStorageItemAction {
  final int id;
  final String title;
  final int? warehouseId;
  final double? customerPrice;
  final int taxId;

  OnCreateNewStorageItemAction({
    this.id = 0,
    required this.title,
    this.warehouseId,
    this.customerPrice,
    required this.taxId,
  });
}

// class OnAddLocationAction {
//   final BuildContext context;
//   final Future<ApiResponse> Function({bool fetchAllParams}) createLocation;
//   final Future<ApiResponse> Function({bool fetchAllParams}) createClient;
//
//   OnAddLocationAction(this.context,
//       {required this.createLocation, required this.createClient});
// }
//
// class OnAddClientAction {
//   final Future<ApiResponse> Function({bool fetchAllParams}) createLocation;
//   final Future<ApiResponse> Function({bool fetchAllParams}) createClient;
//
//   OnAddClientAction({required this.createClient, required this.createLocation});
// }

class OnCreateNewClientTap<T> {
  final ClientFormType type;
  final BuildContext context;
  final ClientInfoMd? clientInfo;
  final QuoteInfoMd? quoteInfo;
  final CreatedTimingReturnValue? timingInfo;

  OnCreateNewClientTap(
    this.context, {
    required this.type,
    this.clientInfo,
    this.timingInfo,
    this.quoteInfo,
  });
}

class CreateJobAction {
  final CreateShiftData data;

  CreateJobAction(this.data);
}

class ChangeQuoteStatusAction {
  final int quoteId;
  final String status;

  ChangeQuoteStatusAction({required this.status, required this.quoteId});
}

class GetTimesheetDepListAction {
  GetTimesheetDepListAction();
}
