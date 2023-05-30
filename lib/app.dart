import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/intl_conf/intl/l10n.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';

import 'manager/router/route_guards.dart';

final appRouter = AppRouter(authGuard: AuthGuard());

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
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

  final botToastBuilder = BotToastInit(); //1. call BotToastInit

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: appStore,
      child: GetMaterialApp.router(
        scrollBehavior: CustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        routerDelegate: appRouter.delegate(initialRoutes: [
          if (kDebugMode) const HomeRoute(children: [TestRoute()])
        ]),
        routeInformationParser: appRouter.defaultRouteParser(),
        localizationsDelegates: const [
          AppIntl
              .delegate, // Add this line. The name comes from class_name in pubspec.yaml
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        locale: const Locale('en'),
        theme: ThemeData(
            progressIndicatorTheme: ProgressIndicatorThemeData(
          color: ThemeColors.MAIN_COLOR,
          circularTrackColor: Colors.white,
          linearMinHeight: 8,
          linearTrackColor: Colors.white,
          refreshBackgroundColor: Colors.white,
        )),
        navigatorObservers: [BotToastNavigatorObserver()],
        builder: (context, child) {
          return botToastBuilder(
              context,
              ResponsiveWrapper.builder(child,
                  defaultScale: true,
                  breakpoints: const [
                    ResponsiveBreakpoint.resize(480, name: MOBILE),
                    ResponsiveBreakpoint.resize(800, name: TABLET),
                    ResponsiveBreakpoint.resize(1920, name: DESKTOP),
                  ]));
        },
      ),
    );
  }
}
