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
      _generalItems.add(ExpandableItemWidget(
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

class ExpandableItemWidget extends StatefulWidget {
  final String title;
  final Widget child;
  final bool isExpanded;
  final ValueChanged<LabeledGlobalKey<ExpandableItemWidgetState>>? onEditName;
  final ValueChanged<LabeledGlobalKey<ExpandableItemWidgetState>>? onDelete;
  const ExpandableItemWidget(
      {Key? key,
      required this.title,
      required this.child,
      this.onDelete,
      this.onEditName,
      this.isExpanded = false})
      : super(key: key);

  @override
  State<ExpandableItemWidget> createState() => ExpandableItemWidgetState();
}

class ExpandableItemWidgetState extends State<ExpandableItemWidget> {
  bool? _isExpanded;

  final TextEditingController title = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isExpanded) {
      _isExpanded = widget.isExpanded;
    }
    title.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      maintainState: true,
      initiallyExpanded: widget.isExpanded,
      childrenPadding:
          const EdgeInsets.only(left: 48.0, bottom: 24.0, top: 24.0),
      tilePadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
      trailing: _getTrailing(),
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
        title.text,
        style: const TextStyle(
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

  Widget _getTrailing() {
    final List<Widget> trailing = [];
    if (widget.onEditName != null) {
      trailing.add(
        IconButton(
            onPressed: () {
              widget.onEditName!(
                  widget.key as LabeledGlobalKey<ExpandableItemWidgetState>);
            },
            icon: const HeroIcon(HeroIcons.edit,
                color: ThemeColors.gray5, size: 18.0)),
      );
    }
    if (widget.onDelete != null) {
      trailing.add(
        IconButton(
            onPressed: () {
              widget.onDelete!(
                  widget.key as LabeledGlobalKey<ExpandableItemWidgetState>);
            },
            icon: const HeroIcon(HeroIcons.bin,
                color: ThemeColors.red3, size: 18.0)),
      );
    }

    return SpacedRow(mainAxisSize: MainAxisSize.min, children: trailing);
  }
}
