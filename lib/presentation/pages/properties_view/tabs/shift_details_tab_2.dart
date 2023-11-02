import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/elements/default_form.dart';
import 'package:mca_dashboard/presentation/form/elements/form_checkbox.dart';
import 'package:mca_dashboard/presentation/form/elements/form_container.dart';
import 'package:mca_dashboard/presentation/form/elements/form_dropdown.dart';
import 'package:mca_dashboard/presentation/form/elements/form_input.dart';
import 'package:mca_dashboard/presentation/form/elements/form_switch.dart';
import 'package:mca_dashboard/presentation/form/elements/form_with_label.dart';
import 'package:mca_dashboard/presentation/form/models/checkbox_model.dart';
import 'package:mca_dashboard/presentation/form/models/dp_item.dart';
import 'package:mca_dashboard/presentation/form/models/dropdown_model.dart';
import 'package:mca_dashboard/presentation/form/models/form_model.dart';
import 'package:mca_dashboard/presentation/form/models/input_model.dart';
import 'package:mca_dashboard/presentation/form/models/label_model.dart';
import 'package:mca_dashboard/presentation/form/models/switch_model.dart';
import 'package:mca_dashboard/presentation/global_widgets/layout/popup_wrapper.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/week_days_m.dart';

class ShiftDetailsTab2 extends StatelessWidget {
  final FormModel formVm;

  const ShiftDetailsTab2({super.key, required this.formVm});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GeneralState>(
        converter: (store) => store.state.generalState,
        builder: (context, vm) {
          final locations = [...vm.lists.locations];
          final clients = [...vm.lists.clients];
          final warehouses = [...vm.lists.warehouses];
          final checklistTemplates = [...vm.checklistTemplates];

          final formContainerWidth = context.width * 0.3;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16),
            child: DefaultForm(
              vm: formVm,
              child: Wrap(
                alignment: WrapAlignment.spaceEvenly,
                runAlignment: WrapAlignment.start,
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
                                items: WeekDaysMd()
                                    .asMap
                                    .entries
                                    .map((e) => DpItem(
                                        id: e.key.toString(),
                                        title: e.key.toString()))
                                    .toList()),
                          ))
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
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
