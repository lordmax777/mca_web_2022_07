import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:draggable_grid/draggable_grid.dart';

import 'draggable_grid_cell_data.dart';

class DraggableGridEmptyCellView extends StatelessWidget {
  const DraggableGridEmptyCellView({
    Key? key,
    required this.data,
    required this.style,
    required this.onWillAccept,
    required this.onAccept,
    this.content,
    this.isEditing = false,
  }) : super(key: key);

  final DraggableGridCellData data;

  final DraggableGridStyle style;

  final Function(DraggableGridCellData data) onWillAccept;

  final Function(DraggableGridCellData data) onAccept;

  final Widget? content;

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final emptyCellView = content ?? SizedBox();
    return isEditing
        ? Container(
            decoration: style.emptyCellDecoration,
            child: DragTarget<DraggableGridCellData>(
              builder: (context, List<DraggableGridCellData?> candidateData,
                  rejectedData) {
                return emptyCellView;
              },
              onWillAccept: (data) => onWillAccept(data!),
              onAccept: (data) => onAccept(data),
            ),
          )
        : emptyCellView;
  }
}
