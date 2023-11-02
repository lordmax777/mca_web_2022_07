import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class DatePickerModel {
  ///This will form the key in the form value Map
  final String name;
  final DateTime? initialValue;
  final ValueChanged<DateTime?>? onChanged;
  final int? maxLines;
  final List<FormFieldValidator<DateTime>> validators;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final DateFormat? format;
  final InputType type;
  const DatePickerModel({
    required this.name,
    this.initialValue,
    this.onChanged,
    this.helperText,
    this.format,
    this.enabled = true,
    this.maxLines,
    this.hintText,
    this.type = InputType.date,
    this.validators = const [],
    this.inputFormatters = const [],
  });
}
