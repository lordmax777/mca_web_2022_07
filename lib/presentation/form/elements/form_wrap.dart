import 'package:flutter/material.dart';

class FormWrap extends StatelessWidget {
  final List<Widget> children;
  const FormWrap({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      spacing: 32,
      runSpacing: 16.0,
      children: children,
    );
  }
}
