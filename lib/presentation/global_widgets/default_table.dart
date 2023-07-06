import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DefaultTable extends StatelessWidget {
  final List<PlutoColumn> columns;
  final void Function(PlutoGridOnLoadedEvent) onLoaded;
  final FocusNode? focusNode;
  final void Function(PlutoGridOnSelectedEvent)? onSelected;
  final List<PlutoRow> rows;
  final bool hasFooter;
  final bool hasHeader;
  final Widget? headerEnd;
  final PlutoGridMode mode;
  final void Function(PlutoGridOnChangedEvent)? onChanged;
  const DefaultTable(
      {super.key,
      required this.onLoaded,
      required this.columns,
      required this.rows,
      this.onSelected,
      this.onChanged,
      this.mode = PlutoGridMode.selectWithOneTap,
      this.headerEnd,
      this.hasFooter = true,
      this.hasHeader = true,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return PlutoGrid(
      columns: columns.map<PlutoColumn>((e) {
        if (mode == PlutoGridMode.selectWithOneTap) {
          e.enableEditingMode = false;
          e.enableAutoEditing = false;
        }
        e.enableColumnDrag = false;
        e.enableContextMenu = false;
        e.enableDropToResize = false;
        e.enableRowDrag = false;
        // e.textAlign = PlutoColumnTextAlign.center;
        // e.titleTextAlign = PlutoColumnTextAlign.center;
        return e;
      }).toList(),
      createFooter: hasFooter
          ? (stateManager) {
              return DefaultTablePaginationFooter(stateManager: stateManager);
            }
          : null,
      createHeader: hasHeader
          ? (stateManager) {
              return DefaultTableHeader(
                  stateManager: stateManager,
                  focusNode: focusNode,
                  headerEnd: headerEnd);
            }
          : null,
      rowColorCallback: (rowColorContext) {
        if (rowColorContext.row.type.isGroup) {
          return Colors.grey[50]!;
        }
        return Colors.white;
      },
      configuration: PlutoGridConfiguration(
        style: PlutoGridStyleConfig(
          cellColorGroupedRow: const Color(0x80D0D0D0),
          activatedBorderColor: Theme.of(context).primaryColor,
          borderColor: Colors.grey[200]!,
          gridBorderColor: Colors.grey[300]!,
        ),
        columnSize: const PlutoGridColumnSizeConfig(
          autoSizeMode: PlutoAutoSizeMode.scale,
        ),
      ),
      onLoaded: (event) {
        if (!hasFooter) {
          event.stateManager.setPageSize(500);
        }
        onLoaded(event);
      },
      mode: mode,
      onSelected: onSelected,
      rows: rows,
      noRowsWidget: Center(
        child:
            Text('No data', style: Theme.of(context).textTheme.headlineMedium),
      ),
      onChanged: onChanged,
    );
  }
}
