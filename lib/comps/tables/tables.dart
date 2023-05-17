import 'dart:developer';

import 'package:flutter/gestures.dart';

import '../../theme/theme.dart';
import 'package:pluto_grid/pluto_grid.dart';

class UsersListTable extends StatelessWidget {
  final List<PlutoColumn> cols;
  final List<PlutoRow> rows;
  final void Function(PlutoGridStateManager) onSmReady;
  final void Function(PlutoGridOnSelectedEvent)? onOneTapSelect;
  final Color? gridBorderColor;
  final bool enableEditing;
  final PlutoGridMode mode;
  final void Function(PlutoGridOnChangedEvent)? onChanged;
  final String? noRowsText;
  final PlutoGridColumnFilterConfig? columnFilter;
  final double? height;

  final void Function(PlutoGridOnRowCheckedEvent)? onRowChecked;

  const UsersListTable(
      {Key? key,
      required this.rows,
      this.onOneTapSelect,
      this.onRowChecked,
      this.height,
      this.columnFilter,
      this.onChanged,
      this.mode = PlutoGridMode.selectWithOneTap,
      this.enableEditing = false,
      this.gridBorderColor,
      required this.onSmReady,
      this.noRowsText,
      required this.cols})
      : super(key: key);

  static Widget defaultTextWidget(dynamic text, {TextAlign? textAlign}) {
    return KText(
      text: text.toString().contains("null") ? "-" : text.toString(),
      textColor: ThemeColors.gray2,
      fontWeight: FWeight.regular,
      fontSize: 14,
      textAlign: textAlign ?? TextAlign.start,
      isSelectable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> _cols = [];
    for (PlutoColumn col in cols) {
      col.enableContextMenu = false;
      col.backgroundColor = ThemeColors.gray12;
      col.enableDropToResize = false;
      col.enableColumnDrag = false;
      if (!enableEditing) {
        col.enableAutoEditing = false;
        col.enableEditingMode = false;
      } else {
        if (col.enableEditingMode == true) {
          col.cellPadding = const EdgeInsets.symmetric(horizontal: 8);
          col.renderer = (ctx) {
            return MouseRegion(
              cursor: SystemMouseCursors.text,
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: ThemeColors.gray12,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: ThemeColors.gray9,
                    width: 1,
                  ),
                ),
                child: defaultTextWidget(ctx.cell.value.toString()),
              ),
            );
          };
        }
      }
      col.renderer ??= (ctx) {
        return KText(
          text: ctx.cell.value,
          textColor: ThemeColors.gray2,
          fontWeight: FWeight.regular,
          fontSize: 14,
          isSelectable: false,
          textAlign: col.textAlign.value,
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
      height: height ?? _h,
      child: PlutoGrid(
        configuration: PlutoGridConfiguration(
            columnFilter: columnFilter ?? const PlutoGridColumnFilterConfig(),
            style: PlutoGridStyleConfig(
              columnHeight: 48.0,
              rowHeight: 48.0,
              borderColor: gridBorderColor ?? ThemeColors.transparent,
              gridBorderColor: gridBorderColor ?? ThemeColors.transparent,
              activatedBorderColor: gridBorderColor ?? ThemeColors.transparent,
              activatedColor: ThemeColors.blue12.withOpacity(0.5),
              columnTextStyle: ThemeText.tableColumnTextStyle,
              enableRowColorAnimation: true,
            ),
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: isEqual
                    ? PlutoAutoSizeMode.none
                    : PlutoAutoSizeMode.scale)),
        columns: _cols,
        rows: rows,
        onRowChecked: onRowChecked,
        mode: mode,
        onSelected: onOneTapSelect,
        onChanged: onChanged,
        onLoaded: (e) => onSmReady(e.stateManager),
        noRowsWidget: Center(
          child: Text(
            noRowsText ?? "No data found",
            style: ThemeText.lg,
          ),
        ),
      ),
    );
  }
}

class DepsListTable extends StatelessWidget {
  final List<PlutoColumn> cols;
  final List<PlutoRow> rows;
  final void Function(PlutoGridStateManager) onSmReady;
  final void Function(PlutoGridOnSelectedEvent)? onOneTapSelect;

  const DepsListTable(
      {Key? key,
      required this.rows,
      required this.onSmReady,
      this.onOneTapSelect,
      required this.cols})
      : super(key: key);

  static Widget defaultTextWidget(String text) {
    return KText(
      text: text.contains("null") ? "-" : text,
      textColor: ThemeColors.gray2,
      fontWeight: FWeight.regular,
      fontSize: 14,
      isSelectable: false,
    );
  }

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
          text: ctx.cell.value.toString(),
          textColor: ThemeColors.gray2,
          fontWeight: FWeight.regular,
          fontSize: 14,
          isSelectable: false,
        );
      };
      _cols.add(col);
    }
    //Calculate table height based on rows count
    double _h = rows.length * 30.0 + 48.0;

    return SizedBox(
      height: _h,
      child: PlutoGrid(
        configuration: PlutoGridConfiguration(
            style: PlutoGridStyleConfig(
              columnHeight: 48.0,
              rowHeight: 48.0,
              borderColor: ThemeColors.transparent,
              gridBorderColor: ThemeColors.transparent,
              activatedBorderColor: ThemeColors.transparent,
              activatedColor: ThemeColors.blue12.withOpacity(0.5),
              columnTextStyle: ThemeText.tableColumnTextStyle,
              enableRowColorAnimation: true,
            ),
            columnSize: const PlutoGridColumnSizeConfig(
                autoSizeMode: PlutoAutoSizeMode.scale)),
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
  final void Function(PlutoGridOnRowCheckedEvent)? onSelected;

  const UserDetailPayrollTabTable(
      {Key? key,
      required this.rows,
      this.onSelected,
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
        onRowChecked: (event) {
          onSelected?.call(event);
        },
        configuration: PlutoGridConfiguration(
            style: PlutoGridStyleConfig(
                columnHeight: 48.0,
                rowHeight: 48.0,
                borderColor: ThemeColors.transparent,
                gridBorderColor: ThemeColors.transparent,
                activatedBorderColor: ThemeColors.transparent,
                activatedColor: ThemeColors.blue12.withOpacity(0.5),
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

class StockItemsListTable extends StatelessWidget {
  final List<PlutoColumn> cols;
  final List<PlutoRow> rows;
  final void Function(PlutoGridStateManager) onSmReady;
  final void Function(PlutoGridOnChangedEvent)? onChanged;

  const StockItemsListTable(
      {Key? key,
      required this.rows,
      required this.onSmReady,
      this.onChanged,
      required this.cols})
      : super(key: key);

  static Widget defaultTextWidget(String text) {
    return KText(
      text: text.contains("null") ? "-" : text,
      textColor: ThemeColors.gray2,
      fontWeight: FWeight.regular,
      fontSize: 14,
      isSelectable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> _cols = [];
    for (PlutoColumn col in cols) {
      col.enableContextMenu = false;
      col.backgroundColor = ThemeColors.gray12;
      col.enableDropToResize = false;
      col.enableColumnDrag = false;
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
            style: PlutoGridStyleConfig(
              columnHeight: 48.0,
              rowHeight: 48.0,
              borderColor: ThemeColors.gray11,
              gridBorderColor: ThemeColors.gray11,
              activatedBorderColor: ThemeColors.transparent,
              activatedColor: ThemeColors.blue12.withOpacity(0.5),
              columnTextStyle: ThemeText.tableColumnTextStyle,
              enableRowColorAnimation: true,
            ),
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: isEqual
                    ? PlutoAutoSizeMode.none
                    : PlutoAutoSizeMode.scale)),
        columns: _cols,
        rows: rows,
        onChanged: onChanged,
        onLoaded: (e) => onSmReady(e.stateManager),
      ),
    );
  }
}

class ApprovalReqBodyTable extends StatelessWidget {
  final List<PlutoColumn> cols;
  final List<PlutoRow> rows;
  final void Function(PlutoGridStateManager) onSmReady;
  final void Function(PlutoGridOnSelectedEvent)? onOneTapSelect;
  final Color? gridBorderColor;
  final bool enableEditing;
  final PlutoGridMode mode;
  final void Function(PlutoGridOnChangedEvent)? onChanged;
  final String? noRowsText;
  final PlutoGridColumnFilterConfig? columnFilter;

  const ApprovalReqBodyTable(
      {Key? key,
      required this.rows,
      this.onOneTapSelect,
      this.columnFilter,
      this.onChanged,
      this.mode = PlutoGridMode.selectWithOneTap,
      this.enableEditing = false,
      this.gridBorderColor,
      required this.onSmReady,
      this.noRowsText,
      required this.cols})
      : super(key: key);

  static Widget defaultTextWidget(String text,
      {TextAlign textAlign = TextAlign.start}) {
    return KText(
      text: text.contains("null") ? "-" : text,
      textColor: ThemeColors.gray2,
      fontWeight: FWeight.regular,
      fontSize: 14,
      textAlign: textAlign,
      isSelectable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> _cols = [];
    for (PlutoColumn col in cols) {
      col.enableContextMenu = false;
      col.backgroundColor = ThemeColors.gray12;
      col.enableDropToResize = false;
      col.enableColumnDrag = false;
      if (!enableEditing) {
        col.enableAutoEditing = false;
        col.enableEditingMode = false;
      } else {
        if (col.enableEditingMode == true) {
          col.cellPadding = const EdgeInsets.symmetric(horizontal: 8);
          col.renderer = (ctx) {
            return MouseRegion(
              cursor: SystemMouseCursors.text,
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: ThemeColors.gray12,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: ThemeColors.gray9,
                    width: 1,
                  ),
                ),
                child: defaultTextWidget(ctx.cell.value.toString()),
              ),
            );
          };
        }
      }
      col.renderer ??= (ctx) {
        return KText(
          text: ctx.cell.value,
          textColor: ThemeColors.gray2,
          fontWeight: FWeight.regular,
          fontSize: 14,
          isSelectable: false,
          textAlign: col.textAlign.value,
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
            columnFilter: columnFilter ?? const PlutoGridColumnFilterConfig(),
            style: PlutoGridStyleConfig(
              columnHeight: 48.0,
              rowHeight: 48.0,
              borderColor: gridBorderColor ?? ThemeColors.transparent,
              gridBorderColor: gridBorderColor ?? ThemeColors.transparent,
              activatedBorderColor: gridBorderColor ?? ThemeColors.transparent,
              activatedColor: ThemeColors.blue12.withOpacity(0.5),
              columnTextStyle: ThemeText.tableColumnTextStyle,
              enableRowColorAnimation: true,
            ),
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: isEqual
                    ? PlutoAutoSizeMode.none
                    : PlutoAutoSizeMode.scale)),
        columns: _cols,
        rows: rows,
        mode: mode,
        onSelected: onOneTapSelect,
        onChanged: onChanged,
        onLoaded: (e) => onSmReady(e.stateManager),
        noRowsWidget: Center(
          child: Text(
            noRowsText ?? "No data found",
            style: ThemeText.lg,
          ),
        ),
      ),
    );
  }
}

class InventoryBodyTable extends StatelessWidget {
  final List<PlutoColumn> cols;
  final List<PlutoRow> rows;
  final void Function(PlutoGridStateManager) onSmReady;
  final void Function(PlutoGridOnSelectedEvent)? onOneTapSelect;
  final Color? gridBorderColor;
  final bool enableEditing;
  final PlutoGridMode mode;
  final void Function(PlutoGridOnChangedEvent)? onChanged;
  final String? noRowsText;
  final PlutoGridColumnFilterConfig? columnFilter;

  const InventoryBodyTable(
      {Key? key,
      required this.rows,
      this.onOneTapSelect,
      this.columnFilter,
      this.onChanged,
      this.mode = PlutoGridMode.selectWithOneTap,
      this.enableEditing = false,
      this.gridBorderColor,
      required this.onSmReady,
      this.noRowsText,
      required this.cols})
      : super(key: key);

  static Widget defaultTextWidget(String text,
      {TextAlign textAlign = TextAlign.start}) {
    return KText(
      text: text.contains("null") ? "-" : text,
      textColor: ThemeColors.gray2,
      fontWeight: FWeight.regular,
      fontSize: 14,
      textAlign: textAlign,
      isSelectable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> _cols = [];
    for (PlutoColumn col in cols) {
      col.enableContextMenu = false;
      col.backgroundColor = ThemeColors.gray12;
      col.enableDropToResize = false;
      col.enableColumnDrag = false;
      if (!enableEditing) {
        col.enableAutoEditing = false;
        col.enableEditingMode = false;
      } else {
        if (col.enableEditingMode == true) {
          col.cellPadding = const EdgeInsets.symmetric(horizontal: 8);
          col.renderer = (ctx) {
            return MouseRegion(
              cursor: SystemMouseCursors.text,
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: ThemeColors.gray12,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: ThemeColors.gray9,
                    width: 1,
                  ),
                ),
                child: defaultTextWidget(ctx.cell.value.toString()),
              ),
            );
          };
        }
      }
      col.renderer ??= (ctx) {
        return KText(
          text: ctx.cell.value,
          textColor: ThemeColors.gray2,
          fontWeight: FWeight.regular,
          fontSize: 14,
          isSelectable: false,
          textAlign: col.textAlign.value,
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
            columnFilter: columnFilter ?? const PlutoGridColumnFilterConfig(),
            style: PlutoGridStyleConfig(
              columnHeight: 48.0,
              rowHeight: 48.0,
              borderColor: gridBorderColor ?? ThemeColors.transparent,
              gridBorderColor: gridBorderColor ?? ThemeColors.transparent,
              activatedBorderColor: gridBorderColor ?? ThemeColors.transparent,
              activatedColor: ThemeColors.blue12.withOpacity(0.5),
              columnTextStyle: ThemeText.tableColumnTextStyle,
              enableRowColorAnimation: true,
            ),
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: isEqual
                    ? PlutoAutoSizeMode.none
                    : PlutoAutoSizeMode.scale)),
        columns: _cols,
        rows: rows,
        mode: mode,
        onSelected: onOneTapSelect,
        onChanged: onChanged,
        onLoaded: (e) => onSmReady(e.stateManager),
        noRowsWidget: Center(
          child: Text(
            noRowsText ?? "No data found",
            style: ThemeText.lg,
          ),
        ),
      ),
    );
  }
}

class TimesheetListDepTable extends StatelessWidget {
  final List<PlutoColumn> cols;
  final List<PlutoRow> rows;
  final void Function(PlutoGridStateManager) onSmReady;
  final void Function(PlutoGridOnChangedEvent)? onChanged;

  const TimesheetListDepTable(
      {Key? key,
      required this.rows,
      required this.onSmReady,
      this.onChanged,
      required this.cols})
      : super(key: key);

  static Widget defaultTextWidget(String text) {
    return KText(
      text: text.contains("null") ? "-" : text,
      textColor: ThemeColors.gray2,
      fontWeight: FWeight.regular,
      fontSize: 14,
      isSelectable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PlutoColumn> _cols = [];
    for (PlutoColumn col in cols) {
      col.enableContextMenu = false;
      col.backgroundColor = ThemeColors.gray12;
      col.enableDropToResize = false;
      col.enableColumnDrag = false;
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
            style: PlutoGridStyleConfig(
              columnHeight: 48.0,
              rowHeight: 48.0,
              borderColor: ThemeColors.gray11,
              gridBorderColor: ThemeColors.gray11,
              activatedBorderColor: ThemeColors.transparent,
              activatedColor: ThemeColors.blue12.withOpacity(0.5),
              columnTextStyle: ThemeText.tableColumnTextStyle,
              enableRowColorAnimation: true,
            ),
            columnSize: PlutoGridColumnSizeConfig(
                autoSizeMode: isEqual
                    ? PlutoAutoSizeMode.none
                    : PlutoAutoSizeMode.scale)),
        columns: _cols,
        rows: rows,
        onChanged: onChanged,
        onLoaded: (e) => onSmReady(e.stateManager),
      ),
    );
  }
}
