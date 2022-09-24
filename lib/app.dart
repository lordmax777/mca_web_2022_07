import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/intl_conf/intl/l10n.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/router/router.gr.dart';

final appRouter = AppRouter();

class McaWebApp extends StatelessWidget {
  const McaWebApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: appStore,
      child: MaterialApp.router(
        routerDelegate: appRouter.delegate(),
        routeInformationParser: appRouter.defaultRouteParser(),
        localizationsDelegates: const [
          AppIntl
              .delegate, // Add this line. The name comes from class_name in pubspec.yaml
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: const Locale('en'),
        builder: (context, child) => ResponsiveWrapper.builder(child,
            // maxWidth: 1920,
            // minWidth: 480,
            defaultScale: true,
            breakpoints: const [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.resize(1920, name: DESKTOP),
            ]),
      ),
    );
  }
}
