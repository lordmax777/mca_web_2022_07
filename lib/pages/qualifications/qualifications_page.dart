import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../theme/theme.dart';
import 'controllers/qualifs_list_controller.dart';

class QualificationsPage extends StatelessWidget {
  const QualificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          const PagesTitleWidget(
            title: 'Qualifications',
          ),
          ErrorWrapper(
              errors: [state.generalState.paramList.error],
              child: const _Body())
        ]),
      ),
    );
  }
}

class _Body extends GetView<QualifsController> {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => TableWrapperWidget(
        child: SizedBox(
          width: double.infinity,
          child: SpacedColumn(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context, controller.deleteBtnOpacity),
              _body(controller.departments.isEmpty, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context, double opacity) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInputWidget(
              hintText: "Search qualifications...",
              controller: controller.searchController,
              defaultBorderColor: ThemeColors.gray11,
              width: 360,
              leftIcon: HeroIcons.search),
          SpacedRow(horizontalSpace: 16.0, children: [
            AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 100),
              child: ButtonMedium(
                bgColor: ThemeColors.red3,
                text: "Delete Selected",
                icon: const HeroIcon(
                  HeroIcons.bin,
                  size: 20,
                ),
                onPressed: controller.deleteSelectedRows,
              ),
            ),
            ButtonMedium(
              text: "New Qualification",
              icon: const HeroIcon(
                HeroIcons.plusCircle,
                size: 20,
              ),
              onPressed: () {
                showOverlayPopup(
                    body: const QualifsNewQualifPopupWidget(),
                    context: context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body(bool isEmpty, BuildContext context) {
    if (isEmpty) {
      return Center(
          child: KText(
        text: "No Qualifications Yet",
        fontSize: 24.0,
        mainAxisSize: MainAxisSize.min,
        isSelectable: false,
        textAlign: TextAlign.center,
        textColor: ThemeColors.gray2,
      ));
    }
    return DepsListTable(
      onSmReady: controller.setSm,
      rows: controller.departments.reactive.value
              ?.map<PlutoRow>(_buildItem)
              .toList() ??
          [],
      cols: controller.columns(context),
    );
  }

  PlutoRow _buildItem(ListQualification e) {
    return PlutoRow(cells: {
      "qualification_name": PlutoCell(value: e.title),
      "space": PlutoCell(value: ""),
      "expire": PlutoCell(value: e.expire ? "Yes" : "No"),
      "levels": PlutoCell(value: e.levels ? "Yes" : "No"),
      "comment": PlutoCell(value: e.comments),
      "action": PlutoCell(value: e),
    });
  }
}
