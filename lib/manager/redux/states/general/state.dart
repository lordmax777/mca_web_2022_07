import 'package:equatable/equatable.dart';
import 'package:mca_dashboard/manager/data/data.dart';

export 'mw.dart';
export 'actions/login_action.dart';
export 'actions/formats_action.dart';
export 'actions/clear_data_action.dart';
export 'actions/users_action.dart';
export 'actions/fetch_lists_action.dart';
export 'actions/init_actions_action.dart';
export 'actions/locations_action.dart';
export 'actions/storage_items_action.dart';
export 'actions/properties_action.dart';
export 'actions/user_reviews_action.dart';
export 'actions/clients_action.dart';
export 'actions/create_user_review_action.dart';
export 'actions/delete_user_review_action.dart';
export 'actions/refresh_token_action.dart';
export 'actions/company_info_md.dart';
export 'actions/quotes_action.dart';
export 'actions/warehouses_action.dart';
export 'actions/allocations_action.dart';
export 'actions/appointment_action.dart';
export 'actions/unavailable_user_list_action.dart';
export 'actions/post_quote_action.dart';
export 'actions/post_client_action.dart';
export 'actions/change_quote_status_action.dart';
export 'actions/send_quote_email_action.dart';
export 'actions/get_client_contract_items_action.dart';
export 'actions/get_propertydetails_action.dart';
export 'actions/post_propertydetails_action.dart';
export 'actions/post_allocation_action.dart';
export 'actions/get_details_action.dart';
export 'actions/post_user_details_action.dart';
export 'actions/get_user_details_action.dart';
export 'actions/get_user_contracts_action.dart';
export 'actions/post_user_contract_action.dart';
export 'actions/delete_user_contract_action.dart';
export 'actions/group_action.dart';
export 'actions/job_title_action.dart';
export 'actions/qualification_action.dart';
export 'actions/storage_item_action.dart';
export 'actions/user_pref_shift_action.dart';
export 'actions/user_qualif_action.dart';
export 'actions/user_status_action.dart';
export 'actions/user_visa_action.dart';
export 'actions/warehouse_action.dart';

class GeneralState extends Equatable {
  final FormatMd formatMd;
  final List<UserMd> users;
  final ListMd lists;
  final List<LocationMd> locations;
  final List<StorageItemMd> storageItems;
  final List<ClientMd> clients;
  final List<PropertyMd> properties;
  final List<QuoteMd> quotes;
  final List<WarehouseMd> warehouses;
  final CompanyInfoMd companyInfo;
  final List<AllocationMd> allocations;
  String get propertyName => companyInfo.specialWord;
  final DetailsMd detailsMd;
  final List<ChecklistTemplateMd> checklistTemplates;
  final ApprovalMd approvals;

  List<LocationMd> clientBasedFullLocations(int? clientId) {
    final clientLocs = lists.clientRelatedLocation(clientId);
    final locs = locations
        .where((loc) => clientLocs.any((element) => element.id == loc.id))
        .toList();

    return locs;
  }

  const GeneralState({
    required this.formatMd,
    required this.users,
    required this.lists,
    required this.locations,
    required this.storageItems,
    required this.quotes,
    required this.clients,
    required this.properties,
    required this.warehouses,
    required this.companyInfo,
    required this.allocations,
    required this.detailsMd,
    required this.checklistTemplates,
    required this.approvals,
  });

  factory GeneralState.initial() {
    return GeneralState(
        formatMd: FormatMd.init(),
        lists: ListMd.init(),
        users: [],
        locations: [],
        storageItems: [],
        clients: [],
        properties: [],
        quotes: [],
        warehouses: [],
        companyInfo: CompanyInfoMd.init(),
        allocations: [],
        detailsMd: DetailsMd.init(),
        checklistTemplates: [],
        approvals: ApprovalMd(
          acknowledgeables: [],
          pendingUserQualifications: [],
          problems: [],
          releaseables: [],
          requests: [],
          closedRequests: [],
        ));
  }

  GeneralState copyWith({
    FormatMd? formatMd,
    List<UserMd>? users,
    ListMd? lists,
    List<LocationMd>? locations,
    List<StorageItemMd>? storageItems,
    List<ClientMd>? clients,
    List<PropertyMd>? properties,
    List<QuoteMd>? quotes,
    List<WarehouseMd>? warehouses,
    CompanyInfoMd? companyInfo,
    List<AllocationMd>? allocations,
    DetailsMd? detailsMd,
    List<ChecklistTemplateMd>? checklistTemplates,
    ApprovalMd? approvals,
  }) {
    return GeneralState(
      formatMd: formatMd ?? this.formatMd,
      users: users ?? this.users,
      lists: lists ?? this.lists,
      locations: locations ?? this.locations,
      storageItems: storageItems ?? this.storageItems,
      clients: clients ?? this.clients,
      properties: properties ?? this.properties,
      quotes: quotes ?? this.quotes,
      warehouses: warehouses ?? this.warehouses,
      companyInfo: companyInfo ?? this.companyInfo,
      allocations: allocations ?? this.allocations,
      detailsMd: detailsMd ?? this.detailsMd,
      checklistTemplates: checklistTemplates ?? this.checklistTemplates,
      approvals: approvals ?? this.approvals,
    );
  }

  @override
  List<Object?> get props => [
        formatMd,
        users,
        lists,
        locations,
        storageItems,
        clients,
        properties,
        quotes,
        warehouses,
        companyInfo,
        allocations,
        detailsMd,
        checklistTemplates,
        approvals,
      ];
}

class UpdateGeneralState {
  final bool isReset;
  final FormatMd? formatMd;
  final List<UserMd>? users;
  final ListMd? lists;
  final List<LocationMd>? locations;
  final List<StorageItemMd>? storageItems;
  final List<ClientMd>? clients;
  final List<PropertyMd>? properties;
  final List<QuoteMd>? quotes;
  final List<WarehouseMd>? warehouses;
  final CompanyInfoMd? companyInfo;
  final List<AllocationMd>? allocations;
  final DetailsMd? detailsMd;
  final List<ChecklistTemplateMd>? checklistTemplates;
  final ApprovalMd? approvals;

  const UpdateGeneralState({
    this.isReset = false,
    this.formatMd,
    this.users,
    this.lists,
    this.locations,
    this.storageItems,
    this.clients,
    this.properties,
    this.quotes,
    this.warehouses,
    this.companyInfo,
    this.allocations,
    this.detailsMd,
    this.checklistTemplates,
    this.approvals,
  });
}
