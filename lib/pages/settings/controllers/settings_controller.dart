import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../manager/redux/middlewares/users_middleware.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';
import '../../../theme/theme.dart';
import '../../adminstration.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();
  //UI Variables
  final RxDouble _deleteBtnOpacity = 0.5.obs;

  List<String> settingsMenus = Constants.settingsSection.values.toList().obs;
  final RxString _settingState = Constants.settingsSection.values.first.obs;
  String get settingState => _settingState.value;

  void updateSettingsState(int i) {
    _settingState.value = settingsMenus[i];
  }

  //Functions
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
