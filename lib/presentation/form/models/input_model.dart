import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class InputModel {
  ///This will form the key in the form value Map
  final String name;
  final String? initialValue;
  final ValueChanged<String?>? onChanged;
  final int? maxLines;
  final List<FormFieldValidator<String>> validators;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final bool? readOnly;
  final String? hintText;
  final String? helperText;
  final ValueTransformer<String?>? valueTransformer;

  const InputModel({
    required this.name,
    this.initialValue,
    this.onChanged,
    this.valueTransformer,
    this.helperText,
    this.enabled = true,
    this.readOnly,
    this.maxLines,
    this.hintText,
    this.validators = const [],
    this.inputFormatters = const [],
  });
}
