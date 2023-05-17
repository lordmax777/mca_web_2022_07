import '../theme/theme.dart';

class SimplePopupMenu {
  final String label;
  final VoidCallback onTap;
  final HeroIcons? icon;

  SimplePopupMenu({required this.label, required this.onTap, this.icon});
}

class SimplePopupMenuWidget extends StatelessWidget {
  final List<SimplePopupMenu> menus;
  final Widget? child;
  final Color? iconColor;
  final Offset? offset;

  const SimplePopupMenuWidget({
    super.key,
    required this.menus,
    this.child,
    this.iconColor,
    this.offset,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 30,
      offset: offset ?? const Offset(0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      tooltip: "",
      icon: Icon(
        Icons.more_vert,
        color: iconColor ?? ThemeColors.white,
      ),
      itemBuilder: (_) =>
          menus.map<PopupMenuItem>((e) => _buildItem(e)).toList(),
      child: child,
    );
  }

  PopupMenuItem _buildItem(SimplePopupMenu e) {
    return PopupMenuItem(
      onTap: e.onTap,
      value: e.label.toString(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      height: 36.0,
      child: KText(
        icon: e.icon == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: HeroIcon(
                  e.icon!,
                  color: ThemeColors.gray2,
                  size: 16.0,
                ),
              ),
        isIconRight: false,
        text: e.label,
        isSelectable: false,
        fontSize: 14.0,
        fontWeight: FWeight.medium,
        textColor: ThemeColors.gray2,
      ),
    );
  }
}
