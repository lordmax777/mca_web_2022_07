import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mca_dashboard/presentation/form/models/checkbox_model.dart';
import 'package:mca_dashboard/presentation/form/models/input_model.dart';

class FormCheckbox extends StatelessWidget {
  final CheckboxModel vm;
  const FormCheckbox({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return FormBuilderCheckboxGroup<String>(
      name: vm.name,
      enabled: vm.enabled,
      validator: vm.validator,
      onChanged: vm.onChanged,
      initialValue: vm.initialValues,
      disabled: vm.disabled,
      options: vm.items
          .map((e) => FormBuilderFieldOption(value: e.id, child: Text(e.title)))
          .toList(),
      orientation: vm.orientation ?? OptionsOrientation.wrap,
      wrapSpacing: 10.0,
      decoration: InputDecoration(
        // enabledBorder: vm.items.length == 1 ? InputBorder.none : null,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        helperText: vm.helperText,
        hintText: vm.hintText,
        filled: !vm.enabled,
        fillColor: !vm.enabled ? Colors.grey.shade200 : null,
      ),
    );
  }
}
