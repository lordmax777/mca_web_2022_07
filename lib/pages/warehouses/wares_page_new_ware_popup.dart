import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/comps/custom_get_builder.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/warehouses/controllers/warehouse_controller.dart';

import '../../comps/dropdown_widget1.dart';
import '../../manager/redux/middlewares/users_middleware.dart';
import '../../manager/redux/sets/state_value.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../manager/rest/rest_client.dart';
import '../../theme/theme.dart';
import 'package:get/get.dart';

class WaresNewWareController extends GetxController {
  final WarehouseMd? qualif;
  WaresNewWareController({this.qualif});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController name2Controller = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final RxBool _sendReport = false.obs;
  final Rx<CodeMap<bool>> _status = CodeMap<bool>(name: null, code: null).obs;
  CodeMap<bool> get status => _status.value;
  set setStatus(CodeMap<bool> value) => _status.value = value;

  bool get sendReport => _sendReport.value;

  void setSendReport(bool? val) => _sendReport.value = val!;

  Future<void> create({BuildContext? context}) async {
    if (formKey.currentState!.validate()) {
      showLoading();
      final ApiResponse res = await restClient()
          .postWarehouse(
            id: qualif?.id ?? 0,
            contactName: name2Controller.text,
            contactEmail:
                emailController.text.isEmpty ? null : emailController.text,
            name: nameController.text,
            sendReport: sendReport,
            active: status.code ?? false,
          )
          .nocodeErrorHandler();

      if (res.success) {
        final WarehouseController controller = Get.find();
        controller.gridStateManager.toggleAllRowChecked(false);
        await appStore.dispatch(GetWarehousesAction());
        await closeLoading();
        context?.popRoute();
      } else {
        await closeLoading();
        String errorMessage = "";
        jsonDecode(res.data)['errors'].entries.forEach((e) {
          errorMessage += "${e.value.first}\n";
        });

        showError(errorMessage);
      }
    }
  }

  void onStatusChange(DpItem value) {
    _status.value = CodeMap(name: value.name, code: value.item.key);
  }

  @override
  void onInit() {
    super.onInit();
    if (qualif != null) {
      nameController.text = qualif!.name;
      name2Controller.text = qualif!.contactName ?? "";
      emailController.text = qualif!.contactEmail ?? "";
      setSendReport(qualif!.sendReport);
      setStatus = CodeMap(
          name: qualif!.active ? "Active" : "Inactive", code: qualif!.active);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    name2Controller.dispose();
    emailController.dispose();
    setSendReport(false);
    super.dispose();
  }
}

class WaresNewWarePopupWidget extends StatelessWidget {
  final WarehouseMd? qualif;
  const WaresNewWarePopupWidget({Key? key, this.qualif}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    logger(qualif?.toJson());
    Get.lazyPut(() => WaresNewWareController(qualif: qualif));

    final dpWidth = MediaQuery.of(context).size.width;

    return GBuilder<WaresNewWareController>(
      child: (controller) => TableWrapperWidget(
          child: Form(
        key: controller.formKey,
        child: SpacedColumn(children: [
          _header(context, controller),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          const SizedBox(),
          _body(dpWidth, controller),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          _footer(controller, context),
        ]),
      )),
    );
  }

  Widget _header(BuildContext context, WaresNewWareController controller) {
    bool isNew = qualif == null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: isNew ? 'New Warehouse' : 'Edit Warehouse',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          IconButton(
              onPressed: context.popRoute,
              icon: const HeroIcon(HeroIcons.x,
                  color: ThemeColors.gray2, size: 20.0)),
        ],
      ),
    );
  }

  Widget _body(double dpWidth, WaresNewWareController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 24.0,
        children: [
          const SizedBox(height: 1),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            labelText: "Warehouse Name",
            controller: controller.nameController,
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            labelText: "Contact Name",
            controller: controller.name2Controller,
          ),
          TextInputWidget(
            isRequired: controller.sendReport,
            width: dpWidth / 5,
            labelText: "Contact Email",
            controller: controller.emailController,
            customValidator: (p0) {
              if (p0 != null && p0.isNotEmpty) {
                if (!GetUtils.isEmail(p0)) {
                  return 'Please enter a valid email';
                }
              }
              return null;
            },
            validator: (p0) {
              if (controller.sendReport) {
                if (p0 == null || p0.isEmpty) {
                  return 'Please enter a contact email';
                }
                if (!GetUtils.isEmail(p0)) {
                  return 'Please enter a valid email';
                }
              }
              return null;
            },
          ),
          DropdownWidget1<MapEntry<bool, String>>(
            hintText: "Status",
            dropdownBtnWidth: dpWidth / 5,
            isRequired: true,
            value: controller.status.name,
            dropdownOptionsWidth: dpWidth / 5,
            objItems: Constants.userAccountStatusTypes.entries.toList(),
            onChangedWithObj: controller.onStatusChange,
            items: Constants.userAccountStatusTypes.entries
                .map((e) => e.value)
                .toList(),
          ),
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              CheckboxWidget(
                  value: controller.sendReport,
                  onChanged: controller.setSendReport),
              KText(
                text: "Send Report",
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                isSelectable: false,
                fontWeight: FWeight.bold,
              )
            ],
          ),
          const SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _footer(WaresNewWareController controller, BuildContext context) {
    bool isNew = qualif == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.end,
        horizontalSpace: 16.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonLargeSecondary(
            text: 'Cancel',
            paddingWithoutIcon: true,
            onPressed: context.popRoute,
          ),
          ButtonLarge(
            paddingWithoutIcon: true,
            icon: const HeroIcon(HeroIcons.check,
                color: ThemeColors.white, size: 20.0),
            text: isNew ? 'Add Warehouse' : ' Save Changes',
            onPressed: () => controller.create(context: context),
          ),
        ],
      ),
    );
  }
}
