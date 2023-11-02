import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
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
    final appTheme = _dependencyManager.appDep.appTheme.theme;
    return StoreProvider<AppState>(
      store: appStore,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        theme: appTheme.copyWith(
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: appTheme.colorScheme.primary, width: 1.5)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: appTheme.colorScheme.error)),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: appTheme.colorScheme.error),
            ),
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade400)),
            helperStyle: const TextStyle(color: Colors.grey),
          ),
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
