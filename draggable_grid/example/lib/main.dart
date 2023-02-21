import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:draggable_grid/draggable_grid.dart';

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
      scrollBehavior: CustomScrollBehavior(),
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
  final cells = <DraggableGridCellData>[];
  List<SidebarMd> sidebar = [];

  @override
  void initState() {
    super.initState();
    cells.add(DraggableGridCellData(
      column: 1,
      row: 1,
      columnSpan: 3,
      rowSpan: 2,
      id: "User 1",
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Text(
            "Tile 2x2",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    ));
    cells.add(DraggableGridCellData(
      column: cells.last.column + cells.last.columnSpan,
      row: 1,
      columnSpan: 1,
      rowSpan: 1,
      id: "User 0",
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Center(
          child: Text(
            "Tile 1x1",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
    ));
    for (int i = 0; i < 10; i++) {
      sidebar.add(SidebarMd(
          id: i,
          child: Container(
            color: Colors.red.withOpacity(.2),
            child: const Text('2'),
          )));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Schedule Example Test"),
      ),
      body: CustomGridWidget(
        sidebar: sidebar,
        cells: cells,
        config: Configs(
          times: [
            for (int i = 0; i < 24; i++) TimeMd(i),
          ],
        ),
      ),
    );
  }
}
