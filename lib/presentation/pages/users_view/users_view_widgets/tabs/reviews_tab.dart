import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';


class UserReviewsTab extends StatelessWidget {
  final ValueChanged<PlutoGridOnLoadedEvent> onLoaded;
  final List<PlutoRow> rows;
  final UserMd user;
  final void Function(UserReviewMd?) onEdit;
  final void Function(UserReviewMd?) onDelete;

  const UserReviewsTab(
      {super.key,
      required this.onLoaded,
      required this.onDelete,
      required this.onEdit,
      required this.rows,
      required this.user});

  @override
  Widget build(BuildContext context) {
    return DefaultTable(
      hasFooter: false,
      headerEnd: SpacedRow(
        horizontalSpace: 12,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => onDelete(null),
              child: const Text("Delete Selected")),
          ElevatedButton(
              onPressed: () => onEdit(null), child: const Text("New Review")),
        ],
      ),
      onLoaded: onLoaded,
      columns: [
        PlutoColumn(
            title: "Conducted By",
            field: "conducted_by",
            enableRowChecked: true,
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Conducted On",
          field: "date",
          type: PlutoColumnType.date(
              format: appStore.state.generalState.formatMd.formShort),
        ),
        PlutoColumn(
          title: "Title",
          field: "title",
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
            title: "Comment",
            field: "comment",
            enableSorting: false,
            type: PlutoColumnType.text(),
            renderer: (ctx) {
              return ctx.defaultTooltipWidget();
            }),
        PlutoColumn(
          width: 40,
          title: "Action",
          enableSorting: false,
          field: "action",
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
                onDelete: () => onDelete(rendererContext.cell.value),
                onEdit: () => onEdit(rendererContext.cell.value));
          },
        ),
      ],
      rows: rows,
    );
  }
}
