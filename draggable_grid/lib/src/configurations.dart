import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:draggable_grid/draggable_grid.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

void logger(dynamic msg, [String? hint]) {
  final h = hint ?? "LOGGER";
  log("[$h] - ${msg.toString()} - [$h]");
}

class TimeMd {
  int hour;
  final int minute;
  final bool is24Format;
  bool get isAM => hour < 12;
  TimeMd(this.hour, {this.minute = 0, this.is24Format = true}) {
    if (!is24Format && hour > 12) {
      hour -= 12;
    }
  }
}

class SidebarMd {
  final int id;
  final int groupCount;

  SidebarMd({required this.id, this.groupCount = 1});
}

class Configs {
  final List<TimeMd> times = [
    for (int i = 0; i < 24; i++) TimeMd(i) //TimeMd(i ~/ 2, minute: i % 2 * 30)
  ];

  //Grid Data
  final double cellHeight = 56; // in Pixels
  /// [cellWidth] has some calculation,
  /// so try with preferred values
  final double cellWidth = 24 * 100;
  final double cellSpacing = 2;
  int getRowCount(List<SidebarMd> sidebar) {
    int rowsCount = 0;
    for (int i = 0; i < sidebar.length; i++) {
      rowsCount = rowsCount + sidebar[i].groupCount;
    }
    return rowsCount;
  }

  double get gridHeaderWidth => cellWidth / times.length;
  final double gridHeight = 700;
  final double gridFullWidth = 1656;
  double get gridFullHeight => gridHeight - sidebarHeaderHeight;

  //Sidebar Data
  final double sidebarHeaderHeight = 32;
  final double sidebarWidth = 200;
}

class CustomGridWidget extends StatefulWidget {
  final List<SidebarMd> sidebar;
  final List<DraggableGridCellData> cells;
  final Configs config;
  const CustomGridWidget(
      {Key? key,
      required this.cells,
      required this.sidebar,
      required this.config})
      : super(key: key);

  @override
  State<CustomGridWidget> createState() => _CustomGridWidgetState();
}

class _CustomGridWidgetState extends State<CustomGridWidget> {
  bool initFinish = false;

  Configs get config => widget.config;
  List<SidebarMd> get sidebar => widget.sidebar;
  List<DraggableGridCellData> get cells => widget.cells;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      logger('CustomGridWidgets.init() START');
      _horizontalControllersGroup = LinkedScrollControllerGroup();
      _horizontalController1 = _horizontalControllersGroup.addAndGet();
      _horizontalController2 = _horizontalControllersGroup.addAndGet();

      _verticalControllersGroup = LinkedScrollControllerGroup();
      _verticalController1 = _verticalControllersGroup.addAndGet();
      _verticalController2 = _verticalControllersGroup.addAndGet();
      logger('CustomGridWidgets.init() END');
      setState(() {
        initFinish = true;
      });
    });
  }

  @override
  void dispose() {
    _horizontalController1.dispose();
    _horizontalController2.dispose();
    _verticalController1.dispose();
    _verticalController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!initFinish) return const SizedBox();
    return getFullGrid();
  }

  late LinkedScrollControllerGroup _horizontalControllersGroup;
  late ScrollController _horizontalController1;
  late ScrollController _horizontalController2;

  late LinkedScrollControllerGroup _verticalControllersGroup;
  late ScrollController _verticalController1;
  late ScrollController _verticalController2;

  ///Must run this function before using any other function
  void init() {}

  Widget _getSidebarHeader() {
    return Container(
      height: config.sidebarHeaderHeight,
      width: config.sidebarWidth,
      decoration: BoxDecoration(
        color: Colors.grey[300]!,
        border: Border(
          right: BorderSide(color: Colors.grey[400]!),
          bottom: BorderSide(color: Colors.grey[400]!),
        ),
      ),
      child: const Center(
        child: Text(
          "Users",
        ),
      ),
    );
  }

  Widget _getGridHeader() {
    return SizedBox(
      height: config.sidebarHeaderHeight,
      width: config.gridFullWidth,
      child: ListView.builder(
        controller: _horizontalController2,
        scrollDirection: Axis.horizontal,
        itemCount: config.times.length,
        itemBuilder: (context, index) {
          return Container(
            height: config.sidebarWidth,
            width: config.gridHeaderWidth,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border(right: BorderSide(color: Colors.grey[400]!)),
            ),
            child: Center(
              child: Text(
                "${config.times[index].hour}:${config.times[index].minute <= 0 ? "0" : ""}${config.times[index].minute}",
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getSidebarItems(List<SidebarMd> sidebar) {
    return Container(
      width: config.sidebarWidth,
      color: Colors.grey[300],
      child: SingleChildScrollView(
        controller: _verticalController1,
        child: SizedBox(
          height: config.getRowCount(sidebar) * config.cellHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < sidebar.length; i++)
                Container(
                  height:
                      (sidebar[i].groupCount * config.cellHeight).toDouble(),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border(
                        bottom: BorderSide(color: Colors.grey[400]!),
                        right: BorderSide(color: Colors.grey[400]!)),
                  ),
                  child: Center(
                    child: Text(
                      sidebar[i].id.toString(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getGridItems(
      List<SidebarMd> sidebar, List<DraggableGridCellData> cells) {
    return Scrollbar(
      controller: _horizontalController1,
      child: SizedBox(
        height: config.gridFullHeight,
        child: SingleChildScrollView(
          controller: _verticalController2,
          child: Container(
            color: Colors.grey[400],
            width: config.gridFullWidth,
            height: config.getRowCount(sidebar) * config.cellHeight,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _horizontalController1,
              child: SizedBox(
                width: config.cellWidth,
                child: DraggableGrid(
                  style: DraggableGridStyle(
                    cellHeight: config.cellHeight,
                    emptyCellDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black, width: .2),
                    ),
                    backgroundColor: Colors.grey[500]!,
                    spacing: config.cellSpacing,
                    selectedCellDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  editingStrategy: const DraggableGridEditingStrategy(
                    exitOnTap: true,
                    immediate: true,
                    enterOnLongTap: false,
                    moveOnlyToNearby: true,
                  ),
                  showGrid: true,
                  emptyCellView: (rowIdx, colIdx, draggingData) =>
                      EmptyWidget(rowIdx, colIdx, draggingData: draggingData),
                  columns: config.times.length,
                  rows: config.getRowCount(sidebar),
                  cells: cells,
                  onCellChanged: (cell) {
                    print('Cell ${cell?.id} changed');
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFullGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar Header (only 1 item)
            _getSidebarHeader(),
            // Grid Header (list)
            _getGridHeader(),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sidebar (list)
            _getSidebarItems(sidebar),
            // Grid (list)
            _getGridItems(sidebar, cells),
          ],
        ),
      ],
    );
  }
}

class EmptyWidget extends StatefulWidget {
  final int rowIdx;
  final int colIdx;
  final DraggableGridCellData? draggingData;
  const EmptyWidget(this.rowIdx, this.colIdx, {Key? key, this.draggingData})
      : super(key: key);

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  bool _isHovering = false;

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onHover: _onHover,
        onTap: () {
          print(
              "EmptyWidget: rowIdx = ${widget.rowIdx}, colIdx = ${widget.colIdx}");
        },
        child: _isHovering
            ? Container(
                decoration: BoxDecoration(
                    color: Colors.lime[400]!,
                    borderRadius: BorderRadius.circular(4)))
            : DecoratedBox(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.black, width: .2),
              )));
  }
}
