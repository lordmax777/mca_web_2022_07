import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/models/location_item_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/new_location_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../manager/router/router.gr.dart';
import '../../../theme/theme.dart';
import '../../home_page.dart';

class LocationsController extends GetxController {
  static LocationsController get to => Get.find();

  //UI Variables
  final RxDouble _deleteBtnOpacity = 0.5.obs;

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
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onColumnItemNavigate(ctx),
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
              textColor: ThemeColors.blue3,
              fontWeight: FWeight.regular,
              fontSize: 14,
              isSelectable: false,
              onTap: () => _onColumnItemNavigate(ctx),
              icon: const HeroIcon(
                HeroIcons.edit,
                color: ThemeColors.blue3,
                size: 12,
              ),
            );
          }),
    ];
  }

  double get deleteBtnOpacity => _deleteBtnOpacity.value;
  set setDeleteBtnOpacity(double value) {
    _deleteBtnOpacity.value = value;
  }

  void onColumnHide(ColumnHiderValues value) {
    PlutoColumn c = gridStateManager.refColumns.originalList
        .firstWhere((e) => e.field == value.value);
    gridStateManager.hideColumn(c, !value.isChecked);
  }

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    gridStateManager.setOnRowChecked((event) {
      if (gridStateManager.checkedRows.isNotEmpty) {
        setDeleteBtnOpacity = 1.0;
      } else {
        setDeleteBtnOpacity = 0.5;
      }
    });
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
        name: Constants.userAccountStatusTypes[loc.active!]!,
        code: loc.active!.toString());
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
    final country =
        appStore.state.generalState.findCountryByName(loc.address?.country);
    newContr.setCountry = country;
    newContr.countyController.text = loc.address?.county ?? "";
    newContr.radiusController.text = loc.address?.radius?.toString() ?? "";
    newContr.latitudeController.text = loc.address?.latitude?.toString() ?? "";
    newContr.longitudeController.text =
        loc.address?.longitude?.toString() ?? "";

    appRouter.navigate(const NewLocationRoute());
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
