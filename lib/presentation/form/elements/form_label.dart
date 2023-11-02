import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/form/models/label_model.dart';

class FormLabel extends StatelessWidget {
  final LabelModel vm;
  const FormLabel({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Text(vm.text, style: Theme.of(context).textTheme.titleMedium);
  }
}
