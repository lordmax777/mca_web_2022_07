import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/intl_conf/intl/l10n.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';

import 'manager/general_controller.dart';
import 'manager/router/route_guards.dart';

final appRouter = AppRouter(authGuard: AuthGuard());

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class McaWebApp extends StatefulWidget {
  const McaWebApp({Key? key}) : super(key: key);

  @override
  State<McaWebApp> createState() => _McaWebAppState();
}

class _McaWebAppState extends State<McaWebApp> {
  @override
  void initState() {
    super.initState();
    Get.addKey(appRouter.navigatorKey);
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: appStore,
      child: GetMaterialApp.router(
        // scrollBehavior: CustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.delegate(initialRoutes: [
          if (kDebugMode) const HomeRoute(children: [SchedulingRoute()])
        ]),
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
            defaultScale: true,
            breakpoints: const [
              ResponsiveBreakpoint.resize(480, name: MOBILE),
              ResponsiveBreakpoint.resize(800, name: TABLET),
              ResponsiveBreakpoint.resize(1920, name: DESKTOP),
            ]),
      ),
    );
  }
}
