import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'manager/manager.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
    final textTheme = Theme.of(context).textTheme;
    final router = _dependencyManager.navigation.router;
    return StoreProvider<AppState>(
      store: appStore,
      child: MaterialApp.router(
        routerConfig: router,
        debugShowCheckedModeBanner: kDebugMode,
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blueAccent,
            foregroundColor: Colors.white,
          ),
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            backgroundColor: Colors.white,
            accentColor: Colors.blueAccent,
            errorColor: Colors.redAccent,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return Colors.blueAccent;
              }),
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.black54;
                }
                return Colors.white;
              }),
            ),
          ),
          textTheme: GoogleFonts.nunitoTextTheme(),
          dividerColor: Colors.grey,
        ),
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
