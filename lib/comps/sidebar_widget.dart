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
        paddingVertical(16),
        const BoxAttributes(
            width: 280,
            // height: 64,
            alignment: Alignment.center,
            color: ThemeColors.white),
      );

  Mix get logoTextMix => Mix(letterSpacing(0.75));

  Mix flexboxMix = Mix(
    align(Alignment.center),
  );

  Mix iconMix = Mix(iconSize(24), iconColor(Colors.white), marginRight(50));

  @override
  Widget build(BuildContext context) {
    return Box(
      mix: boxMix,
      child: SpacedColumn(
        verticalSpace: 24,
        children: [
          Pressable(
              onPressed: onTitlePressed,
              child: TextMix(title, mix: logoTextMix)),
          const Divider(
            thickness: 1.0,
            height: 1.0,
            color: ThemeColors.gray11,
          ),
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
  void Function(Map<String, dynamic>)? onTabChange;
  final Widget? bottomWidget;
  final int initialIndex;
  YSSidebar(
      {Key? key,
      this.infoBarUpperText,
      this.infoBarLowerText,
      this.title = 'MCA',
      required this.children,
      this.onTitlePressed,
      this.initialIndex = 0,
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
    mainAxis(MainAxisAlignment.center),
    crossAxis(CrossAxisAlignment.center),
  );

  Mix boxMix = Mix(const BoxAttributes(color: ThemeColors.white));

  @override
  void initState() {
    super.initState();
    _expandedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      mix: boxMix,
      child: Column(children: [
        YSLogoBanner(
            title: widget.title,
            onMenuPressed: widget.onMenuPressed,
            onTitlePressed: widget.onTitlePressed),
        if (widget.infoBarLowerText != null && widget.infoBarUpperText != null)
          YSInfoBanner(
              infoBarLowerText: widget.infoBarLowerText!,
              infoBarUpperText: widget.infoBarUpperText!),
        SingleChildScrollView(
          child:
              SpacedColumn(verticalSpace: 8, children: _buildSidebarChildren()),
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
            setState(() {
              _expandedIndex = _expandedIndex == i ? null : i;
            });
            if (_item.onPressed != null) {
              _item.onPressed!();
            }
          },
          children: _item.children != null && _item.children!.isNotEmpty
              ? _item.children!
                  .map<YSSidebarChildItem>(
                    (e) => YSSidebarChildItem(
                        name: e.name,
                        title: e.title,
                        icon: e.icon,
                        isSelected: e.isSelected,
                        onPressed: () {
                          widget.onTabChange!
                              .call(({"name": e.name, "index": i}));
                          if (e.onPressed != null) {
                            e.onPressed!();
                          }
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
  final HeroIcons? icon;
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

  Mix get boxMix => Mix(
        width(254),
        height(40),
        rounded(6),
        paddingHorizontal(12),
        bgColor(isExpanded ? ThemeColors.blue12 : Colors.transparent),
      );

  Mix get titleMix => Mix(textStyle(ThemeText.md1
      .apply(color: !isExpanded ? ThemeColors.gray5 : ThemeColors.blue3)));

  @override
  Widget build(BuildContext context) {
    return SpacedColumn(
      verticalSpace: isExpanded ? 12 : 0,
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
                    if (icon != null)
                      HeroIcon(icon!,
                          size: 24,
                          color: !isExpanded
                              ? ThemeColors.gray5
                              : ThemeColors.blue3),
                    TextMix(title, mix: titleMix),
                  ],
                ),
                if (children != null && children!.isNotEmpty)
                  AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: !isExpanded ? 1 : 1 / 2,
                      child: const IconMix(
                        Icons.keyboard_arrow_down,
                      )),
              ],
            ),
          ),
        ),
        if (children != null && children!.isNotEmpty)
          AnimatedContainer(
              foregroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: ThemeColors.gray11, width: 1),
              ),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
              height: isExpanded ? children!.length * 35 : 0,
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
  final String name;
  const YSSidebarChildItem(
      {Key? key,
      this.onPressed,
      this.icon,
      required this.name,
      this.isSelected = false,
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Pressable(
        onPressed: onPressed,
        child: Container(
          width: 280,
          height: 35,
          color: ThemeColors.gray12,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
          child: Text(
            title,
            style: ThemeText.md2.apply(
                color: !isSelected ? ThemeColors.gray5 : ThemeColors.blue3),
            // mix: titleMix
          ),
        ),
      ),
    );
  }
}
