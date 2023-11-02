import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/form/elements/form_label.dart';
import 'package:mca_dashboard/presentation/form/models/label_model.dart';

class FormWithLabel extends StatelessWidget {
  final LabelModel labelVm;
  final Widget formBuilderField;
  const FormWithLabel(
      {super.key, required this.labelVm, required this.formBuilderField});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        FormLabel(vm: labelVm),
        const SizedBox(height: 4),
        formBuilderField,
      ],
    );
  }
}
