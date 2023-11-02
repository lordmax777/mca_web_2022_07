import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mca_dashboard/presentation/form/models/dp_item.dart';

class CheckboxModel {
  final String name;
  final List<DpItem> items;
  final ValueChanged<List<String>?>? onChanged;
  final List<String>? initialValues;
  final List<String>? disabled;
  final String? hintText;
  final String? helperText;
  final bool enabled;
  final String? Function(List<String>?)? validator;
  final OptionsOrientation? orientation;

  const CheckboxModel({
    required this.name,
    required this.items,
    this.onChanged,
    this.orientation,
    this.initialValues,
    this.disabled,
    this.hintText,
    this.helperText,
    this.enabled = true,
    this.validator,
  });
}
