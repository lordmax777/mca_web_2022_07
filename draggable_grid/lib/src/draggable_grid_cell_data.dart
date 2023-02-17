import 'package:flutter/widgets.dart';

/// A metadata that defines an item (cell) of [DraggableGrid].
///
/// The item [id] is required and must be unique within the grid widget.
/// Item is positioned to [column] and [row] withing the grid and span
/// [columnSpan] and [rowSpan] cells. By default, the grid item occupies
/// a single cell.
/// The content of the cell is determined by the [child] widget.
///
/// ```dart
/// List<DraggableGridCellData> cells = List();
/// cells.add(DraggableGridCellData(
///   column: 1,
///   row: 1,
///   columnSpan: 2,
///   rowSpan: 2,
///   id: "Test Cell 1",
///   child: Container(
///     color: Colors.lime,
///     child: Center(
///       child: Text("Tile 2x2",
///         style: Theme.of(context).textTheme.title,
///       ),
///      ),
///   ),
/// ));
/// cells.add(DraggableGridCellData(
///   column: 4,
///   row: 1,
///   id: "Test Cell 2",
///   child: Container(
///     color: Colors.lime,
///     child: Center(
///       child: Text("Tile 1x1",
///         style: Theme.of(context).textTheme.title,
///       ),
///     ),
///   ),
/// ));
/// ```
class DraggableGridCellData {
  DraggableGridCellData(
      {required this.id,
      this.child,
      required this.column,
      required this.row,
      this.height = 0,
      this.columnSpan = 1,
      this.rowSpan = 1,
      this.acceptOnlyHorizontal = false,
      this.acceptOnlyVertical = false});

  Object id;
  Widget? child;
  int column;
  int row;
  int columnSpan;
  int rowSpan;
  double height;
  bool acceptOnlyHorizontal;
  bool acceptOnlyVertical;

  @override
  toString() {
    return "DraggableGridCellData {id: $id, column: $column, row: $row, columnSpan: $columnSpan, rowSpan: $rowSpan}";
  }
}
