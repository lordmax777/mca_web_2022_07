import 'package:get/get.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../app.dart';

class TalkerController extends GetxController {
  static TalkerController get to => Get.find<TalkerController>();

  late Talker talker;
  bool isTalkerReady = false;

  Widget talkerWrapper({required Widget child}) {
    return TalkerWrapper(
      talker: talker,
      options: const TalkerWrapperOptions(
        enableErrorAlerts: true,
        enableExceptionAlerts: true,
      ),
      child: child,
    );
  }

  Widget? fab() {
    if (!isTalkerReady) return null;
    return FloatingActionButton(
        onPressed: goToLogs, child: const Icon(Icons.developer_mode));
  }

  void goToLogs() {
    appRouter.pushWidget(TalkerScreen(talker: talker));
  }

  @override
  void onInit() {
    super.onInit();
    final t = TalkerFlutter.init();
    talker = t;
    isTalkerReady = Constants.enableTalker;
    if (!Constants.enableTalker) {
      talker.disable();
    }
  }
}
