import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:draggable_grid/draggable_grid.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:simpleicons/heroicons.dart';

void Logger(dynamic msg, [String? hint]) {
  final h = hint ?? "LOGGER";
  log("[$h] - ${msg.toString()} - [$h]");
}

class GridTitle {
  final String title;

  const GridTitle({required this.title});
  // int hour;
  // final int minute;
  // final bool is24Format;
  // final DateTime? date;
  // bool get isAM => hour < 12;
  // GridTitle({this.hour = 0, this.minute = 0, this.is24Format = true, this.date}) {
  //   if (!is24Format && hour > 12) {
  //     hour -= 12;
  //   }
  // }
}

class SidebarMd {
  final int id;
  final int groupCount;
  final Widget child;

  SidebarMd({required this.id, this.groupCount = 1, required this.child});
}

class GridDecoration {
  final Color gridHeaderColor;
  final TextStyle gridHeaderTextStyle;
  final Color gridCellColor;
  final Color gridCellBorderColor;
  BoxDecoration? cellDecoration;

  GridDecoration({
    this.gridHeaderColor = const Color(0xFFF9F9F9),
    this.gridHeaderTextStyle =
        const TextStyle(color: Colors.black, fontSize: 14),
    this.gridCellColor = Colors.white,
    this.gridCellBorderColor = const Color(0xFFE8E8EA),
    this.cellDecoration,
  }) {
    cellDecoration ??= BoxDecoration(
        border:
            Border(bottom: BorderSide(color: gridCellBorderColor, width: 1)));
  }

  //implement copyWith
  GridDecoration copyWith({
    Color? gridHeaderColor,
    TextStyle? gridHeaderTextStyle,
    Color? gridCellColor,
    Color? gridCellBorderColor,
  }) {
    return GridDecoration(
      gridHeaderColor: gridHeaderColor ?? this.gridHeaderColor,
      gridHeaderTextStyle: gridHeaderTextStyle ?? this.gridHeaderTextStyle,
      gridCellColor: gridCellColor ?? this.gridCellColor,
      gridCellBorderColor: gridCellBorderColor ?? this.gridCellBorderColor,
    );
  }
}

class Configs {
  /// Variables
  //Grid Data
  final double cellHeight; // in Pixels
  /// [cellWidth] has some calculation,
  /// so try with preferred values
  double? cellWidth;
  final double cellSpacing;
  final double gridHeight;
  final double gridFullWidth;
  //Sidebar Data
  final double sidebarHeaderHeight;
  final double sidebarWidth;

  final List<GridTitle> times;

  GridDecoration? gridDecoration;

  Configs(
      {this.gridHeight = 700,
      this.gridFullWidth = 1448,
      this.cellSpacing = 0,
      this.cellWidth,
      this.cellHeight = 70,
      this.sidebarHeaderHeight = 32,
      this.sidebarWidth = 200,
      this.gridDecoration,
      required this.times}) {
    cellWidth = times.length * (cellWidth ?? 60);
    gridDecoration ??= GridDecoration();
  }

  int getRowCount(List<SidebarMd> sidebar) {
    int rowsCount = 0;
    for (int i = 0; i < sidebar.length; i++) {
      rowsCount = rowsCount + sidebar[i].groupCount;
    }
    return rowsCount;
  }

  double get gridHeaderWidth => cellWidth! / times.length;
  double get gridFullHeight => gridHeight - sidebarHeaderHeight;

  // implement copyWith
  Configs copyWith({
    double? cellHeight,
    double? cellWidth,
    double? cellSpacing,
    double? gridHeight,
    double? gridFullWidth,
    double? sidebarHeaderHeight,
    double? sidebarWidth,
    List<GridTitle>? times,
    GridDecoration? gridDecoration,
  }) {
    return Configs(
      cellHeight: cellHeight ?? this.cellHeight,
      cellWidth: cellWidth ?? this.cellWidth,
      cellSpacing: cellSpacing ?? this.cellSpacing,
      gridHeight: gridHeight ?? this.gridHeight,
      gridFullWidth: gridFullWidth ?? this.gridFullWidth,
      sidebarHeaderHeight: sidebarHeaderHeight ?? this.sidebarHeaderHeight,
      sidebarWidth: sidebarWidth ?? this.sidebarWidth,
      times: times ?? this.times,
      gridDecoration: gridDecoration ?? this.gridDecoration,
    );
  }
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
  GridDecoration get gridDecoration => config.gridDecoration!;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Logger('CustomGridWidgets.init() START');
      _horizontalControllersGroup = LinkedScrollControllerGroup();
      _horizontalController1 = _horizontalControllersGroup.addAndGet();
      _horizontalController2 = _horizontalControllersGroup.addAndGet();

      _verticalControllersGroup = LinkedScrollControllerGroup();
      _verticalController1 = _verticalControllersGroup.addAndGet();
      _verticalController2 = _verticalControllersGroup.addAndGet();
      Logger('CustomGridWidgets.init() END');
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

  Widget _getSidebarHeader() {
    return Container(
      height: config.sidebarHeaderHeight,
      width: config.sidebarWidth,
      decoration: BoxDecoration(
        color: gridDecoration.gridHeaderColor,
        border: Border(
          right: BorderSide(color: gridDecoration.gridCellBorderColor),
          bottom: BorderSide(color: gridDecoration.gridCellBorderColor),
        ),
      ),
      child: Center(
        child: Text(
          "Users",
          style: gridDecoration.gridHeaderTextStyle,
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
              color: gridDecoration.gridHeaderColor,
              border: Border(
                  bottom: BorderSide(color: gridDecoration.gridCellBorderColor),
                  right: BorderSide(color: gridDecoration.gridCellBorderColor)),
            ),
            child: Center(
              child: Text(
                config.times[index].title,
                style: gridDecoration.gridHeaderTextStyle,
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
      height: config.gridFullHeight,
      decoration: BoxDecoration(
        color: gridDecoration.gridCellColor,
      ),
      child: SizedBox(
        height: config.getRowCount(sidebar) * config.cellHeight,
        child: ListView.builder(
          controller: _verticalController1,
          itemCount: sidebar.length,
          itemBuilder: (context, i) => Container(
            width: config.sidebarWidth,
            height: (sidebar[i].groupCount * config.cellHeight).toDouble(),
            decoration: BoxDecoration(
              color: gridDecoration.gridCellColor,
              border: Border(
                  bottom: BorderSide(
                      color: gridDecoration.gridCellBorderColor, width: 1),
                  right: BorderSide(
                      color: gridDecoration.gridCellBorderColor, width: 1)),
            ),
            child: sidebar[i].child,
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
            color: gridDecoration.gridCellColor,
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
                    emptyCellDecoration: gridDecoration.cellDecoration,
                    backgroundColor: gridDecoration.gridCellColor,
                    spacing: config.cellSpacing,
                  ),
                  editingStrategy: const DraggableGridEditingStrategy(
                    exitOnTap: true,
                    immediate: true,
                    enterOnLongTap: false,
                    moveOnlyToNearby: true,
                  ),
                  showGrid: true,
                  emptyCellView: (rowIdx, colIdx, draggingData) => EmptyWidget(
                      rowIdx, colIdx,
                      draggingData: draggingData, config: config),
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
            // Grid Header (only 1 item)
            _getGridHeader(),
          ],
        ),
        if (sidebar.isEmpty)
          const Center(
            child: Text('No data'),
          )
        else
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
  final Configs config;
  const EmptyWidget(this.rowIdx, this.colIdx,
      {Key? key, this.draggingData, required this.config})
      : super(key: key);

  @override
  State<EmptyWidget> createState() => _EmptyWidgetState();
}

class _EmptyWidgetState extends State<EmptyWidget> {
  bool _isHovering = false;

  Configs get config => widget.config;
  GridDecoration get gridDecoration => config.gridDecoration!;

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
                decoration: gridDecoration.cellDecoration,
                child: Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        print(
                            "EmptyWidget: rowIdx = ${widget.rowIdx}, colIdx = ${widget.colIdx}");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xFFE8E8EA),
                            )),
                        child: const HeroIcon(
                          HeroIcons.add,
                          color: Color(0xFF003CFF),
                          size: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : DecoratedBox(
                decoration: gridDecoration.cellDecoration!,
              ));
  }
}
