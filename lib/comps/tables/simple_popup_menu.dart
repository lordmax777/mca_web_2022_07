import '../../theme/theme.dart';

class SimplePopupMenu {
  final String label;
  final VoidCallback onTap;

  SimplePopupMenu({required this.label, required this.onTap});
}

class SimplePopupMenuWidget extends StatelessWidget {
  // final GlobalKey gKey = GlobalKey();

  final List<SimplePopupMenu> menus;
  final HeroIcons icon;

  const SimplePopupMenuWidget(
      {super.key, required this.menus, this.icon = HeroIcons.moreVertical});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      // offset: const Offset(30.0, 0.0),
      elevation: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      tooltip: "More options",
      itemBuilder: (_) =>
          menus.map<PopupMenuItem>((e) => _buildItem(e)).toList(),
      // child: IconButton(
      //     alignment: Alignment.centerRight,
      //     padding: const EdgeInsets.all(0.0),
      //     onPressed: () {
      //       dynamic state = gKey.currentState;
      //       state.showButtonMenu();
      //     },
      //     icon: HeroIcon(
      //       icon,
      //       size: 24,
      //       color: ThemeColors.gray2,
      //     )),
    );
  }

  PopupMenuItem _buildItem(SimplePopupMenu e) {
    return PopupMenuItem(
      onTap: e.onTap,
      value: e.label.toString(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      height: 36.0,
      child: KText(
        text: e.label,
        isSelectable: false,
        fontSize: 14.0,
        fontWeight: FWeight.medium,
        textColor: ThemeColors.gray2,
      ),
    );
  }
}
