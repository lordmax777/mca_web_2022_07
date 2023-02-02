import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/models/property_md.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';

import '../../../comps/dropdown_widget1.dart';
import '../../../comps/modals/custom_time_picker.dart';
import '../../../theme/theme.dart';

class NewPropController extends GetxController {
  final PropertiesMd? property;

  bool get isNew => property == null;

  NewPropController({this.property});

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
    // logger(tec.formattedTime);
    TimeOfDay? val = await showCustomTimePicker(context,
        initialTime: tec.text.isNotEmpty
            ? TimeOfDay(
                hour: tec.formattedTime![0], minute: tec.formattedTime![1])
            : null);
    if (val != null) {
      // ignore: use_build_context_synchronously
      tec.text = val.format(context);
    } else {
      // if (tec.text.isNotEmpty) return;
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

  void removeCustomRate(int i) async {
    bool delete = false;
    if (customRates[i].id != 0) {
      //Show popup to ask if they want to delete
      delete = await Get.dialog(
        AlertDialog(
          content: const Text("Are you sure you want to delete this rate?"),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final success =
                    await deleteShiftSpecialRates(customRates[i].id!);
                return Get.back(result: success);
              },
              child: const Text("Delete"),
            ),
          ],
        ),
      );
    } else {
      delete = true;
    }
    if (delete) {
      customRates.removeAt(i);
      update(["rates"]);
    }
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

  Future<void> fetchShiftSpecialRates() async {
    try {
      final res = await restClient()
          .getShiftSpecialRate(property!.id!)
          .nocodeErrorHandler();
      if (res.success) {
        final data = res.data;
        customRates.clear();
        for (int i = 0; i < data['special_rates'].length; i++) {
          final item = data['special_rates'][i];
          customRates.add(CustomRate(
            minTime:
                TextEditingController(text: item['minWorkTime'].toString()),
            name: TextEditingController(text: item['name']),
            paidTime:
                TextEditingController(text: item['minPaidTime'].toString()),
            rate: TextEditingController(text: item['rate'].toString()),
            splitTime: item['splitTime'],
            id: item['id'],
          ));
        }
      }
      update(["rates"]);
    } catch (e) {
      logger(e);
    }
  }

  Future<bool> deleteShiftSpecialRates(int id) async {
    try {
      final res = await restClient()
          .deleteShiftSpecialRate(property!.id!, id)
          .nocodeErrorHandler();
      return res.success;
    } catch (e) {
      logger(e);
      return false;
    }
  }

  Future<bool> updateShiftSpecialRate(CustomRate rate) async {
    try {
      final res = await restClient()
          .postShiftSpecialRate(
            shiftId: property?.id ?? 0,
            name: rate.name?.text ?? "",
            rate: double.parse(rate.rate?.text ?? "0"),
            splitTime: rate.splitTime,
            minWorkTime: int.parse(rate.minTime?.text ?? "0"),
            minPaidTime: int.parse(rate.paidTime?.text ?? "0"),
          )
          .nocodeErrorHandler();
      return res.success;
    } catch (e) {
      logger(e);
      return false;
    }
  }

  Future<bool> createProperty() async {
    logger("Creating property");
    try {
      final res = await restClient()
          .postPropertie(
            id: property?.id ?? 0,
            //shifts
            active: shiftStatus,
            checklist: shiftChecklistOn,
            clientId: shiftClient.code!,
            locationId: shiftLocation.code!,
            title: shiftNameController.text,
            templateId: shiftChecklistTemplate.code!,
            storageId: shiftWarehouse.code!,
            dayMon: true,
            dayTue: true,
            dayFri: false,
            daySat: false,
            daySun: false,
            dayThu: false,
            dayWed: false,
            //timings

            startTime: timingStartTime.formattedTime!.join(":"),
            finishTime: timingEndTime.formattedTime!.join(":"),
            startBreak: timingStartBreakTime.formattedTime?.join(":"),
            finishBreak: timingEndBreakTime.formattedTime?.join(":"),
            fpStartTime: timingMobileStartTime.formattedTime?.join(":"),
            fpFinishTime: timingMobileEndTime.formattedTime?.join(":"),
            fpStartBreak: timingMobileStartBreakTime.formattedTime?.join(":"),
            fpFinishBreak: timingMobileEndBreakTime.formattedTime?.join(":"),
            strictBreak: timingStrictBreakTime.value,
            //rates
            splitTime: rateSplitTime.value,
            minPaidTime: int.parse(ratePaidTime.text),
            minWorkTime: int.parse(rateMinWorkingTime.text),
          )
          .nocodeErrorHandler();
      return res.success;
    } catch (e) {
      logger(e);
      return false;
    }
  }

  //Save all
  void onSave() async {
    shiftDetailsFormKey.currentState!.reset();
    timingFormKey.currentState!.reset();
    // ratesFormKey.currentState!.reset();
    if (!shiftDetailsFormKey.currentState!.validate()) return;
    if (!timingFormKey.currentState!.validate()) return;
    if (!ratesFormKey.currentState!.validate()) return;
    showLoading();
    final bool neShift = await createProperty();
    if (neShift) {
      await appStore.dispatch(GetPropertiesAction());
    }
    int createdCustomRates = 0;
    for (CustomRate rate in customRates) {
      if (!rate.formKey.currentState!.validate()) return;
      logger("Custom Rate${rate.name?.text} Validated");
      if (rate.id == 0) {
        bool created = await updateShiftSpecialRate(rate);
        if (created) {
          createdCustomRates++;
        }
      } else {
        if (rate.isEdited) {
          bool deleted = await deleteShiftSpecialRates(rate.id!);
          if (deleted) {
            bool created = await updateShiftSpecialRate(rate);
            if (created) {
              createdCustomRates++;
            }
          }
        }
      }
    }
    if (createdCustomRates > 0) {
      await fetchShiftSpecialRates();
    }
    await closeLoading();
    if (neShift) {
      showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("Shift has been saved"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                  Get.back();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void onInit() async {
    super.onInit();

    if (!isNew) {
      //Shifts
      shiftNameController.text = property!.title ?? "";
      shiftStatus = property!.active ?? false;
      shiftChecklistOn = property!.checklist ?? false;
      shiftLocation.name = property!.locationName;
      shiftLocation.code = property!.locationId;
      shiftClient.name = property!.clientName;
      shiftClient.code = property!.clientId;
      shiftWarehouse.name = property!.warehouseName;
      shiftWarehouse.code = property!.warehouseId;
      shiftChecklistTemplate.name = property!.checklistTemplateName;
      shiftChecklistTemplate.code = property!.checklistTemplateId;

      // final Map<int, bool> days = <int, bool>{};
      // if (property!.days != null) {
      //   if (property!.days is List) {
      //     List<int> list = [...(property!.days as List<dynamic>)];
      //     if (list.isNotEmpty) {
      //       if (list.length == 1) {
      //         days[7] = true;
      //       } else if (list.length == 7) {
      //         for (int i = 1; i < 8; i++) {
      //           days[i] = true;
      //         }
      //       } else {
      //         days[1] = true;
      //         days[7] = true;
      //       }
      //     }
      //   } else if (property!.days is Map) {
      //     for (MapEntry<String, dynamic> day in property!.days.entries) {
      //       if (int.parse(day.key) == 0) {
      //         days[7] = true;
      //       } else if (int.parse(day.key) == 1) {
      //         days[1] = true;
      //       } else {
      //         days[int.parse(day.key)] = true;
      //       }
      //     }
      //   }
      // }
      // for(MapEntry<int, bool> day in days.entries) {
      //     shiftDays[day.key] = day.value;
      // }
      //Timings
      timingStartTime.text = property!.startTime ?? "";
      timingEndTime.text = property!.finishTime ?? "";
      timingStartBreakTime.text = property!.startBreak ?? "";
      timingEndBreakTime.text = property!.finishBreak ?? "";
      timingMobileStartTime.text = property!.fpStartTime ?? "";
      timingMobileEndTime.text = property!.fpFinishTime ?? "";
      timingMobileStartBreakTime.text = property!.fpStartBreak ?? "";
      timingMobileEndBreakTime.text = property!.fpFinishBreak ?? "";
      timingStrictBreakTime.value = property!.strictBreak ?? false;

      //Rates
      rateMinWorkingTime.text = property!.minWorkTime?.toString() ?? "";
      ratePaidTime.text = property!.minPaidTime?.toString() ?? "";
      rateSplitTime.value = property!.splitTime ?? false;
      await fetchShiftSpecialRates();
    }
    update(['newProp']);
  }
}

class CustomRate {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController? name;
  TextEditingController? rate;
  TextEditingController? minTime;
  TextEditingController? paidTime;
  bool splitTime;
  int? id;
  @override
  String toString() {
    return 'CustomRate{name: ${name?.text}, rate: ${rate?.text}, minTime: ${minTime?.text}, paidTime: ${paidTime?.text}, splitTime: $splitTime}, id: $id';
  }

  bool isEdited = false;

  CustomRate({
    this.name,
    this.id,
    this.rate,
    this.minTime,
    this.paidTime,
    this.splitTime = false,
  }) {
    name ??= TextEditingController();
    rate ??= TextEditingController();
    minTime ??= TextEditingController();
    paidTime ??= TextEditingController();
    id ??= 0;

    name?.addListener(() {
      isEdited = true;
    });
    rate?.addListener(() {
      isEdited = true;
    });
    minTime?.addListener(() {
      isEdited = true;
    });
    paidTime?.addListener(() {
      isEdited = true;
    });
  }
}
