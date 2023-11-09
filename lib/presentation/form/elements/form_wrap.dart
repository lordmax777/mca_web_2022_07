import 'package:flutter/material.dart';

class FormWrap extends StatelessWidget {
  final List<Widget> children;
  final WrapAlignment alignment;
  const FormWrap(
      {super.key,
      required this.children,
      this.alignment = WrapAlignment.start});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      runAlignment: WrapAlignment.start,
      spacing: 24.0,
      runSpacing: 16.0,
      children: children,
    );
  }
}
