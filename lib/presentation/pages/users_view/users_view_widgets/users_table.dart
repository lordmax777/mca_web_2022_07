import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table_header.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table_pagination_footer.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UsersTable extends StatelessWidget {
  final List<PlutoColumn> columns;
  final void Function(PlutoGridOnLoadedEvent) onLoaded;
  final FocusNode? focusNode;
  final void Function(UserMd?, BuildContext, int?)? onSelected;
  final List<PlutoRow> rows;
  final Widget? headerEnd;
  const UsersTable(
      {super.key,
      required this.columns,
      required this.rows,
      required this.onSelected,
      required this.onLoaded,
      this.headerEnd,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns.map<PlutoColumn>((e) {
        e.enableAutoEditing = false;
        e.enableColumnDrag = false;
        e.enableContextMenu = false;
        e.enableDropToResize = false;
        e.enableRowDrag = false;
        e.enableEditingMode = false;
        return e;
      }).toList(),
      createFooter: (stateManager) {
        return DefaultTablePaginationFooter(stateManager: stateManager);
      },
      createHeader: (stateManager) {
        return DefaultTableHeader(
            headerEnd: headerEnd,
            stateManager: stateManager,
            focusNode: focusNode);
      },
      configuration: PlutoGridConfiguration(
          style: PlutoGridStyleConfig(
            activatedBorderColor: Theme.of(context).primaryColor,
            activatedColor: Colors.transparent,
            borderColor: Colors.grey[200]!,
            gridBorderColor: Colors.grey[300]!,
          ),
          columnSize: const PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.scale)),
      onLoaded: onLoaded,
      mode: PlutoGridMode.selectWithOneTap,
      noRowsWidget: Center(
        child:
            Text('No data', style: Theme.of(context).textTheme.headlineMedium),
      ),
      onSelected: (event) {
        final id = event.row?.cells['id']?.value;
        final user = appStore.state.generalState.users
            .firstWhereOrNull((element) => element.id == id);
        if (user == null) return;
        switch (event.cell?.column.field) {
          case "name":
          case "username":
            onSelected?.call(user, context, null);
            break;
          case "payroll":
            onSelected?.call(user, context, 1);
            break;
          case "reviews":
            onSelected?.call(user, context, 2);
            break;
          case "visa":
            onSelected?.call(user, context, 3);
            break;
          case "preferred_shifts":
            onSelected?.call(user, context, 4);
            break;
          case "qualifications":
            onSelected?.call(user, context, 5);
            break;
          default:
            break;
        }
      },
      rows: rows,
    );
  }
}
