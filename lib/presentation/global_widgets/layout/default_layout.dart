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
    return StoreConnector<AppState, CompanyInfoMd>(
        rebuildOnChange: false,
        converter: (store) => store.state.generalState.companyInfo,
        builder: (context, vm) {
          final logoBytes = vm.logoBytes;
          ImageProvider image = MemoryImage(logoBytes);
          return SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            horizontalSpace: 8,
            children: [
              Image(
                image: image,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error_outline));
                },
              ),
              Text(vm.name),
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
