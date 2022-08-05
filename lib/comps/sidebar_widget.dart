import '../theme/theme.dart';
import 'package:mix/mix.dart';

class YSLogoBanner extends StatelessWidget {
  final String title;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onTitlePressed;

  YSLogoBanner(
      {Key? key, required this.title, this.onMenuPressed, this.onTitlePressed})
      : super(key: key);

  Mix get boxMix => Mix(
        paddingHorizontal(16),
        const BoxAttributes(
            width: 256,
            height: 64,
            alignment: Alignment.center,
            color: ThemeColors.blue1),
      );

  Mix get logoTextMix => Mix(
      // textStyle(ThemeTextBold.xl2.copyWith(color: Colors.white)),
      letterSpacing(0.75));

  Mix flexboxMix = Mix();

  Mix iconMix = Mix(iconSize(24), iconColor(Colors.white), marginRight(50));

  @override
  Widget build(BuildContext context) {
    return Box(
      mix: boxMix,
      child: FlexBox(
        direction: Axis.horizontal,
        mix: flexboxMix,
        children: [
          MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Pressable(
                  mix: iconMix,
                  onPressed: onMenuPressed,
                  child: const IconMix(Icons.menu))),
          Pressable(
              onPressed: onTitlePressed,
              child: TextMix(title, mix: logoTextMix)),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class YSInfoBanner extends StatelessWidget {
  final String infoBarUpperText;
  final String infoBarLowerText;
  YSInfoBanner(
      {Key? key,
      required this.infoBarLowerText,
      required this.infoBarUpperText})
      : super(key: key);

  Mix get boxMix => Mix(
        // elevation(1),
        paddingHorizontal(16),
        const BoxAttributes(
            width: 256,
            height: 64,
            alignment: Alignment.center,
            color: ThemeColors.white),
      );

  Mix get upperTextMix => Mix(
      // textStyle(
      //     ThemeTextSemiBold.sm.copyWith(color: ThemeColors.coolgray800)),
      );

  Mix get lowerTextMix => Mix(
      // textStyle(
      //     ThemeTextMedium.base.copyWith(color: ThemeColors.coolgray400)),
      );

  Mix flexboxMix = Mix();

  Mix iconMix = Mix(iconSize(24), iconColor(Colors.white), marginRight(50));

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      elevation: .5,
      child: Box(
        mix: boxMix,
        child: FlexBox(
          direction: Axis.horizontal,
          mix: flexboxMix,
          children: [
            Box(
                mix: Mix(
                  const BoxAttributes(
                    width: 48,
                    height: 48,
                  ),
                  marginRight(12),
                ),
                child: const CircleAvatar()),
            FlexBox(
              mix: Mix(crossAxis(CrossAxisAlignment.start),
                  mainAxis(MainAxisAlignment.center)),
              direction: Axis.vertical,
              children: [
                TextMix(infoBarUpperText, mix: upperTextMix),
                TextMix(infoBarLowerText, mix: lowerTextMix),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class YSSidebar extends StatefulWidget {
  final List<YSSidebarParentItem> children;
  final String title;
  final String? infoBarUpperText;
  final String? infoBarLowerText;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onTitlePressed;
  final int currentIndex;
  void Function(int)? onTabChange;
  final Widget? bottomWidget;
  YSSidebar(
      {Key? key,
      this.infoBarUpperText,
      this.infoBarLowerText,
      this.title = 'YoShop',
      required this.children,
      this.onTitlePressed,
      this.onMenuPressed,
      this.currentIndex = 0,
      this.onTabChange,
      this.bottomWidget})
      : super(key: key);

  @override
  State<YSSidebar> createState() => _YSSidebarState();
}

class _YSSidebarState extends State<YSSidebar> {
  int? _expandedIndex;

  Mix parentFlexboxMix = Mix(
    mainAxis(MainAxisAlignment.start),
    crossAxis(CrossAxisAlignment.start),
  );

  Mix boxMix = Mix(const BoxAttributes(color: ThemeColors.white));

  @override
  Widget build(BuildContext context) {
    return Box(
      mix: boxMix,
      child:
          FlexBox(mix: parentFlexboxMix, direction: Axis.vertical, children: [
        YSLogoBanner(
            title: widget.title,
            onMenuPressed: widget.onMenuPressed,
            onTitlePressed: widget.onTitlePressed),
        if (widget.infoBarLowerText != null && widget.infoBarUpperText != null)
          YSInfoBanner(
              infoBarLowerText: widget.infoBarLowerText!,
              infoBarUpperText: widget.infoBarUpperText!),
        Flexible(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: SpacedColumn(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalSpace: 8,
                    children: _buildSidebarChildren()),
              ),
              if (widget.bottomWidget != null)
                Positioned(width: 234, bottom: 0, child: widget.bottomWidget!)
            ],
          ),
        ),
      ]),
    );
  }

  // Builds the children of the sidebar.
  List<Widget> _buildSidebarChildren() {
    final List<Widget> children = [];
    for (int i = 0; i < widget.children.length; i++) {
      final _item = widget.children[i];
      children.add(
        YSSidebarParentItem(
          title: _item.title,
          isExpanded: _expandedIndex == i,
          isActive: i == widget.currentIndex,
          icon: _item.icon,
          onPressed: () {
            if (_item.children == null || _item.children!.isEmpty) {
              widget.onTabChange?.call(i);
            } else {
              setState(() {
                _expandedIndex = _expandedIndex == i ? null : i;
              });
            }
            if (_item.onPressed != null) {
              _item.onPressed!();
            }
          },
          children: _item.children != null && _item.children!.isNotEmpty
              ? _item.children!
                  .map<YSSidebarChildItem>(
                    (e) => YSSidebarChildItem(
                        title: e.title,
                        icon: e.icon,
                        isSelected: widget.currentIndex ==
                            (_item.children!.length +
                                _item.children!.indexOf(e)),
                        onPressed: () {
                          widget.onTabChange!.call((_item.children!.length +
                              _item.children!.indexOf(e)));
                        }),
                  )
                  .toList()
              : null,
        ),
      );
    }
    return children;
  }
}

class YSSidebarParentItem extends StatelessWidget {
  final IconData? icon;
  final String title;

  /// Widget as YSSidebarChildItem
  /// If children is not null and is not empty, the arrow key appears and open the children on pressed.
  final List<YSSidebarChildItem>? children;

  ///No need to pass from root YSSidebar. This is changed internally
  bool isExpanded;
  final VoidCallback? onPressed;

  bool isActive;
  YSSidebarParentItem(
      {Key? key,
      this.children,
      required this.title,
      this.icon,
      this.onPressed,
      this.isActive = false,
      this.isExpanded = false}) {
    if (children == null) {
      isExpanded = isActive;
    }
  }

  Mix get iconMix => Mix(iconSize(24),
      iconColor(isExpanded ? ThemeColors.white : ThemeColors.blue9));

  Mix get boxMix => Mix(
        width(234),
        height(40),
        rounded(6),
        paddingHorizontal(12),
        bgColor(isExpanded ? ThemeColors.blue9 : Colors.transparent),
      );

  Mix get titleMix => Mix(
      // textStyle(ThemeTextRegular.sm
      // .apply(color: isExpanded ? ThemeColors.white : ThemeColors.coolgray800))
      );

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      verticalSpace: isExpanded ? 12 : 0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Pressable(
          onPressed: onPressed,
          child: Box(
            mix: boxMix,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SpacedRow(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  horizontalSpace: 8,
                  children: [
                    if (icon != null) IconMix(icon!, mix: iconMix),
                    TextMix(title, mix: titleMix),
                  ],
                ),
                if (children != null && children!.isNotEmpty)
                  AnimatedRotation(
                      duration: const Duration(milliseconds: 100),
                      turns: !isExpanded ? 0 : 1 / 4,
                      child:
                          IconMix(Icons.chevron_right_rounded, mix: iconMix)),
              ],
            ),
          ),
        ),
        if (children != null && children!.isNotEmpty)
          AnimatedContainer(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              height: isExpanded ? children!.length * 40 : 0,
              duration: const Duration(milliseconds: 100),
              child: SpacedColumn(
                children: children!.map<Widget>((e) => e).toList(),
              )),
      ],
    );
  }
}

class YSSidebarChildItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onPressed;
  const YSSidebarChildItem(
      {Key? key,
      this.onPressed,
      this.icon,
      this.isSelected = false,
      required this.title})
      : super(key: key);
  Mix get iconMix => Mix(iconSize(24), iconColor(ThemeColors.blue9));

  Mix get boxMix => Mix(
        width(234),
        height(40),
        rounded(6),
        paddingHorizontal(12),
        bgColor(isSelected ? ThemeColors.blue9 : Colors.transparent),
      );

  // Mix get titleMix =>
  // Mix(textStyle(ThemeTextRegular.sm.apply(color: ThemeColors.blue9))
  // );
  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPressed: onPressed,
      child: Box(
        mix: boxMix,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              horizontalSpace: 8,
              children: [
                if (icon != null) IconMix(icon!, mix: iconMix),
                TextMix(
                  title,

                  // mix: titleMix
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
