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
import '../../home_page.dart';

class SettingsController extends GetxController {
  static SettingsController get to => Get.find();
  //UI Variables
  final RxDouble _deleteBtnOpacity = 0.5.obs;
  final TextEditingController searchController = TextEditingController();

  late PlutoGridStateManager gridStateManager;

  String selectedMenu = "";

  double get deleteBtnOpacity => _deleteBtnOpacity.value;
  set setDeleteBtnOpacity(double value) {
    _deleteBtnOpacity.value = value;
  }

  //Departments
  final RxList<ListHandoverType> _deps = <ListHandoverType>[].obs;
  List<ListHandoverType> get departments => _deps;
  setList(List<ListHandoverType> d) {
    final dd = [...d];
    dd.sort((a, b) => a.title.compareTo(b.title));
    _deps.value = dd;
    return _deps;
  }

  //Functions
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
