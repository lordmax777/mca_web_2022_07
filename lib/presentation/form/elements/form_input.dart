import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mca_dashboard/presentation/form/models/input_model.dart';

class FormInput extends StatelessWidget {
  final InputModel vm;
  const FormInput({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(
      name: vm.name,
      initialValue: vm.initialValue,
      onChanged: vm.onChanged,
      maxLines: vm.maxLines,
      style: const TextStyle(fontWeight: FontWeight.w600),
      validator: FormBuilderValidators.compose(vm.validators),
      inputFormatters: vm.inputFormatters,
      enabled: vm.enabled,
      mouseCursor: vm.enabled ? null : SystemMouseCursors.forbidden,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        helperText: vm.helperText,
        hintText: vm.hintText,
        filled: !vm.enabled,
        fillColor: !vm.enabled ? Colors.grey.shade200 : null,
      ),
    );
  }
}
