import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
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
          child: SpacedRow(
            horizontalSpace: 32.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeftPart(controller),
              _buildRightPart(controller),
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
            onChangedWithObj: controller.updateShiftDetails,
            items: (appStore.state.generalState.paramList.data?.locations ?? [])
                .map((e) => e.name)
                .toList(),
          ),
          DropdownWidget1<ListClients>(
            hintText: "Client",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            hasSearchBox: true,
            value: controller.shiftClient.name,
            objItems: appStore.state.generalState.paramList.data?.clients ?? [],
            onChangedWithObj: controller.updateShiftClient,
            items: (appStore.state.generalState.paramList.data?.clients ?? [])
                .map((e) => e.name)
                .toList(),
          ),
          DropdownWidget1<WarehouseMd>(
            hintText: "Warehouse",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            hasSearchBox: true,
            value: controller.shiftWarehouse.name,
            objItems: appStore.state.generalState.warehouses.data ?? [],
            onChangedWithObj: controller.updateShiftWarehouse,
            items: (appStore.state.generalState.warehouses.data ?? [])
                .map((e) => e.name)
                .toList(),
          ),
          SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  KText(
                      text: 'Days ',
                      textColor: ThemeColors.gray2,
                      fontSize: 14,
                      fontWeight: FWeight.bold),
                  KText(
                      text: '*',
                      textColor: ThemeColors.red3,
                      fontSize: 14,
                      fontWeight: FWeight.bold),
                ],
              ),
              const SizedBox(height: 16),
              for (var item in Constants.daysOfTheWeek.entries)
                _chbx(controller.shiftDays.containsKey(item.key), (value) {
                  controller.updateShiftDays(item);
                }, item.value),
            ],
          )
        ]);
  }

  Widget _buildRightPart(NewPropController controller) {
    final dpWidth = MediaQuery.of(Get.context!).size.width * 0.2;
    return SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownWidget(
            hintText: "Status",
            value: Constants.userAccountStatusTypes[controller.shiftStatus],
            dropdownBtnWidth: dpWidth,
            isRequired: true,
            dropdownOptionsWidth: dpWidth,
            onChanged: (val) {
              controller.updateShiftStatus(
                  val == Constants.userAccountStatusTypes.values.first);
            },
            items:
                Constants.userAccountStatusTypes.values.map((e) => e).toList(),
          ),
          const SizedBox(height: 32),
          _chbx(controller.shiftChecklistOn,
              controller.updateShiftChecklistAvailable, "Checklist Available"),
          const SizedBox(height: 12),
          DropdownWidget1<ChecklistTemplateMd>(
            hintText: "Checklist Template",
            isRequired: true,
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            hasSearchBox: true,
            value: controller.shiftChecklistTemplate.name,
            onChangedWithObj: controller.updateShiftChecklistTemplate,
            objItems: appStore.state.generalState.checklistTemplates.data ?? [],
            items: (appStore.state.generalState.checklistTemplates.data ?? [])
                .map((e) => e.name)
                .toList(),
          ),
        ]);
  }

  Widget _chbx(bool value, ValueChanged<bool> onChanged, String text) {
    return SpacedRow(
      horizontalSpace: 8.0,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CheckboxWidget(value: value, onChanged: (value) => onChanged(value!)),
        KText(
          text: text,
          textColor: ThemeColors.gray2,
          fontSize: 14,
          fontWeight: FWeight.bold,
          isSelectable: false,
        )
      ],
    );
  }
}
