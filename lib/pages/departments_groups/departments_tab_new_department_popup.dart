import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/rest/dio_client_for_retrofit.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/deps_list_controller.dart';

import '../../app.dart';
import '../../comps/custom_get_builder.dart';
import '../../manager/redux/middlewares/users_middleware.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/redux/states/users_state/users_state.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../manager/rest/rest_client.dart';
import '../../theme/theme.dart';

class DepsNewDepController extends GetxController {
  static DepsNewDepController get to {
    Get.lazyPut(() => DepsNewDepController());
    return Get.find();
  }

  final ListGroup? group;
  DepsNewDepController({this.group});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController depNameController = TextEditingController();
  final RxString _status = "".obs;
  String? get status => _status.value.isEmpty ? null : _status.value;
  bool get isActive => _status.toLowerCase() == "active";

  void setStatus(String? value) => _status.value = value ?? "";

  Future<ApiResponse?> postDepartment(
      {ListGroup? updateableItem, BuildContext? context}) async {
    if (updateableItem == null ? formKey.currentState!.validate() : true) {
      showLoading();
      final id = (updateableItem?.id) ?? group?.id;
      final name = (updateableItem?.name) ?? depNameController.text;
      final status = (updateableItem?.active) ?? isActive;
      final ApiResponse res = await restClient()
          .postGroup(
            id: id,
            name: name,
            active: status,
          )
          .nocodeErrorHandler();

      await closeLoading();
      if (res.success) {
        final DepartmentsController groupsController = Get.find();

        groupsController.gridStateManager.toggleAllRowChecked(false);

        context?.popRoute();

        await appStore.dispatch(GetAllParamListAction());
      } else {
        showError(res.data);
      }
      return res;
    }
    return null;
  }

  @override
  void onReady() {
    super.onReady();
    if (group != null) {
      depNameController.text = group!.name;
      setStatus(group!.active ? "Active" : "Inactive");
    }
  }

  @override
  void dispose() {
    depNameController.dispose();

    super.dispose();
  }
}

class DepartmentsNewDepPopupWidget extends GetView<DepsNewDepController> {
  final ListGroup? group;
  const DepartmentsNewDepPopupWidget({super.key, this.group});

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;
    Get.lazyPut(() => DepsNewDepController(group: group));

    return GBuilder<DepsNewDepController>(
      child: (controller) => TableWrapperWidget(
        child: Form(
          key: controller.formKey,
          child: SpacedColumn(children: [
            _header(context),
            const Divider(color: ThemeColors.gray11, height: 1.0),
            const SizedBox(),
            _body(dpWidth, controller),
            const Divider(color: ThemeColors.gray11, height: 1.0),
            _footer(context, controller),
          ]),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: 'New Department',
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

  Widget _body(double dpWidth, DepsNewDepController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(height: 1),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            labelText: "Department Name",
            controller: controller.depNameController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Department name is required";
              }
              return null;
            },
          ),
          DropdownWidget(
            hintText: "Status",
            value: controller.status,
            dropdownBtnWidth: dpWidth / 5,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 5,
            onChanged: (val) {
              controller.setStatus(val);
            },
            items: [
              "Active",
              "Inactive",
            ],
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context, DepsNewDepController controller) {
    final bool isNew = group == null;

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
            onPressed: () {
              context.popRoute();
            },
          ),
          ButtonLarge(
            paddingWithoutIcon: true,
            icon: const HeroIcon(HeroIcons.check, size: 20.0),
            text: isNew ? 'Add Department' : 'Update Department',
            onPressed: () {
              controller.postDepartment(context: context);
            },
          ),
        ],
      ),
    );
  }
}
