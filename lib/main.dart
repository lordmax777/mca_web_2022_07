import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/app.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'manager/manager.dart';

Future<void> main() async {
  // debugRepaintRainbowEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();

  Logger.init(GlobalConstants.enableLogger,
      isShowFile: false, isShowNavigation: false, isShowTime: false);

  final DependencyManager dependencyManager = DependencyManager();
  await initDependencies(dependencyManager);

  setupDomain();

  EquatableConfig.stringify = true;
  // if (kDebugMode) {
  runApp(const MCADashboardApp());
  return;
  // }
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://b7854e7c0aaf4a63bde608e75dbf0fc0@o4505600505675776.ingest.sentry.io/4505600506658816';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MCADashboardApp()),
  );
}

//initialize dependencies
Future<void> initDependencies(DependencyManager dependencyManager) async {
  await dependencyManager.init();
}
