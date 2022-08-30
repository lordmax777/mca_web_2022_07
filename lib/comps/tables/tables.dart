import 'package:pluto_grid/pluto_grid.dart';
import '../../theme/theme.dart';

class UsersListTable extends StatelessWidget {
  final List<PlutoColumn> cols;
  final List<PlutoRow> rows;
  final void Function(PlutoGridStateManager) onSmReady;
  const UsersListTable(
      {Key? key,
      required this.rows,
      required this.onSmReady,
      required this.cols})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> _cols = [];
    for (PlutoColumn col in cols) {
      col.enableContextMenu = false;
      col.backgroundColor = ThemeColors.gray12;
      col.enableDropToResize = false;
      col.enableColumnDrag = false;
      col.enableAutoEditing = false;
      col.enableEditingMode = false;
      col.renderer ??= (ctx) {
        return KText(
          text: ctx.cell.value,
          textColor: ThemeColors.gray2,
          fontWeight: FWeight.regular,
          fontSize: 14,
          isSelectable: false,
        );
      };
      _cols.add(col);
    }
    var _w = MediaQuery.of(context).size.width;
    var _tableSize = 0.0;
    for (var c in cols) {
      _tableSize += c.width;
    }
    bool isEqual = _tableSize == _w;

    double _h = 625;

    return SizedBox(
      height: _h,
      child: PlutoGrid(
        configuration: PlutoGridConfiguration(
            style: const PlutoGridStyleConfig(
              columnHeight: 48.0,
              rowHeight: 48.0,
              borderColor: ThemeColors.transparent,
              gridBorderColor: ThemeColors.transparent,
              activatedBorderColor: ThemeColors.transparent,
              activatedColor: ThemeColors.blue12,
              columnTextStyle: ThemeText.tableColumnTextStyle,
              enableRowColorAnimation: true,
            ),
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: isEqual
                    ? PlutoAutoSizeMode.none
                    : PlutoAutoSizeMode.scale)),
        columns: _cols,
        rows: rows,
        onLoaded: (e) => onSmReady(e.stateManager),
      ),
    );
  }
}

class UserDetailPayrollTabTable extends StatelessWidget {
  final List<PlutoColumn> cols;
  final List<PlutoRow> rows;
  final void Function(PlutoGridStateManager) onSmReady;
  final bool dynamicHeight;
  const UserDetailPayrollTabTable(
      {Key? key,
      required this.rows,
      this.dynamicHeight = false,
      required this.onSmReady,
      required this.cols})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> _cols = [];
    for (PlutoColumn col in cols) {
      col.enableContextMenu = false;
      col.backgroundColor = ThemeColors.gray12;
      col.enableDropToResize = false;
      col.enableColumnDrag = false;
      col.enableAutoEditing = false;
      col.enableEditingMode = false;
      col.renderer ??= (ctx) {
        return KText(
          text: ctx.cell.value,
          textColor: ThemeColors.gray2,
          fontWeight: FWeight.regular,
          fontSize: 14,
          isSelectable: false,
        );
      };
      _cols.add(col);
    }
    var _w = MediaQuery.of(context).size.width;
    var _tableSize = 0.0;
    for (var c in cols) {
      _tableSize += c.width;
    }
    bool isEqual = _tableSize == _w;

    double _h = 625;
    if (dynamicHeight) {
      _h = (rows.length * 48.0) + 80.0;
    }
    return SizedBox(
      height: _h,
      child: PlutoGrid(
        configuration: PlutoGridConfiguration(
            style: const PlutoGridStyleConfig(
                columnHeight: 48.0,
                rowHeight: 48.0,
                borderColor: ThemeColors.transparent,
                gridBorderColor: ThemeColors.transparent,
                activatedBorderColor: ThemeColors.transparent,
                activatedColor: ThemeColors.blue12,
                columnTextStyle: ThemeText.tableColumnTextStyle,
                enableRowColorAnimation: true),
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: isEqual
                    ? PlutoAutoSizeMode.none
                    : PlutoAutoSizeMode.scale)),
        columns: _cols,
        rows: rows,
        onLoaded: (e) => onSmReady(e.stateManager),
      ),
    );
  }
}
