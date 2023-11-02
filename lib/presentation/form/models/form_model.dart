import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormModel {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  final ValueNotifier<bool> isValidFormNotifier = ValueNotifier(false);
}
