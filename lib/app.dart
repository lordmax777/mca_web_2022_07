import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'manager/manager.dart';

class MCADashboardApp extends StatefulWidget {
  const MCADashboardApp({super.key});

  @override
  State<MCADashboardApp> createState() => _MCADashboardAppState();
}

class _MCADashboardAppState extends State<MCADashboardApp> {
  final DependencyManager _dependencyManager = DependencyManager();

  // Restart the app
  void restart() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _dependencyManager.appDep.restart = restart;
  }

  final botToastBuilder = BotToastInit(); //1. call BotToastInit

  @override
  Widget build(BuildContext context) {
    print("rebuild app");
    final router = _dependencyManager.navigation.router;
    return StoreProvider<AppState>(
      store: appStore,
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        theme: _dependencyManager.appDep.appTheme.theme,
        title: 'MCA Dashboard',
        builder: (context, child) => botToastBuilder(
            context,
            MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!)),
      ),
    );
  }
}
