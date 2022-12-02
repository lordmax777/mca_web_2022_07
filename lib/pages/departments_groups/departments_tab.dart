import 'package:get/get.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/models/list_all_md.dart';
import '../../theme/theme.dart';
import 'controllers/deps_list_controller.dart';

class DepartmentsTab extends GetView<DepartmentsController> {
  const DepartmentsTab({super.key});

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
      "action": PlutoCell(value: e),
    });
  }
}
