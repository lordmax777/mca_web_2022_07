import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/spaced_column.dart';
import 'package:mca_dashboard/utils/utils.dart';

class FormContainer extends StatefulWidget {
  final List<Widget> left;
  final List<Widget>? right;
  final List<Widget> hidden;
  final String? additionalText;
  final double? width;
  final String? title;
  final Widget? trailing;
  final Widget? titleWidget;
  final bool hiddenInitially;

  const FormContainer(
      {super.key,
      required this.left,
      this.right,
      this.trailing,
      this.hiddenInitially = true,
      this.title,
      this.width,
      this.titleWidget,
      this.hidden = const [],
      this.additionalText});

  @override
  State<FormContainer> createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  List<Widget> get left => widget.left;
  List<Widget>? get right => widget.right;
  List<Widget> get hidden => widget.hidden;
  String? get additionalText => widget.additionalText;
  double? get width => widget.width;
  String? get title => widget.title;
  Widget? get trailing => widget.trailing;
  Widget? get titleWidget => widget.titleWidget;

  late bool showHidden = !widget.hiddenInitially;

  void toggleHidden() {
    setState(() {
      showHidden = !showHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (titleWidget != null) titleWidget!,
                if (title != null)
                  Text(
                    title!,
                    style: context.textTheme.titleLarge,
                  ),
                if (trailing != null) trailing!,
              ],
            ),
            if (title != null || titleWidget != null || trailing != null)
              Divider(color: Colors.grey.shade300),
            getRow(),
            if (hidden.isNotEmpty) const SizedBox(height: 8),
            if (hidden.isNotEmpty)
              OutlinedButton.icon(
                // style: ButtonStyle(
                //     padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: toggleHidden,
                label: Text(
                    additionalText ?? "Show ${showHidden ? "less" : "more"}"),
                icon: Icon(showHidden
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down),
              ),
            if (showHidden) const SizedBox(height: 8),
            Visibility(
              maintainState: true,
              visible: showHidden,
              child: SpacedColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                verticalSpace: 8,
                children: hidden,
              ),
            )
          ]),
    );
  }

  Widget getRow() {
    if (right == null) {
      return SpacedColumn(
        verticalSpace: 8,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: left,
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: SpacedColumn(
            verticalSpace: 8,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: left,
          )),
          const SizedBox(width: 16),
          Expanded(
              child: SpacedColumn(
            verticalSpace: 8,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: right!,
          )),
        ],
      );
    }
  }
}
