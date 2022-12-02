// ignore_for_file: invalid_use_of_protected_member
import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/models/location_item_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/new_location_controller.dart';
import '../../../comps/custom_gmaps_widget.dart';
import '../../../manager/router/router.dart';
import '../../../theme/theme.dart';

class LocationsController extends GetxController {
  static LocationsController get to => Get.find();

  final GlobalKey columnsMenuKey = GlobalKey();
  final RxList<ColumnHiderValues> _columnHideValues =
      List<ColumnHiderValues>.empty().obs;
  List<ColumnHiderValues> get columnHideValues => _columnHideValues;
  final RxInt _pageSize = 10.obs;
  final RxInt _page = 1.obs;
  int get page => _page.value;
  int get pageSize => _pageSize.value;
  set setPage(int value) => _page.value = value;
  set setPageSize(int value) => _pageSize.value = value;
  final RxBool _isSmLoaded = false.obs;
  bool get isSmLoaded => _isSmLoaded.value;
  set setIsSmLoaded(bool value) => _isSmLoaded.value = value;
  List<PlutoColumn> columns() {
    return [
      PlutoColumn(
        width: 300.0,
        title: "Location Name",
        field: "location_name",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          width: 360.0,
          title: "Address",
          field: "address",
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            final address = ctx.cell.value.toString();
            final bool anywhere = address.contains("Anywhere");
            if (anywhere) {
              return GridTableHelpers.getMainColoredRenderer(ctx);
            }
            return GridTableHelpers.getMainColoredRenderer(ctx,
                onTap: (PlutoColumnRendererContext x) => _onShowMap(x));
          }),
      PlutoColumn(
          width: 300.0,
          title: "Contact",
          field: "contact",
          type: PlutoColumnType.text()),
      PlutoColumn(
        width: 250.0,
        title: "Required Staff",
        field: "required_staff",
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          final List<Members> members = rendererContext.cell.value ?? [];
          if (members.isEmpty) {
            return GridTableHelpers.getMainColoredRenderer(rendererContext,
                title: "No Staff");
          }
          return TableTooltipWidget1(
            title: "Staff: ${members.length}",
            children: [
              for (Members member in members)
                UsersListTable.defaultTextWidget(
                    "${member.name}: ${member.min ?? ""} - ${member.max ?? ""}"),
            ],
          );
        },
      ),
      PlutoColumn(
          width: 250.0,
          title: "IP Address",
          field: "ip_address",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            if (rendererContext.cell.value.runtimeType == String) {
              return GridTableHelpers.getMainColoredRenderer(rendererContext);
            }
            final List<IpAddress> ips = rendererContext.cell.value ?? [];
            if (ips.isEmpty) {
              return GridTableHelpers.getMainColoredRenderer(rendererContext,
                  title: "Not Specified");
            }
            return TableTooltipWidget1(
              title: "IP(s): ${ips.length}",
              children: [
                for (IpAddress member in ips)
                  UsersListTable.defaultTextWidget("${member.ipAddress}"),
              ],
            );
          }),
      PlutoColumn(
        title: "Status",
        field: "status",
        enableSorting: false,
        type: PlutoColumnType.text(),
        renderer: GridTableHelpers.getStatusRenderer,
      ),
      PlutoColumn(
        title: "Action",
        field: "action",
        enableSorting: false,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) => GridTableHelpers.getActionRenderer(
          rendererContext,
          onTap: (PlutoColumnRendererContext ctx) => _onColumnItemNavigate(ctx),
        ),
      ),
    ];
  }

  final RxList<LocationItemMd> _deps = <LocationItemMd>[].obs;
  void removeDepsWhere(LocationItemMd w) =>
      _deps.removeWhere((e) => e.id == w.id);
  List<LocationItemMd> get departments => _deps;
  setList(List<LocationItemMd> d) {
    final dd = [...d];
    dd.sort((a, b) => a.name!.compareTo(b.name!));
    _deps.value = dd;
    return _deps;
  }

  final TextEditingController searchController = TextEditingController();
  late PlutoGridStateManager gridStateManager;
  final List<PlutoRow> inactiveRows = [];
  final RxBool _isShowInactive = false.obs;
  bool get isShowInactive => _isShowInactive.value;
  void setShowInactive(bool val) {
    if (val) {
      gridStateManager.appendRows(inactiveRows);
    } else {
      gridStateManager.removeRows(inactiveRows);
    }
    // ignore: invalid_use_of_visible_for_testing_member
    searchController.notifyListeners();
    _isShowInactive.value = val;
    update();
  }

  void onColumnHide(ColumnHiderValues value) {
    PlutoColumn c = gridStateManager.refColumns.originalList
        .firstWhere((e) => e.field == value.value);
    gridStateManager.hideColumn(c, !value.isChecked);
  }

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    inactiveRows.addAll(gridStateManager.refRows.where((element) =>
        !(element.cells["action"]!.value as LocationItemMd).active!));
    if (!isShowInactive) {
      gridStateManager.removeRows(inactiveRows);
    }
    gridStateManager.setPage(0);
    gridStateManager.setPageSize(10);
    gridStateManager.setPage(page);
    _setFilter();
    setIsSmLoaded = true;
  }

  void _setFilter() {
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        if (gridStateManager.page > 1) {
          gridStateManager.setPage(1);
        }
        gridStateManager.setFilter(
          (element) {
            final String search = searchController.text.toLowerCase();
            bool searched = element.cells['location_name']?.value
                .toLowerCase()
                .contains(search);
            if (!searched) {
              searched = element.cells['address']?.value
                  .toLowerCase()
                  .contains(search);
              if (!searched) {
                searched = element.cells['contact']?.value
                    .toLowerCase()
                    .contains(search);
                if (!searched) {
                  if (element.cells['ip_address']?.value.runtimeType !=
                      String) {
                    searched = (element.cells['ip_address']?.value
                            as List<IpAddress>)
                        .any((element) =>
                            element.ipAddress?.toLowerCase().contains(search) ??
                            false);
                  }
                  if (!searched) {
                    searched = element.cells['status']?.value
                        .toLowerCase()
                        .contains(search);
                    if (!searched) {
                      if (element.cells['required_staff']?.value.runtimeType !=
                          String) {
                        searched = (element.cells['required_staff']?.value
                                as List<Members>)
                            .any((element) =>
                                element.name?.toLowerCase().contains(search) ??
                                false);
                      }
                    }
                  }
                }
              }
            }
            return searched;
          },
        );
        onPageChange(gridStateManager.page);
        onPageSizeChange(gridStateManager.pageSize.toString());
        return;
      }

      gridStateManager.setFilter((element) => true);
      onPageChange(gridStateManager.page);
      onPageSizeChange(gridStateManager.pageSize.toString());
    });
  }

  void onPageSizeChange(pageS) {
    setPageSize = int.parse(pageS);
    gridStateManager.setPageSize(pageSize);
    gridStateManager.setPage(1);
    setPage = 1;
    update();
  }

  void onPageChange(int page) {
    setPage = page;
    gridStateManager.setPage(page);
    update();
  }

  Future<void> _onColumnItemNavigate(PlutoColumnRendererContext ctx) async {
    final LocationItemMd loc = ctx.cell.value;
    final newContr = NewLocationController.to;
    newContr.setId = loc.id ?? -1;
    newContr.nameController.text = loc.name ?? "";
    newContr.setStatus = CodeMap(
        name: Constants.userAccountStatusTypes[loc.active!]!, code: loc.active);
    newContr.setIsLocationBound = loc.anywhere!;
    newContr.ipAddressesController.text = "";
    if (loc.ipaddress != null && loc.ipaddress!.isNotEmpty) {
      final str = loc.ipaddress!.map((e) => e.ipAddress).join(",");
      newContr.ipAddressesController.text = str;
    }
    newContr.setIsFixedIpAddress = loc.fixedipaddress!;
    newContr.emailController.text = loc.email ?? "";
    newContr.phoneController.text = loc.phone?.mobile ?? "";
    newContr.landlineController.text = loc.phone?.landline ?? "";
    newContr.faxController.text = loc.phone?.fax ?? "";
    // newContr.setIsSendChecklist = loc.  //TODO: check this
    newContr.streetController.text = loc.address?.line1 ?? "";
    newContr.cityController.text = loc.address?.city ?? "";
    newContr.postCodeController.text = loc.address?.postcode ?? "";
    final CodeMap<String> country =
        appStore.state.generalState.findCountryByName(loc.address?.country);
    newContr.setCountry = country;
    newContr.countyController.text = loc.address?.county ?? "";
    newContr.radiusController.text = loc.address?.radius?.toString() ?? "";
    newContr.latitudeController.text = loc.address?.latitude?.toString() ?? "";
    newContr.longitudeController.text =
        loc.address?.longitude?.toString() ?? "";

    appRouter.navigate(const NewLocationRoute());
  }

  Future<void> _onShowMap(PlutoColumnRendererContext ctx) async {
    final LocationItemMd loc = ctx.row.cells['action']!.value;
    showMapPopup(location: loc);
  }

  //Functions
  @override
  void onInit() {
    super.onInit();
    _columnHideValues.clear();
    _columnHideValues.addAll(columns()
        .skipWhile((value) => value.hide)
        .toList()
        .map<ColumnHiderValues>(
            (e) => ColumnHiderValues(value: e.field, label: e.title))
        .toList());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
