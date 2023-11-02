import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mca_dashboard/presentation/form/models/form_model.dart';

class DefaultForm extends StatelessWidget {
  final FormModel vm;
  final Widget child;
  const DefaultForm({super.key, required this.vm, required this.child});

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: vm.formKey,
      onChanged: () {
        vm.isValidFormNotifier.value =
            vm.formKey.currentState?.isValid ?? false;
      },
      child: child,
    );
  }
}
