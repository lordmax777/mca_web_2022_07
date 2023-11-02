import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mca_dashboard/presentation/form/models/dp_item.dart';

class SwitchModel {
  final String name;
  final ValueChanged<bool?>? onChanged;
  final bool initialValue;
  final String? hintText;
  final String? helperText;
  final bool enabled;
  final String? Function(bool?)? validator;
  final String title;

  const SwitchModel({
    required this.name,
    this.initialValue = false,
    this.onChanged,
    required this.title,
    this.hintText,
    this.helperText,
    this.enabled = true,
    this.validator,
  });
}
