import 'dart:math';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import '../../../comps/dropdown_widget1.dart';
import '../../../manager/models/location_item_md.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/schedule_state.dart';
import '../../../theme/theme.dart';

class SchedulingController extends GetxController {
  static SchedulingController get to => Get.find();
}
