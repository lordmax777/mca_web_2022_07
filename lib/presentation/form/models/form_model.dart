import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormModel {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final ValueNotifier<bool> isValidFormNotifier = ValueNotifier(false);

  bool get isValid => formKey.currentState?.isValid ?? false;

  @Deprecated('Use getValue instead')
  Map<String, dynamic> get value => formKey.currentState?.value ?? {};

  dynamic getValue(String name) => formKey.currentState?.fields[name]?.value;

  void patchValue(Map<String, dynamic> value, {bool isSave = true}) {
    formKey.currentState?.patchValue(value);
    if (isSave) save();
  }

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

  void invalidateField(String name, String message) =>
      formKey.currentState?.fields[name]
          ?.invalidate(message, shouldFocus: false);
}
