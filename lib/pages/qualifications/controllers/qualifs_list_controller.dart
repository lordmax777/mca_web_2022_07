// ignore_for_file: invalid_use_of_protected_member

import 'package:get/get.dart';
import '../../../comps/show_overlay_popup.dart';
import '../../../manager/model_exporter.dart';
import '../../../theme/theme.dart';

class QualifsController extends GetxController {
  List<PlutoColumn> columns(BuildContext context) {
    return [
      PlutoColumn(
        title: "Qualification Name",
        field: "qualification_name",
        width: PlutoGridSettings.columnWidth + 500,
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Expire",
        field: "expire",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: "Levels",
        field: "levels",
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
          title: "Comment",
          field: "comment",
          enableSorting: false,
          type: PlutoColumnType.text(),
          renderer: (ctx) {
            return TableTooltipWidget(
                title: "Read Comment", message: ctx.cell.value.toString());
          }),
      PlutoColumn(
        title: "Action",
        field: "action",
        enableSorting: false,
        type: PlutoColumnType.text(),
        renderer: (rendererContext) => GridTableHelpers.getActionRenderer(
          rendererContext,
          onTap: (PlutoColumnRendererContext ctx) => _onEditClick(context, ctx),
        ),
      ),
    ];
  }

  //Departments
  final RxList<ListQualification> _deps = <ListQualification>[].obs;
  List<ListQualification> get departments => _deps;
  setList(List<ListQualification> d) {
    final dd = [...d];
    dd.sort((a, b) => a.title.compareTo(b.title));
    _deps.value = dd;
    return _deps;
  }

  final TextEditingController searchController = TextEditingController();
  late PlutoGridStateManager gridStateManager;

  void setSm(PlutoGridStateManager sm) {
    gridStateManager = sm;
    _setFilter();
  }

  void _setFilter() {
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        gridStateManager.setFilter(
          (element) {
            bool searched = element.cells['qualification_name']?.value
                .toLowerCase()
                .contains(searchController.text.toLowerCase());
            if (!searched) {
              searched = element.cells['expire']?.value
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase());
              if (!searched) {
                searched = element.cells['levels']?.value
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase());
              }
            }
            return searched;
          },
        );
        return;
      }
      gridStateManager.setFilter((element) => true);
    });
  }

  void _onEditClick(BuildContext context, PlutoColumnRendererContext ctx) {
    showOverlayPopup(
        body: QualifsNewQualifPopupWidget(qualif: ctx.cell.value),
        context: context);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
