import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void logger(dynamic msg, [String? hint]) {
  final h = hint ?? "LOGGER";
  log("[$h] - ${msg.toString()} - [$h]");
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<PlutoRow> rows = [];
  final List<PlutoColumn> columns = [];
  PlutoGridStateManager? sm;
  bool isHovering = false;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 24; i++) {
      columns.add(PlutoColumn(
        title: "Column $i",
        field: "column$i",
        type: PlutoColumnType.text(),
        renderer: (rendererContext) {
          return StatefulBuilder(builder: (context, ss) {
            return InkWell(
              onHover: (value) {
                print(value);
                print("Hovering");
                ss(() {
                  isHovering = !isHovering;
                });
              },
              child: DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return LongPressDraggable(
                    feedback: Material(
                      child: Container(
                        height: 100,
                        width: 100,
                        color: Colors.red.withOpacity(.4),
                        child: Text(rendererContext.cell.value.toString()),
                      ),
                    ),
                    data: {
                      "rowIdx": rendererContext.rowIdx,
                      "columnField": rendererContext.column.field
                    },
                    child: isHovering
                        ? const Icon(
                            Icons.add,
                            color: Colors.red,
                            size: 50,
                          )
                        : Container(
                            child: Text(rendererContext.cell.value.toString()),
                          ),
                  );
                },
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (data) {
                  logger(data);
                  logger(rendererContext.rowIdx);
                  final s = rendererContext.stateManager;
                  s.moveCurrentCell(PlutoMoveDirection.down);
                },
              ),
            );
          });
        },
      ));
    }

    for (int i = 0; i < 80; i++) {
      rows.add(PlutoRow(cells: {
        for (int j = 0; j < 24; j++) "column$j": PlutoCell(value: "Name $i"),
      }));
    }
  }

  //TODO: Implement on move function
  //TODO: Implement Grouped Sidebar

  void onMoveCell() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text("Schedule Example Test"),
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: [],
          ),
        ));
  }
}

class Conf {
  final cellHeight = 100;
  final cellWidth = 100;

  final headerHeight = 50;
  final sidebarWidth = 50;
}

class CellWidget extends StatelessWidget {
  final Conf config;
  final List<CellMd> cells;
  const CellWidget({Key? key, required this.config, required this.cells})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              height: config.cellHeight.toDouble(),
              width: config.cellWidth.toDouble(),
              color: Colors.red,
              child: cells[index].child,
            );
          },
          itemCount: cells.length),
    );
  }
}

class CellMd {
  final Widget child;

  const CellMd({required this.child});
}

//Sidebar Widget
class SidebarWidget extends StatelessWidget {
  final Conf config;
  final List<SBMd> sidebarList;
  const SidebarWidget(
      {Key? key, required this.config, required this.sidebarList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: ListView.builder(
          itemBuilder: (context, index) {
            return Container(
              height: config.cellHeight.toDouble(),
              width: config.sidebarWidth.toDouble(),
              color: Colors.red,
              child: sidebarList[index].child,
            );
          },
          itemCount: sidebarList.length),
    );
  }
}

//Sidebar Item Model
class SBMd {
  final Widget child;
  const SBMd({required this.child});
}

//Header Widget
class HeaderWidget extends StatelessWidget {
  final Conf config;
  final List<HeaderMd> headerList;
  const HeaderWidget({Key? key, required this.config, required this.headerList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: ListView.builder(itemBuilder: (context, index) {
        return Container(
          height: config.headerHeight.toDouble(),
          width: config.sidebarWidth.toDouble(),
          color: Colors.red,
          child: Text(headerList[index].title),
        );
      }),
    );
  }
}

//Header Item Model
class HeaderMd {
  final String title;
  final String field;
  const HeaderMd({required this.title, required this.field});
}

//TODO: Create a full canvas
class GridWidget extends StatelessWidget {
  final Conf config;
  final CellWidget cellWidget;
  final SidebarWidget sidebar;

  const GridWidget(
      {Key? key,
      required this.config,
      required this.cellWidget,
      required this.sidebar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //Sidebar
        HeaderWidget(
            config: config,
            headerList: const [HeaderMd(title: "Users", field: "users")]),
        //Grid
        ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                height: config.cellHeight.toDouble(),
                width: config.cellWidth.toDouble(),
                color: Colors.red,
                child: cellWidget.cells[index].child,
              );
            },
            itemCount: cellWidget.cells.length),
      ],
    );
  }
}
