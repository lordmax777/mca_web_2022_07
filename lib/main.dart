import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/pages/auth/controllers/login_controller.dart';
import 'package:mca_web_2022_07/pages/checklist_templates/controllers/checklist_list_controller.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/deps_list_controller.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/groups_list_controller.dart';
import 'package:mca_web_2022_07/pages/handover_types/controllers/handover_controller.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/new_location_controller.dart';
import 'package:mca_web_2022_07/pages/properties/controllers/properties_controller.dart';
import 'package:mca_web_2022_07/pages/qualifications/controllers/qualifs_list_controller.dart';
import 'package:mca_web_2022_07/pages/settings/controllers/settings_controller.dart';
import 'package:mca_web_2022_07/pages/stocks/controllers/stock_items_controller.dart';
import 'package:mca_web_2022_07/pages/stocks/controllers/stock_items_new_controller.dart';
import 'package:mca_web_2022_07/pages/warehouses/controllers/warehouse_controller.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import 'app.dart';
import 'package:get/get.dart';

import 'manager/hive.dart';
import 'pages/locations/controllers/locations_controller.dart';

Future<void> main() async {
  await setup();

  runApp(const McaWebApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.init(
    true,
    isShowFile: false,
    isShowNavigation: false,
    isShowTime: false,
  );
  Get.put(GeneralController());
  Get.lazyPut(() => LoginController());
  Get.lazyPut(() => DepartmentsController());
  Get.lazyPut(() => HiveController());
  Get.lazyPut(() => GroupsController());
  Get.lazyPut(() => QualifsController());
  Get.lazyPut(() => WarehouseController());
  Get.lazyPut(() => ChecklistController());
  Get.lazyPut(() => HandoverTypesController());
  Get.lazyPut(() => LocationsController());
  Get.lazyPut(() => NewLocationController());
  Get.lazyPut(() => StockItemsController());
  Get.lazyPut(() => StockItemsNewItemController());
  Get.lazyPut(() => SettingsController());
  Get.lazyPut(() => PreferredShiftsController());
  Get.lazyPut(() => PropertiesController());

  Get.put(TalkerController());

  await HiveController.initHive();
}
