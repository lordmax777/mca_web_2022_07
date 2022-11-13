import '../theme/theme.dart';

class ExpandedWidgetType {
  final String title;
  final Widget child;
  final bool initExpanded;

  ExpandedWidgetType({
    required this.title,
    required this.child,
    this.initExpanded = false,
  });
}

class CustomExpandableTabBar extends StatefulWidget {
  List<ExpandedWidgetType> expandedWidgetList;
  final String? saveText;
  final VoidCallback? onSave;
  CustomExpandableTabBar(
      {Key? key, required this.expandedWidgetList, this.saveText, this.onSave})
      : super(key: key);

  @override
  State<CustomExpandableTabBar> createState() => _CustomExpandableTabBarState();
}

class _CustomExpandableTabBarState extends State<CustomExpandableTabBar> {
  final List<Widget> _generalItems = [];

  @override
  void initState() {
    super.initState();
    _addGeneralTabItems();
  }

  void _addGeneralTabItems() {
    for (var element in widget.expandedWidgetList) {
      _generalItems.add(_ExpandableItemWidget(
          title: element.title,
          isExpanded: element.initExpanded,
          child: element.child));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          const Divider(color: ThemeColors.gray11, height: 1.0, thickness: 1.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _generalItems.length + 1,
      itemBuilder: (context, index) {
        if (widget.onSave != null && index == _generalItems.length) {
          return SaveAndCancelButtonsWidget(
            saveText: widget.saveText,
            formKeys: [],
            onSave: widget.onSave,
          );
        }
        return _generalItems[index];
      },
    );
  }
}

class _ExpandableItemWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isExpanded;
  const _ExpandableItemWidget(
      {Key? key,
      required this.title,
      required this.child,
      this.isExpanded = false})
      : super(key: key);

  @override
  State<_ExpandableItemWidget> createState() => __ExpandableItemWidgetState();
}

class __ExpandableItemWidgetState extends State<_ExpandableItemWidget> {
  bool? _isExpanded;

  @override
  void initState() {
    super.initState();
    if (widget.isExpanded) {
      _isExpanded = widget.isExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      initiallyExpanded: widget.isExpanded,
      childrenPadding:
          const EdgeInsets.only(left: 48.0, bottom: 48.0, top: 24.0),
      tilePadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      trailing: const SizedBox(),
      iconColor: ThemeColors.MAIN_COLOR,
      collapsedTextColor: ThemeColors.gray2,
      textColor: ThemeColors.MAIN_COLOR,
      collapsedIconColor: ThemeColors.gray2,
      onExpansionChanged: (value) {
        setState(() {
          _isExpanded = !value;
        });
      },
      // childrenPadding: EdgeInsets.symmetric(vertical: 16.0),
      leading: HeroIcon(
          _isExpanded == null
              ? HeroIcons.down
              : !_isExpanded!
                  ? HeroIcons.up
                  : HeroIcons.down,
          size: 18.0),
      title: Text(
        widget.title,
        style: TextStyle(
            fontSize: 16.0, fontWeight: FontWeight.w500, fontFamily: "Medium"),
        // isSelectable: false,
        // fontWeight: FWeight.bold,
        // fontSize: 16.0,
        // textColor: _isExpanded ? ThemeColors.MAIN_COLOR : ThemeColors.gray2,
      ),
      expandedAlignment: Alignment.topLeft,
      children: [widget.child],
    );
  }
}
