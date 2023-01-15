import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';

import '../../../comps/dropdown_widget1.dart';
import '../../../comps/modals/custom_time_picker.dart';
import '../../../theme/theme.dart';

class NewPropController extends GetxController {
  static NewPropController get to {
    if (Get.isRegistered<NewPropController>()) {
      return Get.find<NewPropController>();
    } else {
      return Get.put(NewPropController());
    }
  }

  //Shift Details
  GlobalKey<FormState> shiftDetailsFormKey = GlobalKey<FormState>();
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

  //Timings
  GlobalKey<FormState> timingFormKey = GlobalKey<FormState>();
  final TextEditingController timingStartTime = TextEditingController();
  final TextEditingController timingEndTime = TextEditingController();
  final TextEditingController timingStartBreakTime = TextEditingController();
  final TextEditingController timingEndBreakTime = TextEditingController();
  final TextEditingController timingMobileStartTime = TextEditingController();
  final TextEditingController timingMobileEndTime = TextEditingController();
  final TextEditingController timingMobileStartBreakTime =
      TextEditingController();
  final TextEditingController timingMobileEndBreakTime =
      TextEditingController();
  RxBool timingStrictBreakTime = false.obs;

  void updateTimingStrictBreakTime(bool active) {
    timingStrictBreakTime.value = active;
    update(["timings"]);
  }

  void updateTimeController(
      BuildContext context, TextEditingController tec) async {
    TimeOfDay? val = await showCustomTimePicker(context);
    if (val != null) {
      // ignore: use_build_context_synchronously
      tec.text = val.format(context);
    } else {
      tec.text = "";
    }
    update(["timings"]);
  }

  void updateStrictBreakTime(bool active) {
    timingStrictBreakTime.value = active;
    update(["timings"]);
  }

  //Rates
  GlobalKey<FormState> ratesFormKey = GlobalKey<FormState>();
  final TextEditingController rateMinWorkingTime = TextEditingController();
  final TextEditingController ratePaidTime = TextEditingController();
  final RxBool rateSplitTime = false.obs;
  final List<CustomRate> customRates = [];

  void updateRateSplitTime(bool active) {
    rateSplitTime.value = active;
    update(["rates"]);
  }

  void removeCustomRate(int i) {
    customRates.removeAt(i);
    update(["rates"]);
  }

  void addCustomRate() {
    if (customRates.isNotEmpty) {
      if (customRates.last.formKey.currentState!.validate()) {
        customRates.add(CustomRate());
        update(["rates"]);
      }
    } else {
      customRates.add(CustomRate());
      update(["rates"]);
    }
  }

  //Save all
  void onSave() async {
    shiftDetailsFormKey.currentState!.reset();
    timingFormKey.currentState!.reset();
    // ratesFormKey.currentState!.reset();
    if (shiftDetailsFormKey.currentState!.validate()) {
      //TODO: Validate Days
      logger("Shift Details Validated");
    }
    if (timingFormKey.currentState!.validate()) {
      logger("Timing Validated");
    }
    if (ratesFormKey.currentState!.validate()) {
      for (CustomRate rate in customRates) {
        if (rate.formKey.currentState!.validate()) {
          logger("Custom Rate${rate.name?.text} Validated");
        }
      }
      logger("Rates Validated");
    }
  }
}

class CustomRate {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController? name;
  TextEditingController? rate;
  TextEditingController? minTime;
  TextEditingController? paidTime;
  bool splitTime;

  @override
  String toString() {
    return 'CustomRate{name: ${name?.text}, rate: ${rate?.text}, minTime: ${minTime?.text}, paidTime: ${paidTime?.text}, splitTime: $splitTime}';
  }

  CustomRate({
    this.name,
    this.rate,
    this.minTime,
    this.paidTime,
    this.splitTime = false,
  }) {
    name ??= TextEditingController();
    rate ??= TextEditingController();
    minTime ??= TextEditingController();
    paidTime ??= TextEditingController();
  }
}
