import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/widgets.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

class CustomScrollbar extends StatefulWidget {
  final Widget child;
  const CustomScrollbar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<CustomScrollbar> createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  final ScrollController horizontalScrollController = ScrollController();
  final ScrollController verticalScrollController = ScrollController();

  @override
  void dispose() {
    horizontalScrollController.dispose();
    verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScrollbar(
        controller: verticalScrollController,
        child: AdaptiveScrollbar(
            controller: horizontalScrollController,
            position: ScrollbarPosition.bottom,
            child: SingleChildScrollView(
              controller: verticalScrollController,
              child: SingleChildScrollView(
                controller: horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(child: widget.child),
              ),
            )));
  }
}
