import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';

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
  CodeMap<int> shiftStatus = CodeMap<int>(name: null, code: null);
  CodeMap<int> shiftChecklistTemplate = CodeMap<int>(name: null, code: null);
  bool shiftChecklistOn = false;
  final Map<int, String> shiftDays = {};
  void updateShiftDetails() {
    update(["shiftDetail1"]);
  }

  //

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    //Init all
    shiftNameController.dispose();
    shiftLocation = CodeMap<int>(name: null, code: null);
    shiftClient = CodeMap<int>(name: null, code: null);
    shiftWarehouse = CodeMap<int>(name: null, code: null);
    shiftStatus = CodeMap<int>(name: null, code: null);
    shiftChecklistTemplate = CodeMap<int>(name: null, code: null);
    shiftChecklistOn = false;
    shiftDays.clear();

    super.onClose();
  }
}
