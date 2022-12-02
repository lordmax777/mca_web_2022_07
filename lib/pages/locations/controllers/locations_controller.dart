import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/models/location_item_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/new_location_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../comps/custom_gmaps_widget.dart';
import '../../../comps/dropdown_widget1.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../manager/router/router.dart';
import '../../../theme/theme.dart';

class LocationsController extends GetxController {
  static LocationsController get to => Get.find();

  //UI Variables
  final GlobalKey columnsMenuKey = GlobalKey();

  final Rx<CodeMap<bool>> _status = CodeMap<bool>(name: null, code: null).obs;
  CodeMap<bool> get status => _status.value;
  set setStatus(CodeMap<bool> value) => _status.value = value;
  final RxDouble _deleteBtnOpacity = 0.5.obs;
  double get deleteBtnOpacity => _deleteBtnOpacity.value;
  set setDeleteBtnOpacity(double value) {
    _deleteBtnOpacity.value = value;
  }

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

  final TextEditingController searchController = TextEditingController();

  late PlutoGridStateManager gridStateManager;
  List<PlutoColumn> columns() {
    return [
      PlutoColumn(
        width: 300.0,
        title: "Location Name",
        field: "location_name",
        enableRowChecked: true,
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
              return KText(
                text: ctx.cell.value,
                textColor: ThemeColors.black,
                fontWeight: FWeight.regular,
                fontSize: 14,
                isSelectable: false,
              );
            }
            return KText(
              text: ctx.cell.value,
              textColor: ThemeColors.MAIN_COLOR,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onShowMap(ctx),
            );
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
            return KText(
              text: "No Staff",
              textColor: ThemeColors.gray5,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
            );
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
              return KText(
                text: rendererContext.cell.value,
                textColor: ThemeColors.gray5,
                fontWeight: FWeight.regular,
                fontSize: 14,
                isSelectable: false,
              );
            }
            final List<IpAddress> ips = rendererContext.cell.value ?? [];
            if (ips.isEmpty) {
              return KText(
                text: "Not Specified",
                textColor: ThemeColors.gray5,
                fontWeight: FWeight.regular,
                fontSize: 14,
                isSelectable: false,
              );
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
        // width: 85.0,
        title: "Status",
        field: "status",
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          final Color color = rendererContext.cell.value == "active"
              ? ThemeColors.green2
              : ThemeColors.gray8;
          return SpacedRow(
              horizontalSpace: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                UsersListTable.defaultTextWidget(rendererContext.cell.value
                    .toString()
                    .replaceFirst(rendererContext.cell.value.toString()[0],
                        rendererContext.cell.value.toString()[0].toUpperCase()))
              ]);
        },
      ),
      PlutoColumn(
          title: "Action",
          field: "action",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return KText(
              text: "Edit",
              textColor: ThemeColors.MAIN_COLOR,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onColumnItemNavigate(ctx),
              icon: HeroIcon(
                HeroIcons.edit,
                color: ThemeColors.MAIN_COLOR,
                size: 12,
              ),
            );
          }),
    ];
  }

  void onColumnHide(ColumnHiderValues value) {
    PlutoColumn c = gridStateManager.refColumns.originalList
        .firstWhere((e) => e.field == value.value);
    gridStateManager.hideColumn(c, !value.isChecked);
  }

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    gridStateManager.setPage(0);
    gridStateManager.setPageSize(10);
    gridStateManager.setPage(page);
    _setFilter();
    setIsSmLoaded = true;
  }

  void onOneTapSelect(PlutoGridOnSelectedEvent event) {
    gridStateManager.toggleAllRowChecked(false);
    event.row!.setChecked(!event.row!.checked!);
    if (gridStateManager.checkedRows.isNotEmpty) {
      final item = event.row!.cells['action']!.value as LocationItemMd;
      setStatus = CodeMap(
        name: Constants.userAccountStatusTypes[item.active],
        code: item.active,
      );
      setDeleteBtnOpacity = 1.0;
    } else {
      setDeleteBtnOpacity = 0.5;
      resetStatus;
    }
  }

  Future<void> onStatusChange(DpItem value, BuildContext context) async {
    final List<PlutoRow> selectedRows = gridStateManager.checkedRows;
    if (selectedRows.isEmpty) {
      showError("Please select at least one item!");
      return;
    }
    if (gridStateManager.checkedRows.length > 1) {
      final ids = gridStateManager.checkedRows
          .map<int>((e) => e.cells['action']?.value.id)
          .toList();
      showLoading();
      bool allSuccess = true;
      ApiResponse? resp;
      for (int i = 0; i < ids.length; i++) {
        final updateableItem =
            selectedRows[i].cells['action']!.value as LocationItemMd;

        updateableItem.active = (value.item as MapEntry<bool, String>).key;

        final ApiResponse res = await restClient()
            .updateLocation(
              id: updateableItem.id,
              active: updateableItem.active!,
              name: updateableItem.name!,
              timelimit: false,
              base: false,
              sendChecklist: false, //TODO: check this
              latitude: updateableItem.address!.latitude!.toString(),
              longitude: updateableItem.address!.longitude!.toString(),
              radius: updateableItem.address!.radius!.toString(),
              anywhere: updateableItem.anywhere!,
              fixedipaddress: updateableItem.fixedipaddress!,
              addressCity: updateableItem.address!.city,
              addressCountry: updateableItem.address!.country,
              addressCounty: updateableItem.address!.county,
              addressLine1: updateableItem.address!.line1,
              addressLine2: updateableItem.address!.line2,
              addressPostcode: updateableItem.address!.postcode,
              phoneLandline: updateableItem.phone!.landline,
              phoneMobile: updateableItem.phone!.mobile,
              phoneFax: updateableItem.phone!.fax,
              email: updateableItem.email,
            )
            .nocodeErrorHandler();
        if (!res.success) {
          allSuccess = false;
          resp = res;
          break;
        }
      }

      if (allSuccess) {
        gridStateManager.toggleAllRowChecked(false);
        resetStatus;
        searchController.clear();
        setDeleteBtnOpacity = 0.5;
        await appStore.dispatch(GetAllLocationsAction());
        closeLoading();
      } else {
        await closeLoading();
        showError(resp?.rawError?.data.toString() ?? "Error");
      }

      return;
    }
    final updateableItem =
        selectedRows[0].cells['action']!.value as LocationItemMd;
    final isActive =
        updateableItem.active == (value.item as MapEntry<bool, String>).key;

    if (isActive) {
      return;
    }
    showLoading();
    final ApiResponse res = await restClient()
        .updateLocation(
          id: updateableItem.id,
          active: (value.item as MapEntry<bool, String>).key,
          name: updateableItem.name!,
          timelimit: false,
          base: false,
          sendChecklist: false, //TODO: check this
          latitude: updateableItem.address!.latitude!.toString(),
          longitude: updateableItem.address!.longitude!.toString(),
          radius: updateableItem.address!.radius!.toString(),
          anywhere: updateableItem.anywhere!,
          fixedipaddress: updateableItem.fixedipaddress!,
          addressCity: updateableItem.address!.city,
          addressCountry: updateableItem.address!.country,
          addressCounty: updateableItem.address!.county,
          addressLine1: updateableItem.address!.line1,
          addressLine2: updateableItem.address!.line2,
          addressPostcode: updateableItem.address!.postcode,
          email: updateableItem.email,
          phoneFax:
              updateableItem.anywhere! ? "11111111" : updateableItem.phone!.fax,
          phoneMobile: updateableItem.anywhere!
              ? "11111111"
              : updateableItem.phone!.mobile,
          phoneLandline: updateableItem.anywhere!
              ? "11111111"
              : updateableItem.phone!.landline,
        )
        .nocodeErrorHandler();

    await closeLoading();

    if (res.success) {
      searchController.clear();

      gridStateManager.toggleAllRowChecked(false);

      context.popRoute();

      await appStore.dispatch(GetAllLocationsAction());
      resetStatus;
    } else {
      showError(res.data);
    }
  }

  void _setFilter() {
    searchController.addListener(() {
      gridStateManager.toggleAllRowChecked(false);
      setDeleteBtnOpacity = 0.5;
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
    newContr.setIsLocationBound = !loc.anywhere!;
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

  Future<void> deleteSelectedRows() async {
    final ids = gridStateManager.checkedRows
        .map<int>((e) => e.cells['action']?.value.id)
        .toList();
    if (ids.isEmpty) return;
    showLoading();
    bool allSuccess = true;
    ApiResponse? resp;
    for (int i = 0; i < ids.length; i++) {
      final id = ids[i];
      final ApiResponse res =
          await restClient().deleteLocation(id).nocodeErrorHandler();
      if (!res.success) {
        allSuccess = false;
        resp = res;
        break;
      } else {
        _deps.removeWhere((element) => element.id == id);
      }
    }

    if (allSuccess) {
      gridStateManager.removeRows(gridStateManager.checkedRows);
      gridStateManager.toggleAllRowChecked(false);
      setDeleteBtnOpacity = 0.5;
      // await appStore.dispatch(GetAllLocationsAction());
      closeLoading();
    } else {
      await closeLoading();
      showError(resp?.rawError?.data.toString() ?? "Error");
    }
    update();
  }

  //Departments
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

  void get resetStatus {
    setStatus = CodeMap<bool>(
      name: null,
      code: null,
    );
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
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
