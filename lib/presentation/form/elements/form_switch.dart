import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mca_dashboard/presentation/form/models/switch_model.dart';
import 'package:mca_dashboard/utils/utils.dart';

class FormSwitch extends StatelessWidget {
  final SwitchModel vm;
  const FormSwitch({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return FormBuilderSwitch(
      name: vm.name,
      validator: vm.validator,
      enabled: vm.enabled,
      initialValue: vm.initialValue,
      title: Text(vm.title, style: context.textTheme.titleMedium),
      onChanged: vm.onChanged,

      inactiveThumbColor: Colors.grey[200],
      inactiveTrackColor: Colors.grey[400],
    );
  }
}
