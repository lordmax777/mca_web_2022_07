import 'package:get/get.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/groups_list_controller.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/models/list_all_md.dart';
import '../../theme/theme.dart';

class GroupsTab extends GetView<GroupsController> {
  const GroupsTab({super.key});

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
              text: "New Group",
              icon: const HeroIcon(
                HeroIcons.plusCircle,
                size: 20,
              ),
              onPressed: () {
                showOverlayPopup(
                    body: const GroupsNewDepPopupWidget(), context: context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body(bool isEmpty, BuildContext context) {
    if (isEmpty) {
      return Center(
          child: KText(
        text: "No Groups Yet",
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

  PlutoRow _buildItem(ListJobTitle e) {
    return PlutoRow(cells: {
      "group_name": PlutoCell(value: e.name),
      "status": PlutoCell(value: e.active ? "active" : "inactive"),
      "space": PlutoCell(value: ""),
      "action": PlutoCell(value: e),
    });
  }
}
