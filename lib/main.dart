import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_dashboard/app.dart';
import 'package:mca_dashboard/setup_domain.dart';
import 'package:mca_dashboard/utils/global_constants.dart';
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

  runApp(const MCADashboardApp());
}

//initialize dependencies
Future<void> initDependencies(DependencyManager dependencyManager) async {
  await dependencyManager.init();
}
