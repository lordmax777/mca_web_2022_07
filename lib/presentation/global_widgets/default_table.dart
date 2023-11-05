import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';
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
  final Widget Function(PlutoGridStateManager)? customFooter;
  final void Function(int page, int pageSize)? fetch;
  final PlutoGridColumnFilterConfig? columnFilter;
  final Color Function(PlutoRowColorContext)? rowColorCallback;
  final Widget? headerStart;
  final List<PlutoColumnGroup>? columnsGroups;
  final PlutoAutoSizeMode autoSizeMode;

  const DefaultTable(
      {super.key,
      required this.onLoaded,
      required this.columns,
      required this.rows,
      this.onSelected,
      this.autoSizeMode = PlutoAutoSizeMode.scale,
      this.columnsGroups,
      this.rowColorCallback,
      this.columnFilter,
      this.customFooter,
      this.onChanged,
      this.mode = PlutoGridMode.selectWithOneTap,
      this.headerEnd,
      this.headerStart,
      this.fetch,
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
      columnGroups: columnsGroups,
      createFooter: hasFooter
          ? (stateManager) {
              if (customFooter != null) {
                return customFooter!(stateManager);
              }
              return DefaultTablePaginationFooter(
                stateManager: stateManager,
                fetch: fetch,
              );
            }
          : null,
      createHeader: hasHeader
          ? (stateManager) {
              return DefaultTableHeader(
                  stateManager: stateManager,
                  headerStart: headerStart,
                  focusNode: focusNode,
                  headerEnd: headerEnd);
            }
          : null,
      rowColorCallback: rowColorCallback ??
          (rowColorContext) {
            if (rowColorContext.row.type.isGroup) {
              return Colors.grey[50]!;
            }

            return Colors.white;
          },
      configuration: PlutoGridConfiguration(
        columnFilter: columnFilter ?? const PlutoGridColumnFilterConfig(),
        style: PlutoGridStyleConfig(
          cellColorGroupedRow: const Color(0x80D0D0D0),
          activatedBorderColor: context.colorScheme.primary,
          borderColor: Colors.grey[200]!,
          gridBorderColor: Colors.grey[300]!,
        ),
        columnSize: PlutoGridColumnSizeConfig(
          autoSizeMode: autoSizeMode,
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

enum TableRowStatus { idle, saved }
