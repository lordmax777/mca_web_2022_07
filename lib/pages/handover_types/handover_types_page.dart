import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/models/list_all_md.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';
import 'controllers/handover_controller.dart';

class HandoverTypesPage extends StatelessWidget {
  const HandoverTypesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          const PagesTitleWidget(
            title: 'Handover Types',
          ),
          ErrorWrapper(
              errors: [state.generalState.paramList.error],
              child: const _Body())
        ]),
      ),
    );
  }
}

class _Body extends GetView<HandoverTypesController> {
  const _Body({super.key});

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
              _header(context),
              _body(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextInputWidget(
              controller: controller.searchController,
              defaultBorderColor: ThemeColors.gray11,
              width: 360,
              leftIcon: HeroIcons.search),
          SpacedRow(horizontalSpace: 16.0, children: [
            AnimatedOpacity(
              opacity: controller.deleteBtnOpacity,
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
              text: "New Handover",
              icon: const HeroIcon(
                HeroIcons.plusCircle,
                size: 20,
              ),
              onPressed: () {
                showOverlayPopup(
                    body: const HandsNewHandoverPopupWidget(),
                    context: context);
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    if (controller.departments.isEmpty) {
      return Center(
          child: KText(
        text: "No Handovers Yet",
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

  PlutoRow _buildItem(ListHandoverType e) {
    return PlutoRow(cells: {
      "handover_name": PlutoCell(value: e.title),
      "space": PlutoCell(value: ""),
      "status": PlutoCell(value: e.active ? "active" : "inactive"),
      "action": PlutoCell(value: e),
    });
  }
}
