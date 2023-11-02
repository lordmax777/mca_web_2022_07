import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/form/models/form_model.dart';

class SaveButton extends StatelessWidget {
  final FormModel vm;
  final ValueChanged<Map<String, dynamic>> onSave;
  final String text;
  const SaveButton(
      {super.key, required this.vm, required this.onSave, this.text = "Save"});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: vm.isValidFormNotifier,
      builder: (context, value, child) => ElevatedButton(
        onPressed: value
            ? () {
                vm.formKey.currentState?.saveAndValidate();
                onSave(vm.formKey.currentState?.value as Map<String, dynamic>);
              }
            : null,
        child: Text(text),
      ),
    );
  }
}
