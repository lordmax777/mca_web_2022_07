import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/models/list_all_md.dart';
import '../../theme/theme.dart';
import 'controllers/deps_list_controller.dart';

class DepartmentsTab extends GetView<DepartmentsController> {
  // final List<Map> items = [
  //   {
  //     "department_name": "Cleaners",
  //     "status": 0,
  //   },
  //   {
  //     "department_name": "Finance",
  //     "status": 1,
  //   },
  //   {
  //     "department_name": "Managers",
  //     "status": 1,
  //   },
  //   {
  //     "department_name": "Logistics",
  //     "status": 0,
  //   },
  // ];
  // late PlutoGridStateManager usersPageStateManger;
  // final TextEditingController _searchController = TextEditingController();

  // List<PlutoColumn> get _cols {
  //   return [
  //     PlutoColumn(
  //       title: "department",
  //       field: "department",
  //       type: PlutoColumnType.text(),
  //       hide: true,
  //     ),
  //     PlutoColumn(
  //         title: "Department Name",
  //         field: "department_name",
  //         enableRowChecked: true,
  //         type: PlutoColumnType.text(),
  //         renderer: (ctx) {
  //           return KText(
  //             text: ctx.cell.value,
  //             textColor: ThemeColors.blue3,
  //             fontWeight: FWeight.regular,
  //             fontSize: 14,
  //             mainAxisSize: MainAxisSize.min,
  //             isSelectable: false,
  //             onTap: () => _onUserDetailsNavigationClick(ctx),
  //           );
  //         }),
  //     PlutoColumn(
  //       width: 700,
  //       title: "",
  //       field: "space",
  //       readOnly: true,
  //       type: PlutoColumnType.text(),
  //       enableSorting: false,
  //     ),
  //     PlutoColumn(
  //       title: "Status",
  //       field: "status",
  //       type: PlutoColumnType.text(),
  //       renderer: (rendererContext) {
  //         final Color color = rendererContext.cell.value == "active"
  //             ? ThemeColors.green2
  //             : ThemeColors.gray8;
  //         return SpacedRow(
  //             horizontalSpace: 8,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Container(
  //                 width: 8,
  //                 height: 8,
  //                 decoration:
  //                     BoxDecoration(color: color, shape: BoxShape.circle),
  //               ),
  //               UsersListTable.defaultTextWidget(rendererContext.cell.value
  //                   .toString()
  //                   .replaceFirst(rendererContext.cell.value.toString()[0],
  //                       rendererContext.cell.value.toString()[0].toUpperCase()))
  //             ]);
  //       },
  //     ),
  //     PlutoColumn(
  //         title: "Action",
  //         field: "action",
  //         enableSorting: false,
  //         type: PlutoColumnType.text(),
  //         renderer: (ctx) {
  //           return KText(
  //             text: "Edit",
  //             textColor: ThemeColors.blue3,
  //             fontWeight: FWeight.regular,
  //             fontSize: 14,
  //             isSelectable: false,
  //             onTap: () => _onUserDetailsNavigationClick(ctx),
  //             icon: const HeroIcon(
  //               HeroIcons.edit,
  //               color: ThemeColors.blue3,
  //               size: 12,
  //             ),
  //           );
  //         }),
  //   ];
  // }

  // void _setSm(PlutoGridStateManager sm) {
  //   setState(() {
  //     usersPageStateManger = sm;
  //     _setFilter();
  //   });
  // }

  // void _setFilter() {
  //   _searchController.addListener(() {
  //     if (_searchController.text.isNotEmpty) {
  //       usersPageStateManger.setFilter(
  //         (element) {
  //           bool searched = element.cells['department_name']?.value
  //               .toLowerCase()
  //               .contains(_searchController.text.toLowerCase());
  //           if (!searched) {
  //             searched = element.cells['status']?.value
  //                 .toLowerCase()
  //                 .contains(_searchController.text.toLowerCase());
  //           }
  //           return searched;
  //         },
  //       );
  //       return;
  //     }
  //
  //     usersPageStateManger.setFilter((element) => true);
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

  // Future<void> _onUserDetailsNavigationClick(
  //     PlutoColumnRendererContext ctx) async {
  //   appStore
  //       .dispatch(UpdateGeneralStateAction(endDrawer: const DepGroupDrawer()));
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   if (scaffoldKey.currentState != null) {
  //     if (!scaffoldKey.currentState!.isDrawerOpen) {
  //       scaffoldKey.currentState!.openEndDrawer();
  //     }
  //   }
  // }

  // @override
  // void dispose() {
  //   _searchController.dispose();
  //   appStore.dispatch(UpdateGeneralStateAction(endDrawer: null));
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(
        () => SpacedColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context, controller.deleteBtnOpacity),
            _body(controller.departments.isEmpty, context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, double opacity) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInputWidget(
              controller: controller.searchController,
              defaultBorderColor: ThemeColors.gray11,
              width: 360,
              leftIcon: HeroIcons.search),
          SpacedRow(horizontalSpace: 16.0, children: [
            AnimatedOpacity(
              opacity: opacity,
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
            ButtonMedium(
              text: "New Department",
              icon: const HeroIcon(
                HeroIcons.plusCircle,
                size: 20,
              ),
              onPressed: () {
                showOverlayPopup(
                    body: const DepartmentsNewDepPopupWidget(),
                    context: context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body(bool isEmpty, BuildContext context) {
    // return Container();

    if (isEmpty) {
      return Center(
          child: KText(
        text: "No Departments Yet",
        fontSize: 24.0,
        mainAxisSize: MainAxisSize.min,
        isSelectable: false,
        textAlign: TextAlign.center,
        textColor: ThemeColors.gray2,
      ));
    }
    return DepsListTable(
      onSmReady: controller.setSm,
      rows: controller.departments.reactive.value
              ?.map<PlutoRow>(_buildItem)
              .toList() ??
          [],
      cols: controller.columns(context),
    );
  }

  PlutoRow _buildItem(ListGroup e) {
    return PlutoRow(cells: {
      "department_name": PlutoCell(value: e.name),
      "status": PlutoCell(value: e.active ? "active" : "inactive"),
      "space": PlutoCell(value: ""),
      "action": PlutoCell(value: e),
    });
  }
}
