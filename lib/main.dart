import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/deps_list_controller.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/groups_list_controller.dart';
import 'package:mca_web_2022_07/pages/handover_types/controllers/handover_controller.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/new_location_controller.dart';
import 'package:mca_web_2022_07/pages/qualifications/controllers/qualifs_list_controller.dart';
import 'package:mca_web_2022_07/pages/warehouses/controllers/warehouse_controller.dart';

import 'app.dart';
import 'package:get/get.dart';

import 'pages/locations/controllers/locations_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.init(kDebugMode,
      isShowFile: false, isShowTime: false, isShowNavigation: false);
  Get.lazyPut(() => DepartmentsController());
  Get.lazyPut(() => GroupsController());
  Get.lazyPut(() => QualifsController());
  Get.lazyPut(() => WarehouseController());
  Get.lazyPut(() => HandoverTypesController());
  Get.lazyPut(() => LocationsController());
  Get.lazyPut(() => NewLocationController());

  runApp(const McaWebApp());
}
