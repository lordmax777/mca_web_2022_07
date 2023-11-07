import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/form.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';

class ShiftDetailsTab2 extends StatelessWidget {
  final FormModel formVm;
  final List<SpecialRateMd> specialRates;
  final VoidCallback onAddCustomRate;
  final ValueChanged<int> onRemoveCustomRate;
  final ValueChanged<int> onSaveCustomRate;
  final bool isCreate;
  const ShiftDetailsTab2({
    super.key,
    required this.formVm,
    required this.isCreate,
    required this.specialRates,
    required this.onAddCustomRate,
    required this.onRemoveCustomRate,
    required this.onSaveCustomRate,
  });

  @override
  Widget build(BuildContext context) {
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
              child: FormWrap(
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
                          labelVm: const LabelModel(
                              text: "Unavailable days", isRequired: true),
                          formBuilderField: FormCheckbox(
                            vm: CheckboxModel(
                                name: "days",
                                onChanged: print,
                                //at least 1 day is required
                                validator: FormBuilderValidators.maxLength(6,
                                    errorText:
                                        "At least 1 day must be available"),
                                helperText:
                                    "Select the days when the shift is unavailable",
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
                            name: "finishTime",
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
                            name: "startBreak",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      FormWithLabel(
                        labelVm: LabelModel(text: "Break end time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "finishBreak",
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
                            name: "fpStartTime",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      const FormWithLabel(
                        labelVm: LabelModel(text: "Mobile end time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "fpFinishTime",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      const FormWithLabel(
                        labelVm: LabelModel(text: "Mobile break start time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "fpStartBreak",
                            type: InputType.time,
                          ),
                        ),
                      ),
                      const FormWithLabel(
                        labelVm: LabelModel(text: "Mobile break end time"),
                        formBuilderField: FormDatePicker(
                          vm: DatePickerModel(
                            name: "fpFinishBreak",
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
                                  validators: [
                                    FormBuilderValidators.numeric(),
                                  ],
                                  valueTransformer: (value) =>
                                      int.tryParse(value ?? ""),
                                  inputFormatters: [
                                    GlobalConstants.numbersOnlyFormatter,
                                  ]))),
                      FormWithLabel(
                          labelVm: const LabelModel(text: 'Minimum paid time'),
                          formBuilderField: FormInput(
                              vm: InputModel(
                                  name: "minPaidTime",
                                  hintText: "120",
                                  validators: [
                                    FormBuilderValidators.numeric(),
                                  ],
                                  valueTransformer: (value) =>
                                      int.tryParse(value ?? ""),
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
                                  name: "strictBreak",
                                  title: "Strict break time"))),
                    ],
                  ),
                  //todo:
                  // SizedBox(
                  //   width: specialRates.isEmpty ? 200 : context.width,
                  //   child: SingleChildScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     child: SpacedRow(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       horizontalSpace: 16.0,
                  //       children: [
                  //         for (int i = 0; i < specialRates.length; i++)
                  //           FormContainer(
                  //             trailing: TextButton.icon(
                  //                 label: const Text("Delete"),
                  //                 style: TextButton.styleFrom(
                  //                     foregroundColor: Colors.red),
                  //                 icon: const Icon(Icons.delete),
                  //                 onPressed: () => onRemoveCustomRate(i)),
                  //             titleWidget: isCreate
                  //                 ? const SizedBox()
                  //                 : specialRates[i].id != 0
                  //                     ? const SizedBox()
                  //                     : TextButton.icon(
                  //                         label: const Text("Save"),
                  //                         icon: const Icon(Icons.save),
                  //                         onPressed: () => onSaveCustomRate(i),
                  //                       ),
                  //             width: formContainerWidth * 0.6,
                  //             left: [
                  //               Visibility(
                  //                 visible: false,
                  //                 maintainState: true,
                  //                 child: FormWithLabel(
                  //                   labelVm: const LabelModel(text: ""),
                  //                   formBuilderField: FormInput(
                  //                     vm: InputModel(
                  //                       initialValue:
                  //                           specialRates[i].id.toString(),
                  //                       name: "specialRateId$i",
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               FormWithLabel(
                  //                 labelVm: LabelModel(
                  //                     text: "Special rate name $i",
                  //                     isRequired: true),
                  //                 formBuilderField: FormInput(
                  //                   vm: InputModel(
                  //                     initialValue: specialRates[i].name,
                  //                     validators: [
                  //                       FormBuilderValidators.required(),
                  //                     ],
                  //                     hintText: "Night shift",
                  //                     name: "specialRateName$i",
                  //                   ),
                  //                 ),
                  //               ),
                  //               FormWithLabel(
                  //                   labelVm: const LabelModel(
                  //                       text: "Rate", isRequired: true),
                  //                   formBuilderField: FormInput(
                  //                       vm: InputModel(
                  //                           initialValue: specialRates[i]
                  //                               .rate
                  //                               ?.toString(),
                  //                           name: "specialRateRate$i",
                  //                           hintText: "60",
                  //                           valueTransformer: (value) =>
                  //                               double.tryParse(value ?? ""),
                  //                           validators: [
                  //                         FormBuilderValidators.required(),
                  //                         FormBuilderValidators.numeric(),
                  //                       ],
                  //                           inputFormatters: [
                  //                         GlobalConstants
                  //                             .numbersAndDecimalOnlyFormatter,
                  //                       ]))),
                  //               FormWithLabel(
                  //                   labelVm: const LabelModel(
                  //                       text: 'Minimum working time',
                  //                       isRequired: true),
                  //                   formBuilderField: FormInput(
                  //                       vm: InputModel(
                  //                           initialValue: specialRates[i]
                  //                               .minWorkTime
                  //                               ?.toString(),
                  //                           valueTransformer: (value) =>
                  //                               int.tryParse(value ?? ""),
                  //                           validators: [
                  //                             FormBuilderValidators.required(),
                  //                             FormBuilderValidators.numeric(),
                  //                           ],
                  //                           name: "specialRateMinWorkTime$i",
                  //                           hintText: "60",
                  //                           helperText: "minutes",
                  //                           inputFormatters: [
                  //                             GlobalConstants
                  //                                 .numbersOnlyFormatter,
                  //                           ]))),
                  //               FormWithLabel(
                  //                   labelVm: const LabelModel(
                  //                       text: 'Minimum paid time',
                  //                       isRequired: true),
                  //                   formBuilderField: FormInput(
                  //                       vm: InputModel(
                  //                           initialValue: specialRates[i]
                  //                               .paidTime
                  //                               ?.toString(),
                  //                           valueTransformer: (value) =>
                  //                               int.tryParse(value ?? ""),
                  //                           validators: [
                  //                             FormBuilderValidators.required(),
                  //                             FormBuilderValidators.numeric(),
                  //                           ],
                  //                           name: "specialRateMinPaidTime$i",
                  //                           hintText: "120",
                  //                           helperText: "minutes",
                  //                           inputFormatters: [
                  //                             GlobalConstants
                  //                                 .numbersOnlyFormatter,
                  //                           ]))),
                  //               FormSwitch(
                  //                   vm: SwitchModel(
                  //                       initialValue: specialRates[i].splitTime,
                  //                       name: "specialRateSplitTime$i",
                  //                       title: "Split time")),
                  //             ],
                  //           ),
                  //         MaterialButton(
                  //           shape: RoundedRectangleBorder(
                  //             side: BorderSide(color: Colors.grey[400]!),
                  //             borderRadius: BorderRadius.circular(32),
                  //           ),
                  //           onPressed: onAddCustomRate,
                  //           height: specialRates.isEmpty ? 510 : 360,
                  //           minWidth: 200,
                  //           child: SpacedColumn(
                  //             verticalSpace: 8.0,
                  //             children: const [
                  //               Icon(Icons.add_circle_outline),
                  //               Text("Add Special Rate",
                  //                   style: TextStyle(fontSize: 16)),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
  }
}
