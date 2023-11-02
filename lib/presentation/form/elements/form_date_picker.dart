import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/form/models/date_picker_model.dart';
import 'package:mca_dashboard/presentation/form/models/input_model.dart';

class FormDatePicker extends StatelessWidget {
  final DatePickerModel vm;
  const FormDatePicker({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      inputType: vm.type,
      name: vm.name,
      initialValue: vm.initialValue,
      onChanged: vm.onChanged,
      maxLines: vm.maxLines,
      validator: FormBuilderValidators.compose(vm.validators),
      inputFormatters: vm.inputFormatters,
      enabled: vm.enabled,
      format: vm.format,
      mouseCursor:
          vm.enabled ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
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
