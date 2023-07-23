import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

class DefaultLayout extends StatefulWidget {
  final Widget child;
  const DefaultLayout({super.key, required this.child});

  @override
  State<DefaultLayout> createState() => _DefaultLayoutState();
}

class _DefaultLayoutState extends State<DefaultLayout> {
  bool showNavigationBar = true;

  void switchExtended() {
    setState(() {
      showNavigationBar = !showNavigationBar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(onMenuPressed: switchExtended),
      body: Row(
        children: [
          if (showNavigationBar) DefaultNavigationRail(),
          Expanded(
              child: Column(
            children: [
              PageTitle(),
              Expanded(child: PageWrapper(child: widget.child)),
            ],
          )),
        ],
      ),
    );
  }
}

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DefaultAppBar({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: MenuButton(onMenuPressed: onMenuPressed),
      title: _getTitle(),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  Widget _getTitle() {
    return StoreConnector<AppState, GeneralState>(
        rebuildOnChange: false,
        converter: (store) => store.state.generalState,
        builder: (context, vm) {
          final companyLogoBytes = vm.companyInfo.logoBytes;
          ImageProvider companyImage = MemoryImage(companyLogoBytes);
          //company info
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SpacedRow(
                horizontalSpace: 8,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: companyImage,
                    errorBuilder: (context, error, stackTrace) {
                      return const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person));
                    },
                  ),
                  Text(vm.companyInfo.name),
                ],
              ),
              UserPopupMenuButton(fullName: vm.detailsMd.fullName)
            ],
          );
        });
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onMenuPressed,
      icon: const Icon(Icons.menu),
    );
  }
}
