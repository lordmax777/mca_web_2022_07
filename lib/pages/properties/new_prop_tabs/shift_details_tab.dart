import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import '../controllers/new_prop_controller.dart';

class ShiftDetailsTab extends StatelessWidget {
  const ShiftDetailsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomExpandableTabBar(
      saveText: 'Save Changes',
      onSave: NewPropController.to.onSave,
      expandedWidgetList: [
        ExpandedWidgetType(
            title: _ShiftDetails.title,
            child: const _ShiftDetails(),
            initExpanded: true),
        ExpandedWidgetType(title: _Timings.title, child: const _Timings()),
        ExpandedWidgetType(
            title: _Rates.title,
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: const _Rates()),
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
        logger(controller.property?.locationId);
        logger(controller.property?.id);
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
            labelText: "${Constants.propertyName.capitalize} Name",
            isRequired: true,
            controller: controller.shiftNameController,
          ),
          DropdownWidget1<ListLocation>(
            hintText: "Location",
            dropdownBtnWidth: dpWidth,
            isRequired: true,
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
            isRequired: true,
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
            isRequired: true,
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
                chbx(controller.shiftDays.containsKey(item.key), (value) {
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
          chbx(controller.shiftChecklistOn,
              controller.updateShiftChecklistAvailable, "Checklist Available"),
          const SizedBox(height: 12),
          DropdownWidgetV2(
            hintText: "Checklist Template",
            hasSearchBox: true,
            isRequired: true,
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            items: (appStore.state.generalState.checklistTemplates.data ?? [])
                .map((e) => CustomDropdownValue(name: e.name))
                .toList(),
            onChanged: (index) {
              controller.updateShiftChecklistTemplate(DpItem(
                  appStore
                      .state.generalState.checklistTemplates.data![index].name,
                  appStore.state.generalState.checklistTemplates.data![index]));
            },
            value: CustomDropdownValue(
                name: controller.shiftChecklistTemplate.name ?? ""),
          ),
          // DropdownWidget1<ChecklistTemplateMd>(
          //   hintText: "Checklist Template",
          //   isRequired: true,
          //   dropdownBtnWidth: dpWidth,
          //   dropdownOptionsWidth: dpWidth,
          //   hasSearchBox: true,
          //   value: controller.shiftChecklistTemplate.name,
          //   onChangedWithObj: controller.updateShiftChecklistTemplate,
          //   objItems: appStore.state.generalState.checklistTemplates.data ?? [],
          //   items: (appStore.state.generalState.checklistTemplates.data ?? [])
          //       .map((e) => e.name)
          //       .toList(),
          // ),
        ]);
  }
}

class _Timings extends StatelessWidget {
  static const title = 'Timings';
  const _Timings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewPropController>(
      id: "timings",
      builder: (controller) {
        return Form(
          key: controller.timingFormKey,
          child: _buildInputs(controller, context),
        );
      },
    );
  }

  Widget _buildInputs(NewPropController controller, BuildContext context) {
    final dpWidth = MediaQuery.of(Get.context!).size.width * 0.15;

    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                controller: controller.timingStartTime,
                isRequired: true,
                isReadOnly: true,
                width: dpWidth,
                labelText: "Start Time",
                leftIcon: HeroIcons.clock,
                onTap: () => controller.updateTimeController(
                    context, controller.timingStartTime),
              ),
              TextInputWidget(
                controller: controller.timingEndTime,
                isRequired: true,
                isReadOnly: true,
                width: dpWidth,
                labelText: "End Time",
                leftIcon: HeroIcons.clock,
                onTap: () => controller.updateTimeController(
                    context, controller.timingEndTime),
              ),
            ],
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              SpacedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                verticalSpace: 8.0,
                children: [
                  TextInputWidget(
                    controller: controller.timingStartBreakTime,
                    isRequired: controller.timingStrictBreakTime.value,
                    isReadOnly: true,
                    width: dpWidth,
                    labelText: "Start Break Time",
                    leftIcon: HeroIcons.clock,
                    onTap: () => controller.updateTimeController(
                        context, controller.timingStartBreakTime),
                  ),
                  chbx(controller.timingStrictBreakTime.value,
                      controller.updateStrictBreakTime, "Strict Break Time"),
                ],
              ),
              TextInputWidget(
                controller: controller.timingEndBreakTime,
                isRequired: controller.timingStrictBreakTime.value,
                isReadOnly: true,
                width: dpWidth,
                labelText: "End Break Time",
                leftIcon: HeroIcons.clock,
                onTap: () => controller.updateTimeController(
                    context, controller.timingEndBreakTime),
              ),
            ],
          ),
          4.hs,
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                controller: controller.timingMobileStartTime,
                isReadOnly: true,
                width: dpWidth,
                labelText: "Mobile Start Time",
                leftIcon: HeroIcons.clock,
                onTap: () => controller.updateTimeController(
                    context, controller.timingMobileStartTime),
              ),
              TextInputWidget(
                controller: controller.timingMobileEndTime,
                isReadOnly: true,
                width: dpWidth,
                labelText: "Mobile End Time",
                leftIcon: HeroIcons.clock,
                onTap: () => controller.updateTimeController(
                    context, controller.timingMobileEndTime),
              ),
            ],
          ),
          SpacedRow(
            horizontalSpace: 24.0,
            children: [
              TextInputWidget(
                controller: controller.timingMobileStartBreakTime,
                isReadOnly: true,
                width: dpWidth,
                labelText: "Mobile Start Break",
                leftIcon: HeroIcons.clock,
                onTap: () => controller.updateTimeController(
                    context, controller.timingMobileStartBreakTime),
              ),
              TextInputWidget(
                controller: controller.timingMobileEndBreakTime,
                isReadOnly: true,
                width: dpWidth,
                labelText: "Mobile End Break",
                leftIcon: HeroIcons.clock,
                onTap: () => controller.updateTimeController(
                    context, controller.timingMobileEndBreakTime),
              ),
            ],
          ),
        ]);
  }
}

class _Rates extends StatelessWidget {
  static const title = 'Rates and Paid time';
  const _Rates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewPropController>(
      id: "rates",
      builder: (controller) {
        return Form(
          key: controller.ratesFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: _buildTop(controller, context),
              ),
              if (!controller.isNew)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                        height: 1, thickness: 1, color: ThemeColors.gray11),
                    32.hs,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: KText(
                        text: 'Custom Rates',
                        fontWeight: FWeight.bold,
                        fontSize: 18.0,
                        textColor: ThemeColors.gray2,
                      ),
                    ),
                    32.hs,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 48.0),
                      child: _buildCustomRates(controller, context),
                    ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTop(NewPropController controller, BuildContext context) {
    final dpWidth = MediaQuery.of(Get.context!).size.width * 0.2;

    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWidget(
            controller: controller.rateMinWorkingTime,
            isRequired: true,
            width: dpWidth,
            labelText: "Minimum Working Time (Minutes)",
          ),
          SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalSpace: 8.0,
            children: [
              TextInputWidget(
                controller: controller.ratePaidTime,
                isRequired: true,
                width: dpWidth,
                labelText: "Paid Time (Minutes)",
              ),
              SizedBox(
                width: dpWidth,
                child: KText(
                  maxLines: 2,
                  isSelectable: false,
                  text:
                      'You can specify how much time will be paid, even signed in, less or more time.',
                  fontSize: 12.0,
                  fontWeight: FWeight.medium,
                  textColor: ThemeColors.gray8,
                ),
              )
            ],
          ),
          chbx(controller.rateSplitTime.value, controller.updateRateSplitTime,
              "Split Time"),
          1.hs,
        ]);
  }

  Widget _buildCustomRates(NewPropController controller, BuildContext context) {
    List<Widget> list = [];
    for (int i = 0; i < controller.customRates.length; i++) {
      list.add(_customRateWidget(i, controller));
    }

    return Wrap(
      spacing: 32.0,
      runSpacing: 32.0,
      children: [
        ...list,
        _addRate(controller),
      ],
    );
  }

  Widget _customRateWidget(int i, NewPropController controller) {
    final CustomRate rate = controller.customRates[i];
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: ThemeColors.gray11),
            borderRadius: BorderRadius.circular(8.0),
          ),
          // height: 480,
          width: 400,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Form(
            key: rate.formKey,
            child: SpacedColumn(
              verticalSpace: 32.0,
              children: [
                TextInputWidget(
                  width: 400,
                  controller: rate.name,
                  isRequired: true,
                  labelText: "Name",
                ),
                TextInputWidget(
                  width: 400,
                  isRequired: true,
                  controller: rate.rate,
                  keyboardType: TextInputType.number,
                  rightIcon: HeroIcons.pound,
                  labelText: "Special Rate",
                ),
                TextInputWidget(
                  width: 400,
                  isRequired: true,
                  controller: rate.minTime,
                  keyboardType: TextInputType.number,
                  labelText: "Minimum Working Time (Minutes)",
                ),
                SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalSpace: 8.0,
                  children: [
                    TextInputWidget(
                      controller: rate.paidTime,
                      isRequired: true,
                      width: 400,
                      labelText: "Paid Time (Minutes)",
                    ),
                    SizedBox(
                      width: 400,
                      child: KText(
                        maxLines: 2,
                        isSelectable: false,
                        text:
                            'You can specify how much time will be paid, even signed in, less or more time.',
                        fontSize: 12.0,
                        fontWeight: FWeight.medium,
                        textColor: ThemeColors.gray8,
                      ),
                    )
                  ],
                ),
                chbx(rate.splitTime, (value) {
                  rate.splitTime = value;
                  NewPropController.to.update(['rates']);
                }, "Split Time"),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: ThemeColors.gray10),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              iconSize: 24,
              onPressed: () => controller.removeCustomRate(i),
              icon: const HeroIcon(HeroIcons.bin,
                  color: ThemeColors.red3, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _addRate(NewPropController controller) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      dashPattern: const [5, 5],
      color: ThemeColors.gray9,
      child: MaterialButton(
        onPressed: controller.addCustomRate,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: SizedBox(
          height: 460,
          width: 400,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HeroIcon(HeroIcons.plusCircle,
                  color: ThemeColors.gray6, size: 24),
              16.hs,
              KText(
                isSelectable: false,
                text: "Add Rate",
                fontSize: 16,
                fontWeight: FWeight.bold,
                textColor: ThemeColors.gray6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget chbx(bool value, ValueChanged<bool> onChanged, String text) {
  return GestureDetector(
    onTap: () {
      onChanged(!value);
    },
    child: SpacedRow(
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
    ),
  );
}
