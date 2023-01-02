import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../../comps/custom_get_builder.dart';
import '../../../manager/models/list_all_md.dart';
import '../../../manager/models/locations_md.dart';
import '../controllers/new_prop_controller.dart';

class ShiftDetailsTab extends StatelessWidget {
  const ShiftDetailsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExpandableTabBar(
      saveText: 'Save Changes',
      onSave: () async {},
      expandedWidgetList: [
        ExpandedWidgetType(
            title: _ShiftDetails.title,
            child: const _ShiftDetails(),
            initExpanded: true),
        // ExpandedWidgetType(
        //     title: _RolesDepsAndLoginOptionsWidget.title,
        //     child: const _RolesDepsAndLoginOptionsWidget()),
        // ExpandedWidgetType(
        //     title: _AddressWidget.title, child: const _AddressWidget()),
      ],
    );
  }
}

class _ShiftDetails extends StatelessWidget {
  static const title = 'Shift Details';
  const _ShiftDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewPropController>(
      id: "shiftDetails",
      builder: (controller) {
        return Form(
          key: controller.shiftDetailsFormKey,
          child: SpacedColumn(
            verticalSpace: 32.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeftPart(controller),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLeftPart(NewPropController controller) {
    final dpWidth = MediaQuery.of(Get.context!).size.width * 0.2;

    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWidget(
            width: dpWidth,
            labelText: "Property Name",
            isRequired: true,
            controller: controller.shiftNameController,
          ),
          DropdownWidget1<ListLocation>(
            hintText: "Location",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            hasSearchBox: true,
            value: controller.shiftLocation.name,
            objItems:
                appStore.state.generalState.paramList.data?.locations ?? [],
            onChangedWithObj: (p0) {
              final loc = p0.item as ListLocation;
              controller.shiftLocation.name = p0.item.name;
              controller.shiftLocation.code = p0.item.id;
              controller.updateShiftDetails();
            },
            items: (appStore.state.generalState.paramList.data?.locations ?? [])
                .map((e) => e.name)
                .toList(),
          ),
        ]);
  }
}
