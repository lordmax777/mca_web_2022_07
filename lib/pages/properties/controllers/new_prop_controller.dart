import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';

import '../../../comps/dropdown_widget1.dart';
import '../../../theme/theme.dart';

class NewPropController extends GetxController {
  static NewPropController get to => Get.find();

  GlobalKey<FormState> shiftDetailsFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> ratesFormKey = GlobalKey<FormState>();

  //Shift Details
  final TextEditingController shiftNameController = TextEditingController();
  CodeMap<int> shiftLocation = CodeMap<int>(name: null, code: null);
  CodeMap<int> shiftClient = CodeMap<int>(name: null, code: null);
  CodeMap<int> shiftWarehouse = CodeMap<int>(name: null, code: null);
  CodeMap<int> shiftChecklistTemplate = CodeMap<int>(name: null, code: null);
  bool shiftChecklistOn = false;
  bool shiftStatus = true;
  final Map<int, String> shiftDays = {};

  void updateShiftDetails(DpItem<dynamic> p0) {
    shiftLocation.name = p0.item.name;
    shiftLocation.code = p0.item.id;
    update(["shiftDetails"]);
  }

  void updateShiftClient(DpItem<dynamic> p0) {
    shiftClient.name = p0.item.name;
    shiftClient.code = p0.item.id;
    update(["shiftDetails"]);
  }

  void updateShiftWarehouse(DpItem<dynamic> p0) {
    shiftWarehouse.name = p0.item.name;
    shiftWarehouse.code = p0.item.id;
    update(["shiftDetails"]);
  }

  void updateShiftDays(MapEntry<int, String> day) {
    if (shiftDays.containsKey(day.key)) {
      shiftDays.remove(day.key);
    } else {
      shiftDays[day.key] = day.value;
    }
    update(["shiftDetails"]);
  }

  void updateShiftStatus(bool active) {
    shiftStatus = active;
    update(["shiftDetails"]);
  }

  void updateShiftChecklistAvailable(bool active) {
    shiftChecklistOn = active;
    update(["shiftDetails"]);
  }

  void updateShiftChecklistTemplate(DpItem<dynamic> p0) {
    shiftChecklistTemplate.name = p0.item.name;
    shiftChecklistTemplate.code = p0.item.id;
    update(["shiftDetails"]);
  }

  @override
  void onClose() {
    //Init all
    shiftNameController.dispose();
    shiftLocation = CodeMap<int>(name: null, code: null);
    shiftClient = CodeMap<int>(name: null, code: null);
    shiftWarehouse = CodeMap<int>(name: null, code: null);
    shiftChecklistTemplate = CodeMap<int>(name: null, code: null);
    shiftChecklistOn = false;
    shiftStatus = true;
    shiftDays.clear();

    super.onClose();
  }
}
