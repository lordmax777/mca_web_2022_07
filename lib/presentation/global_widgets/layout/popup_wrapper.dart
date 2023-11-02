import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/spaced_column.dart';

class PopupWrapper extends StatelessWidget {
  final List<Widget> children;
  const PopupWrapper({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final width = context.width;
    final bool make1Column = width < 1600;
    if (!make1Column) {
      return Wrap(
        alignment: WrapAlignment.spaceEvenly,
        runAlignment: WrapAlignment.start,
        runSpacing: 16.0,
        children: children,
      );
    }
    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      verticalSpace: 16.0,
      children: children,
    );
  }
}
