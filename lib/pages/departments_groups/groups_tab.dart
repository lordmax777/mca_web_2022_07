import 'package:get/get.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/groups_list_controller.dart';
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
            _header(context),
            _body(controller.departments.isEmpty, context),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
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
          SpacedRow(
              horizontalSpace: 16.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomCheckboxWidget(
                  isChecked: controller.isShowInactive,
                  onChanged: controller.setShowInactive,
                  label: "Show inactive",
                  labelPosition: CheckboxLabelPosition.left,
                ),
                ButtonMedium(
                  text: "New Group",
                  icon: const HeroIcon(
                    HeroIcons.plusCircle,
                    size: 20,
                  ),
                  onPressed: () {
                    showOverlayPopup(
                        body: const GroupsNewDepPopupWidget(),
                        context: context);
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
      "action": PlutoCell(value: e),
    });
  }
}
