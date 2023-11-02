import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mca_dashboard/presentation/form/models/form_model.dart';

class DefaultForm extends StatelessWidget {
  final FormModel vm;
  final Widget child;
  final bool clearValueOnUnregister;
  const DefaultForm(
      {super.key,
      required this.vm,
      required this.child,
      this.clearValueOnUnregister = false});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      clearValueOnUnregister: clearValueOnUnregister,
      key: vm.formKey,
      onChanged: () {
        // vm.formKey.currentState?.save();
        vm.isValidFormNotifier.value = vm.isValid;
      },
      child: child,
    );
  }
}
