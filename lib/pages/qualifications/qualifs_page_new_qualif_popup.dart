import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/pages/qualifications/controllers/qualifs_list_controller.dart';

import '../../comps/custom_get_builder.dart';
import '../../manager/redux/middlewares/users_middleware.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../manager/rest/rest_client.dart';
import '../../theme/theme.dart';

class QualifNewQualifController extends GetxController {
  final ListQualification? qualif;
  QualifNewQualifController({this.qualif});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final RxBool _hasLevels = false.obs;
  final RxBool _hasExpire = false.obs;

  bool get hasLevels => _hasLevels.value;
  bool get hasExpire => _hasExpire.value;

  void setLevels(bool? val) => _hasLevels.value = val!;
  void setExpire(bool? val) => _hasExpire.value = val!;

  Future<void> create() async {
    if (formKey.currentState!.validate()) {
      showLoading();
      final ApiResponse res = await restClient()
          .postQualif(
            id: qualif?.id,
            title: nameController.text,
            active: true,
            expire: hasExpire,
            levels: hasLevels,
            comments:
                notesController.text.isEmpty ? null : notesController.text,
          )
          .nocodeErrorHandler();

      if (res.success) {
        final QualifsController controller = Get.find();

        controller.gridStateManager.toggleAllRowChecked(false);
        controller.setDeleteBtnOpacity = 0.5;
        await appStore.dispatch(GetAllParamListAction());
      } else {}
      closeLoading();
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (qualif != null) {
      nameController.text = qualif!.title;
      notesController.text = qualif!.comments;
      setLevels(qualif!.levels);
      setExpire(qualif!.expire);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    notesController.dispose();
    super.dispose();
  }
}

class QualifsNewQualifPopupWidget extends StatelessWidget {
  final ListQualification? qualif;
  const QualifsNewQualifPopupWidget({super.key, this.qualif});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => QualifNewQualifController(qualif: qualif));
    final dpWidth = MediaQuery.of(context).size.width;
    return GBuilder<QualifNewQualifController>(
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
      )),
    );
  }

  Widget _header(BuildContext context) {
    bool isNew = qualif == null;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: isNew ? 'New Qualification' : 'Edit Qualification',
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

  Widget _body(double dpWidth, QualifNewQualifController controller) {
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
            labelText: "Qualification Name",
            controller: controller.nameController,
            onTap: () {},
          ),
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              CheckboxWidget(
                value: controller.hasExpire,
                onChanged: controller.setExpire,
              ),
              KText(
                text: "Qualification has expiry date",
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                isSelectable: false,
                fontWeight: FWeight.bold,
              )
            ],
          ),
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              CheckboxWidget(
                  value: controller.hasLevels, onChanged: controller.setLevels),
              KText(
                text: "Qualification has levels",
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                isSelectable: false,
                fontWeight: FWeight.bold,
              )
            ],
          ),
          TextInputWidget(
            width: dpWidth / 5,
            labelText: "Comment",
            controller: controller.notesController,
            maxLines: 4,
          ),
          const SizedBox(),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context, QualifNewQualifController controller) {
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
            text: isNew ? 'Add Qualification' : 'Update Qualification',
            onPressed: controller.create,
          ),
        ],
      ),
    );
  }
}
