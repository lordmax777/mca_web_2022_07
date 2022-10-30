import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/groups_list_controller.dart';
import '../../comps/custom_get_builder.dart';
import '../../manager/redux/middlewares/users_middleware.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../manager/rest/rest_client.dart';
import '../../theme/theme.dart';

class GroupsNewDepController extends GetxController {
  final ListJobTitle? group;
  GroupsNewDepController({this.group});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController depNameController = TextEditingController();
  final RxString _status = "".obs;
  String? get status => _status.value.isEmpty ? null : _status.value;
  bool get isActive => _status.toLowerCase() == "active";

  void setStatus(String? value) => _status.value = value ?? "";

  Future<void> postDepartment() async {
    if (formKey.currentState!.validate()) {
      showLoading();
      final ApiResponse res = await restClient()
          .postJobTitle(
            id: group?.id,
            title: depNameController.text,
            active: isActive,
          )
          .nocodeErrorHandler();

      if (res.success) {
        final GroupsController groupsController = Get.find();
        groupsController.gridStateManager.toggleAllRowChecked(false);
        groupsController.setDeleteBtnOpacity = 0.5;
        await appStore.dispatch(GetAllParamListAction());
      } else {}
      closeLoading();
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (group != null) {
      depNameController.text = group!.name;
      setStatus(group!.active ? "Active" : "Inactive");
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    depNameController.dispose();

    super.dispose();
  }
}

class GroupsNewDepPopupWidget extends GetView<GroupsNewDepController> {
  final ListJobTitle? group;
  const GroupsNewDepPopupWidget({super.key, this.group});

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;
    Get.lazyPut(() => GroupsNewDepController(group: group));

    return GBuilder<GroupsNewDepController>(
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
            text: 'New Group',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          IconButton(
              onPressed: () {
                context.popRoute();
              },
              icon: const HeroIcon(HeroIcons.x,
                  color: ThemeColors.gray2, size: 20.0)),
        ],
      ),
    );
  }

  Widget _body(double dpWidth, GroupsNewDepController controller) {
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
            labelText: "Group Name",
            controller: controller.depNameController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Group name is required";
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
              log("val: $val");
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

  Widget _footer(BuildContext context, GroupsNewDepController controller) {
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
            text: isNew ? 'Add Group' : 'Update Group',
            onPressed: () {
              controller.postDepartment();
            },
          ),
        ],
      ),
    );
  }
}
