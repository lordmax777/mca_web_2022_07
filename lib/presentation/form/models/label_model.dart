import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class LabelModel {
  final String text;
  final bool isRequired;
  const LabelModel({
    required this.text,
    this.isRequired = false,
  });
}
