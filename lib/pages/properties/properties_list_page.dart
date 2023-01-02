import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/custom_get_builder.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';
import 'package:mca_web_2022_07/pages/properties/new_property_page.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/models/property_md.dart';
import '../../theme/theme.dart';
import 'controllers/properties_controller.dart';

class PropertiesPage extends StatelessWidget {
  const PropertiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          const PagesTitleWidget(title: 'Properties'),
          ErrorWrapper(errors: [
            state.generalState.paramList.error,
            state.generalState.properties.error,
          ], child: const _Body())
        ]),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GBuilder<PropertiesController>(
      child: (c) => TableWrapperWidget(
          child: SizedBox(
        width: double.infinity,
        child: SpacedColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context, c),
            _body(context, c),
            const Divider(
              color: ThemeColors.gray11,
              thickness: 1.0,
            ),
            if (c.isSmLoaded) _footer(c),
          ],
        ),
      )),
    );
  }

  Widget _header(BuildContext context, PropertiesController c) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInputWidget(
              controller: c.searchController,
              hintText: 'Search properties...',
              defaultBorderColor: ThemeColors.gray11,
              width: 360,
              leftIcon: HeroIcons.search),
          SpacedRow(
              horizontalSpace: 16.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomCheckboxWidget(
                  isChecked: c.isShowInactive,
                  onChanged: c.setShowInactive,
                  label: "Show inactive",
                  labelPosition: CheckboxLabelPosition.left,
                ),
                ButtonMedium(
                  text: "New Property",
                  icon: const HeroIcon(HeroIcons.plusCircle, size: 20),
                  onPressed: () {
                    context.pushRoute(NewPropertyRoute());
                  },
                ),
              ]),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, PropertiesController c) {
    return UsersListTable(
      onSmReady: c.setSm,
      rows: c.departments
          .map<PlutoRow>(
            _buildItem,
          )
          .toList(),
      cols: c.columns(context),
    );
  }

  PlutoRow _buildItem(PropertiesMd e) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: e.title ?? "-"),
      "location": PlutoCell(value: e.locationName ?? "-"),
      "client": PlutoCell(value: e.clientName ?? "-"),
      "warehouse": PlutoCell(value: e.warehouseName ?? "-"),
      "status": PlutoCell(value: (e.active ?? false) ? "active" : "inactive"),
      "action": PlutoCell(value: e),
    });
  }

  Widget _footer(PropertiesController c) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 32.0, top: 4.0, bottom: 4.0),
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
                    onChanged: c.onPageSizeChange,
                    value: c.gridStateManager.pageSize.toString(),
                  ),
                  // MyWidget(),
                  KText(
                      text: "of ${c.departments.length} entries",
                      textColor: ThemeColors.black,
                      fontSize: 14.0,
                      isSelectable: false),
                ]),
            TablePaginationWidget(
                currentPage: c.gridStateManager.page,
                totalPages: c.gridStateManager
                    .totalPage, //(widget._itemCount / _pageSize).ceil(),
                onPageChanged: c.onPageChange),
          ]),
    );
  }
}
