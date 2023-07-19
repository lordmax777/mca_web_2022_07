import 'dart:async';

import 'package:flutter/foundation.dart';
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

final tokenTimerListenable = ValueNotifier<Timer?>(null);

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
              if (kDebugMode)
                ValueListenableBuilder(
                  valueListenable: tokenTimerListenable,
                  builder: (context, value, child) => Text(
                    "Token Expire Time: ${value?.tick}",
                  ),
                ),
              PopupMenuButton(
                tooltip: "User menu",
                offset: const Offset(0, 40),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context) {
                  return [
                    // logout button
                    PopupMenuItem(
                      value: "logout",
                      child: SpacedRow(
                        horizontalSpace: 8,
                        children: const [
                          Icon(Icons.logout, color: Colors.red),
                          Text("Logout"),
                        ],
                      ),
                    ),
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case "logout":
                      //show logout dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Logout"),
                            content: const Text("Are you sure?"),
                            actions: [
                              TextButton(
                                onPressed: context.pop,
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () {
                                  DependencyManager
                                      .instance.navigation.loginState
                                      .logout();
                                },
                                child: const Text("Logout"),
                              ),
                            ],
                          );
                        },
                      );
                      break;
                  }
                },
                child: SpacedRow(
                  horizontalSpace: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        color: context.colorScheme.primary,
                      ),
                    ),
                    Text(vm.detailsMd.fullName,
                        style: context.textTheme.bodyLarge!
                            .copyWith(color: Colors.white)),
                    const Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
              ),
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
