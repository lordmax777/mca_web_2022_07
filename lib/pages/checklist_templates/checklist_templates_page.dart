import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';

import '../../manager/redux/states/general_state.dart';
import '../../theme/theme.dart';
import 'controllers/checklist_list_controller.dart';

class ChecklistTemplatesPage extends StatelessWidget {
  const ChecklistTemplatesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      onInit: (store) {
        store.dispatch(GetChecklistTemplatesAction());
      },
      builder: (_, state) => PageWrapper(
        child: SpacedColumn(verticalSpace: 16.0, children: [
          const PagesTitleWidget(
            title: 'Checklist Templates',
          ),
          ErrorWrapper(
              errors: [state.generalState.checklistTemplates.error],
              child: const _Body())
        ]),
      ),
    );
  }
}

class _Body extends GetView<ChecklistController> {
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
              _header(context),
              _body(controller.departments.isEmpty, context),
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
              hintText: "Search checklist...",
              controller: controller.searchController,
              defaultBorderColor: ThemeColors.gray11,
              width: 360,
              leftIcon: HeroIcons.search),
          ButtonMedium(
            text: "New Checklist",
            icon: const HeroIcon(
              HeroIcons.plusCircle,
              size: 20,
            ),
            onPressed: () {
              context.pushRoute(NewChecklistTemplateRoute());
              // showOverlayPopup(
              //     body: cons, context: context);
            },
          ),
        ],
      ),
    );
  }

  Widget _body(bool isEmpty, BuildContext context) {
    if (isEmpty) {
      return Center(
          child: KText(
        text: "No Checklist Yet",
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

  PlutoRow _buildItem(ChecklistTemplateMd e) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: e.name),
      "title": PlutoCell(value: e.title),
      "sections": PlutoCell(value: e.getRooms.length),
      "action": PlutoCell(value: e),
    });
  }
}
