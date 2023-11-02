import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormModel {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final ValueNotifier<bool> isValidFormNotifier = ValueNotifier(false);

  bool get isValid => formKey.currentState?.isValid ?? false;
  Map<String, dynamic> get value => formKey.currentState?.value ?? {};

  void save() => formKey.currentState?.save();
  void reset() => formKey.currentState?.reset();
  void validate(
          {bool focusOnInvalid = true,
          bool autoScrollWhenFocusOnInvalid = false}) =>
      formKey.currentState?.validate(
          autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
          focusOnInvalid: focusOnInvalid);

  void saveAndValidate(
          {bool focusOnInvalid = true,
          bool autoScrollWhenFocusOnInvalid = false}) =>
      formKey.currentState?.saveAndValidate(
          autoScrollWhenFocusOnInvalid: autoScrollWhenFocusOnInvalid,
          focusOnInvalid: focusOnInvalid);
}
