import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/router/router.gr.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/locations_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/custom_get_builder.dart';
import '../../manager/models/location_item_md.dart';
import '../../theme/theme.dart';

class LocationsListPage extends StatelessWidget {
  const LocationsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          PagesTitleWidget(
            btnText: "New Location",
            title: 'Locations',
            onRightBtnClick: () async {
              context.navigateTo(const NewLocationRoute());
            },
          ),
          ErrorWrapper(errors: [
            state.generalState.paramList.error,
            state.generalState.locationItems.error
          ], child: _Body())
        ]),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GBuilder<LocationsController>(
        child: (controller) => TableWrapperWidget(
              child: SizedBox(
                  width: double.infinity,
                  child: SpacedColumn(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(context, controller),
                      _body(controller),
                      const Divider(
                        color: ThemeColors.gray11,
                        thickness: 1.0,
                      ),
                      if (controller.isSmLoaded) _footer(controller),
                    ],
                  )),
            ));
  }

  Widget _header(BuildContext context, LocationsController controller) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInputWidget(
              controller: controller.searchController,
              hintText: 'Search locations...',
              defaultBorderColor: ThemeColors.gray11,
              width: 360,
              leftIcon: HeroIcons.search),
          SpacedRow(horizontalSpace: 16.0, children: [
            AnimatedOpacity(
              opacity: controller.deleteBtnOpacity,
              duration: const Duration(milliseconds: 100),
              child: ButtonMedium(
                bgColor: ThemeColors.red3,
                text: "Delete Selected",
                icon: const HeroIcon(
                  HeroIcons.bin,
                  size: 20,
                ),
                onPressed: controller.deleteSelectedRows,
              ),
            ),
            ButtonMediumSecondary(
              text: "View All Locations",
              leftIcon: const HeroIcon(HeroIcons.pin,
                  size: 20, color: ThemeColors.blue3),
              onPressed: () {},
            ),
            TableColumnHiderWidget(
              gKey: controller.columnsMenuKey,
              columns: controller.columnHideValues,
              onChanged: controller.onColumnHide,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body(LocationsController controller) {
    return UsersListTable(
      onSmReady: controller.setSm,
      rows: controller.departments.reactive.value
              ?.map<PlutoRow>(_buildItem)
              .toList() ??
          [],
      cols: controller.columns(),
    );
  }

  PlutoRow _buildItem(LocationItemMd e) {
    return PlutoRow(cells: {
      "location_name": PlutoCell(value: e.name ?? "-"),
      "address":
          PlutoCell(value: e.anywhere! ? "Anywhere" : e.address?.line1 ?? "-"),
      "contact": PlutoCell(value: e.email ?? "-"),
      "required_staff": PlutoCell(value: e.members),
      "ip_address": PlutoCell(value: e.ipaddress ?? "Not Specified"),
      "status": PlutoCell(
          value: e.active != null && e.active! ? "active" : "inactive"),
      "action": PlutoCell(value: e),
    });
  }

  Widget _footer(LocationsController controller) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 32.0, top: 16.0, bottom: 16.0),
      child: SpacedRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedRow(
                horizontalSpace: 8.0,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KText(
                      text: "Showing",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                  DropdownWidget(
                    hintText: "Entries",
                    items: Constants.tablePageSizes
                        .map<String>((e) => e.toString())
                        .toList(),
                    dropdownBtnWidth: 120,
                    onChanged: controller.onPageSizeChange,
                    value: controller.pageSize.toString(),
                  ),
                  // MyWidget(),
                  KText(
                      text: "of ${controller.departments.length} entries",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                ]),
            TablePaginationWidget(
                currentPage: controller.page,
                totalPages: controller.gridStateManager.totalPage,
                onPageChanged: controller.onPageChange),
          ]),
    );
  }
}
