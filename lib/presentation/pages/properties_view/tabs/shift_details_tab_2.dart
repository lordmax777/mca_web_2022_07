import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/elements/default_form.dart';
import 'package:mca_dashboard/presentation/form/elements/form_checkbox.dart';
import 'package:mca_dashboard/presentation/form/elements/form_container.dart';
import 'package:mca_dashboard/presentation/form/elements/form_date_picker.dart';
import 'package:mca_dashboard/presentation/form/elements/form_dropdown.dart';
import 'package:mca_dashboard/presentation/form/elements/form_input.dart';
import 'package:mca_dashboard/presentation/form/elements/form_switch.dart';
import 'package:mca_dashboard/presentation/form/elements/form_with_label.dart';
import 'package:mca_dashboard/presentation/form/models/checkbox_model.dart';
import 'package:mca_dashboard/presentation/form/models/date_picker_model.dart';
import 'package:mca_dashboard/presentation/form/models/dp_item.dart';
import 'package:mca_dashboard/presentation/form/models/dropdown_model.dart';
import 'package:mca_dashboard/presentation/form/models/form_model.dart';
import 'package:mca_dashboard/presentation/form/models/input_model.dart';
import 'package:mca_dashboard/presentation/form/models/label_model.dart';
import 'package:mca_dashboard/presentation/form/models/switch_model.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';

import '../../../global_widgets/widgets.dart';

class ShiftDetailsTab2 extends StatelessWidget {
  final FormModel formVm;
  final int customRates;
  final VoidCallback onAddCustomRate;
  final ValueChanged<int> onRemoveCustomRate;

  const ShiftDetailsTab2(
      {super.key,
      required this.formVm,
      this.customRates = 0,
      required this.onAddCustomRate,
      required this.onRemoveCustomRate});

  @override
  Widget build(BuildContext context) {
    final bool strictBreakTime =
        formVm.formKey.currentState?.getRawValue("strictBreakTime") ?? false;

    return StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, vm) {
          final locations = [...vm.lists.locations];
          final clients = [...vm.lists.clients];
          final warehouses = [...vm.lists.warehouses];
          final checklistTemplates = [...vm.checklistTemplates];

          final formContainerWidth = context.width * 0.35;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16),
            child: DefaultForm(
              clearValueOnUnregister: true,
              vm: formVm,
              child: Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.start,
                spacing: 32,
                runSpacing: 16.0,
                children: [
                  FormContainer(
                    width: formContainerWidth,
                    title: "Shift Details",
                    left: [
                      FormWithLabel(
                        labelVm: const LabelModel(
                            text: "Shift Name", isRequired: true),
                        formBuilderField: FormInput(
                            vm: InputModel(
                          name: "shiftName",
                          hintText: "Afternoon",
                          validators: [
                            FormBuilderValidators.required(),
                          ],
                        )),
                      ),
                      FormWithLabel(
                        labelVm: const LabelModel(
                            text: "Location", isRequired: true),
                        formBuilderField: FormDropdown(
                            vm: DropdownModel(
                          name: "locationId",
                          items: locations
                              .map((e) =>
                                  DpItem(id: e.id.toString(), title: e.name))
                              .toList(),
                          hasSearchBox: true,
                          validator: FormBuilderValidators.required(),
                        )),
                      ),
                      FormWithLabel(
                        labelVm:
                            const LabelModel(text: "Client", isRequired: true),
                        formBuilderField: FormDropdown(
                            vm: DropdownModel(
                          name: "clientId",
                          items: clients
                              .map((e) => DpItem(
                                  id: e.id.toString(),
                                  title: e.name,
                                  subtitle: e.company))
                              .toList(),
                          hasSearchBox: true,
                          validator: FormBuilderValidators.required(),
                        )),
                      ),
                      FormWithLabel(
                        labelVm: const LabelModel(
                            text: "Warehouse", isRequired: true),
                        formBuilderField: FormDropdown(
                            vm: DropdownModel(
                          name: "storageId",
                          items: warehouses
                              .map((e) => DpItem(
                                  id: e.id.toString(),
                                  title: e.name,
                                  subtitle: e.contactName))
                              .toList(),
                          hasSearchBox: true,
                          validator: FormBuilderValidators.required(),
                        )),
                      ),
                      FormWithLabel(
                          labelVm:
                              const LabelModel(text: "Days", isRequired: true),
                          formBuilderField: FormCheckbox(
                            vm: CheckboxModel(
                                name: "days",
                                onChanged: print,
                                //at least 1 day is required
                                validator: FormBuilderValidators.required(
                                    errorText: "At least 1 day is required"),
                                items: WeekDaysMd()
                                    .asMap
                                    .entries
                                    .map((e) => DpItem(
                                        id: e.key.toString(),
                                        title: e.key.toString()))
                                    .toList()),
                          )),
                    ],
                    hidden: [
                      FormWithLabel(
                        labelVm: const LabelModel(text: "Checklist Template"),
                        formBuilderField: FormDropdown(
                            vm: DropdownModel(
                          name: "templateId",
                          items: checklistTemplates
                              .map((e) => DpItem(
                                  id: e.id.toString(),
                                  title: e.name,
                                  subtitle: e.title))
                              .toList(),
                          hasSearchBox: true,
                        )),
                      ),
                      const SizedBox(height: 16),
                      const FormSwitch(
                          vm: SwitchModel(
                        initialValue: true,
                        name: "active",
                        title: "Active",
                      )),
                      const SizedBox(height: 16),
                      const FormSwitch(
                          vm: SwitchModel(
                        name: "checklist",
                        title: "Checklist available",
                      )),
                    ],
                  ),
                  FormContainer(
                    width: formContainerWidth,
                    title: "Timings",
                    left: [
                      FormWithLabel(
                        labelVm: const LabelModel(
                            text: "Start time", isRequired: true),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            validators: [
                              FormBuilderValidators.required(),
                            ],
                            name: "startTime",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      FormWithLabel(
                        labelVm: const LabelModel(
                            text: "End time", isRequired: true),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            validators: [
                              FormBuilderValidators.required(),
                            ],
                            name: "endTime",
                            type: InputType.time,
                          ),
                        ),
                      )
                    ],
                    right: const [
                      FormWithLabel(
                        labelVm: LabelModel(text: "Break start time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "breakStartTime",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      FormWithLabel(
                        labelVm: LabelModel(text: "Break end time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "breakEndTime",
                            type: InputType.time,
                          ),
                        ),
                      ),
                    ],
                    hidden: [
                      const FormWithLabel(
                        labelVm: LabelModel(text: "Mobile start time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "mobileStartTime",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      const FormWithLabel(
                        labelVm: LabelModel(text: "Mobile end time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "mobileEndTime",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      const FormWithLabel(
                        labelVm: LabelModel(text: "Mobile break start time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "mobileBreakStartTime",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      const FormWithLabel(
                        labelVm: LabelModel(text: "Mobile break end time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "mobileBreakEndTime",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      FormWithLabel(
                          labelVm:
                              const LabelModel(text: 'Minimum working time'),
                          formBuilderField: FormInput(
                              vm: InputModel(
                                  name: "minWorkTime",
                                  hintText: "60",
                                  helperText: "minutes",
                                  inputFormatters: [
                                GlobalConstants.numbersOnlyFormatter,
                              ]))),
                      FormWithLabel(
                          labelVm: const LabelModel(text: 'Minimum paid time'),
                          formBuilderField: FormInput(
                              vm: InputModel(
                                  name: "minPaidTime",
                                  hintText: "120",
                                  helperText:
                                      "Here can specify how much time will be paid, even signed in less or more time.(minutes)",
                                  inputFormatters: [
                                GlobalConstants.numbersOnlyFormatter,
                              ]))),
                      const FormWithLabel(
                          labelVm: LabelModel(text: " "),
                          formBuilderField: FormSwitch(
                              vm: SwitchModel(
                                  helperText:
                                      "If enabled, will split the working time between all the staff members who signed in into this shift. This function only available when the Paid Time specified.",
                                  name: "splitTime",
                                  title: "Split time"))),
                      const FormWithLabel(
                          labelVm: LabelModel(text: " "),
                          formBuilderField: FormSwitch(
                              vm: SwitchModel(
                                  name: "strictBreakTime",
                                  title: "Strict break time"))),
                    ],
                  ),
                  SizedBox(
                    width: customRates == 0 ? 200 : context.width,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SpacedRow(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        horizontalSpace: 16.0,
                        children: [
                          for (int i = 0; i < customRates; i++)
                            FormContainer(
                              trailing: IconButton(
                                  color: Colors.red,
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => onRemoveCustomRate(i)),
                              title: "Special Rate ${i + 1}",
                              width: formContainerWidth * 0.6,
                              left: [
                                FormWithLabel(
                                  labelVm: const LabelModel(
                                      text: "Special rate name",
                                      isRequired: true),
                                  formBuilderField: FormInput(
                                    vm: InputModel(
                                      validators: [
                                        FormBuilderValidators.required(),
                                      ],
                                      hintText: "Night shift",
                                      name: "specialRateName$i",
                                    ),
                                  ),
                                ),
                                FormWithLabel(
                                    labelVm: const LabelModel(
                                        text: "Rate", isRequired: true),
                                    formBuilderField: FormInput(
                                        vm: InputModel(
                                            name: "specialRateRate$i",
                                            hintText: "60",
                                            validators: [
                                          FormBuilderValidators.required(),
                                        ],
                                            inputFormatters: [
                                          GlobalConstants
                                              .numbersAndDecimalOnlyFormatter,
                                        ]))),
                                FormWithLabel(
                                    labelVm: const LabelModel(
                                        text: 'Minimum working time',
                                        isRequired: true),
                                    formBuilderField: FormInput(
                                        vm: InputModel(
                                            validators: [
                                              FormBuilderValidators.required(),
                                            ],
                                            name: "specialRateMinWorkTime$i",
                                            hintText: "60",
                                            helperText: "minutes",
                                            inputFormatters: [
                                              GlobalConstants
                                                  .numbersOnlyFormatter,
                                            ]))),
                                FormWithLabel(
                                    labelVm: const LabelModel(
                                        text: 'Minimum paid time',
                                        isRequired: true),
                                    formBuilderField: FormInput(
                                        vm: InputModel(
                                            validators: [
                                              FormBuilderValidators.required(),
                                            ],
                                            name: "specialRateMinPaidTime$i",
                                            hintText: "120",
                                            helperText: "minutes",
                                            inputFormatters: [
                                              GlobalConstants
                                                  .numbersOnlyFormatter,
                                            ]))),
                                FormSwitch(
                                    vm: SwitchModel(
                                        name: "specialRateSplitTime$i",
                                        title: "Split time")),
                              ],
                            ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey[400]!),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            onPressed: onAddCustomRate,
                            height: customRates > 0 ? 510 : 360,
                            minWidth: 200,
                            child: SpacedColumn(
                              verticalSpace: 8.0,
                              children: const [
                                Icon(Icons.add_circle_outline),
                                Text("Add Special Rate",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
