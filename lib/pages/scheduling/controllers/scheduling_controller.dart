import 'package:get/get.dart';
import 'package:draggable_grid/draggable_grid.dart';

class SchedulingController extends GetxController {
  static SchedulingController get to => Get.find();
  final RxInt i = 0.obs;

  final Configs config = Configs();

  @override
  void onReady() {
    super.onReady();
  }
}
