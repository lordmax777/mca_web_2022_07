import 'dart:math';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:draggable_grid/draggable_grid.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import '../../../comps/dropdown_widget1.dart';
import '../../../manager/models/location_item_md.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../theme/theme.dart';

enum ScheduleType { day, week, month }

enum SidebarType { user, location }

const Map<ScheduleType, double> cellWidths = {
  ScheduleType.day: 70,
  ScheduleType.week: 240,
  ScheduleType.month: 265,
};

const Map<ScheduleType, double> cellHeight = {
  ScheduleType.day: 64,
  ScheduleType.week: 64,
  ScheduleType.month: 136,
};

extension ScheduleTypeExt on ScheduleType {
  String get name => toString().split('.').last;
}

extension SidebarTypeExt on SidebarType {
  String get name => toString().split('.').last;
}

class SchedulingController extends GetxController {
  static SchedulingController get to => Get.find();

  @override
  void onReady() {
    super.onReady();
    setCells();
  }

  final Rx<ScheduleType> _scheduleType = ScheduleType.month.obs;
  ScheduleType get scheduleType => _scheduleType.value;
  set scheduleType(ScheduleType value) => _scheduleType.value = value;

  final Rx<SidebarType> _sidebarType = SidebarType.user.obs;
  SidebarType get sidebarType => _sidebarType.value;
  set sidebarType(SidebarType value) => _sidebarType.value = value;

  Map<int, UserRes> filteredUsers = {};
  Map<int, LocationItemMd> filteredLocations = {};

  DateTime selectedDate = DateTime.now();

  void incrementMonth() {
    selectedDate = selectedDate.add(const Duration(days: 30));
    update(['SchedulingPage']);
  }

  void decrementMonth() {
    selectedDate = selectedDate.subtract(const Duration(days: 30));
    update(['SchedulingPage']);
  }

  void addFilteredUser(int index, DpItem user) {
    if (user.name == "All") {
      filteredUsers = {};
    } else {
      if (filteredUsers.containsKey(index)) {
        filteredUsers.remove(index);
      } else {
        filteredUsers[index] = user.item;
      }
    }
    update(['SchedulingPage']);
  }

  void addFilteredLocation(int index, DpItem location) {
    if (location.name == "All") {
      filteredLocations = {};
    } else {
      if (filteredLocations.containsKey(index)) {
        filteredLocations.remove(index);
      } else {
        filteredLocations[index] = location.item;
      }
    }
    update(['SchedulingPage']);
  }

  void _reset() {
    filteredUsers = {};
    filteredLocations = {};
    selectedDate = DateTime.now();
  }

  void setScheduleType(value) {
    scheduleType = ScheduleType.values.firstWhere(
      (element) => element.name == value,
    );
    if (scheduleType == ScheduleType.day &&
        sidebarType == SidebarType.location) {
      sidebarType = SidebarType.user;
    }
    _reset();
    update(['SchedulingPage']);
  }

  void setSidebarType() {
    if (sidebarType == SidebarType.user) {
      sidebarType = SidebarType.location;
    } else {
      sidebarType = SidebarType.user;
    }
    _reset();
    update(['SchedulingPage']);
  }

  Configs get config => Configs(
      onDragEnd: onDragEnd,
      draggable: scheduleType == ScheduleType.week,
      times: times,
      sidebarWidth: scheduleType == ScheduleType.month ? 1 : 360,
      gridFullWidth: Get.width - Constants.pagePaddingHorizontal * 2,
      gridDecoration: gridDecoration,
      cellHeight: cellHeight[scheduleType]!,
      cellWidth: cellWidths[scheduleType]!);

  List<DraggableGridCellData> monthlyCells = [];

  void addMonthlyCell(int colIdx) {
    DraggableGridCellData? cellData;
    final id = Random().nextInt(1000);
    cellData = DraggableGridCellData(
      id: id,
      column: colIdx,
      row: 1,
      columnSpan: 1,
      rowSpan: 1,
      child: cellWidgets.monthWidget([
        CellItem(
          id: id,
          fromTime: const TimeOfDay(hour: 0, minute: 0),
          toTime: const TimeOfDay(hour: 3, minute: 0),
          username: "John Doe ${colIdx}",
        ),
      ]),
    );

    monthlyCells.add(cellData);

    update(['SchedulingPage']);
  }

  void addToCellChild() {}

  void onDragEnd(int rowIdx, int colIdx, dynamic c) {
    final comingCell = c as CellItem;
    final bool isEmptyCell =
        monthlyCells.any((element) => element.id != comingCell.id);
    print("isEmptyCell: $isEmptyCell");
    if (isEmptyCell) return;
    return;
    print("rowIdx: $rowIdx, colIdx: $colIdx, cell: ${comingCell.id}");
    final oldCell =
        monthlyCells.firstWhere((element) => element.id == comingCell.id);
    final newCell = DraggableGridCellData(
      id: oldCell.id,
      column: colIdx + 1,
      row: rowIdx + 1,
      columnSpan: oldCell.columnSpan,
      rowSpan: oldCell.rowSpan,
      child: oldCell.child,
    );
    monthlyCells.removeWhere((element) => element.id == comingCell.id);
    monthlyCells.add(newCell);
    update(['SchedulingPage']);
  }

  List<DraggableGridCellData> get cells => setCells();

  final CellWidgets cellWidgets = CellWidgets();

  List<DraggableGridCellData> setCells() {
    switch (scheduleType) {
      case ScheduleType.day:
        // TODO: Handle this case.
        return [];
      case ScheduleType.week:
        // TODO: Handle this case.
        return [];
      case ScheduleType.month:
        return monthlyCells;
    }
  }

  Color get cellBorderColor => const Color(0xFFE8E8EA);
  GridDecoration get gridDecoration => GridDecoration(
      cellDecoration: cellDecoration, gridCellBorderColor: cellBorderColor);
  BoxDecoration? get cellDecoration {
    switch (scheduleType) {
      case ScheduleType.day:
        return null;
      case ScheduleType.week:
      case ScheduleType.month:
        return BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: cellBorderColor,
              width: 1,
            ),
            right: BorderSide(
              color: cellBorderColor,
              width: 1,
            ),
          ),
        );
    }
  }

  List<GridTitle> get times {
    switch (scheduleType) {
      case ScheduleType.day:
        return [for (int i = 0; i < 24; i++) GridTitle(title: "$i:00")];
      case ScheduleType.week:
        return const [
          GridTitle(title: ('Tue 18th Jul')),
          GridTitle(title: ('Wed 19th Jul')),
          GridTitle(title: ('Wed 20th Jul')),
          GridTitle(title: ('Wed 21th Jul')),
          GridTitle(title: ('Wed 22th Jul')),
          GridTitle(title: ('Wed 23th Jul')),
          GridTitle(title: ('Wed 24th Jul'))
        ];
      case ScheduleType.month:
        return const [
          GridTitle(title: ('Monday')),
          GridTitle(title: ('Tuesday')),
          GridTitle(title: ('Wednesday')),
          GridTitle(title: ('Thursday')),
          GridTitle(title: ('Friday')),
          GridTitle(title: ('Saturday')),
          GridTitle(title: ('Sunday'))
        ];
    }
  }

  AppState get appState => StoreProvider.of<AppState>(Get.context!).state;
  List<ListShift> get shifts =>
      appState.generalState.paramList.data?.shifts ?? [];
  List<UserRes> get usersList => appState.usersState.usersList.data ?? [];
  List<LocationItemMd> get locations =>
      appState.generalState.locationItems.data ?? [];

  List<SidebarMd> get sidebar {
    final users = [...(usersList)];
    final locs = [...(locations)];
    if (filteredUsers.isNotEmpty) {
      users.clear();
      users.addAll(filteredUsers.values.toList());
    }
    if (filteredLocations.isNotEmpty) {
      locs.clear();
      locs.addAll(filteredLocations.values.toList());
    }
    if (scheduleType != ScheduleType.month) {
      switch (sidebarType) {
        case SidebarType.user:
          return [
            for (int i = 0; i < users.length; i++)
              SidebarMd(id: users[i].id, child: _sidebarWidget(user: users[i])),
          ];
        case SidebarType.location:
          return [
            for (int i = 0; i < locs.length; i++)
              SidebarMd(
                  id: locs[i].id!, child: _sidebarWidget(location: locs[i])),
          ];
      }
    } else {
      return [
        for (int i = 0; i < 5; i++) SidebarMd(id: i, child: const SizedBox()),
      ];
    }
  }

  Widget _sidebarWidget({UserRes? user, LocationItemMd? location}) {
    if (location == null && user == null) return const Text("No data");
    if (location != null) {
      return Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: ThemeColors.blue7,
                maxRadius: 24.0,
                child: HeroIcon(
                  HeroIcons.pin,
                  size: 24.0,
                  color: ThemeColors.white,
                ),
              ),
              const SizedBox(width: 16.0),
              SizedBox(
                width: 250,
                child: KText(
                  isSelectable: false,
                  maxLines: 2,
                  text: location.name,
                  fontSize: 14.0,
                  textColor: ThemeColors.gray2,
                  fontWeight: FWeight.bold,
                ),
              ),
            ],
          ));
    }
    return Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: user!.userRandomBgColor,
              maxRadius: 24.0,
              child: KText(
                fontSize: 16.0,
                isSelectable: false,
                textColor: ThemeColors.black,
                fontWeight: FWeight.bold,
                text:
                    "${user.firstName.substring(0, 1)}${user.lastName.substring(0, 1)}"
                        .toUpperCase(),
              ),
            ),
            const SizedBox(width: 16.0),
            SpacedColumn(
              verticalSpace: 4.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200,
                    child: KText(
                      isSelectable: false,
                      maxLines: 2,
                      text: user.fullname,
                      fontSize: 14.0,
                      textColor: ThemeColors.gray2,
                      fontWeight: FWeight.bold,
                    )),
                SizedBox(
                    width: 200,
                    child: KText(
                      isSelectable: false,
                      maxLines: 2,
                      text: user.username,
                      fontSize: 14.0,
                      textColor: ThemeColors.black,
                      fontWeight: FWeight.regular,
                    )),
              ],
            ),
          ],
        ));
  }
}

class CellItem {
  final int id;
  final TimeOfDay fromTime;
  final TimeOfDay toTime;
  final String username;

  CellItem({
    required this.fromTime,
    required this.toTime,
    required this.username,
    required this.id,
  });
}

class CellWidgets {
  Widget dayWidget(CellItem cell) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: ThemeColors.blue5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KText(
                isSelectable: false,
                text:
                    "${cell.fromTime.hourOfPeriod}${cell.fromTime.period.name} - ${cell.toTime.hourOfPeriod}${cell.toTime.period.name}",
                fontSize: 13,
                fontWeight: FWeight.bold,
              ),
              KText(
                isSelectable: false,
                text: cell.username,
                fontSize: 13,
                fontWeight: FWeight.bold,
              ),
            ],
          ),
          IconButton(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.all(0.0),
              onPressed: () {},
              icon: const HeroIcon(
                HeroIcons.moreVertical,
                size: 24.0,
                color: Colors.white,
              )),
        ],
      ),
    );
  }

  Widget monthWidget(List<CellItem> cells) {
    return Column(
      children: [
        for (var cell in cells)
          LongPressDraggable(
            feedback: Container(
              height: 25.0,
              color: ThemeColors.blue5,
              width: 100,
            ),
            data: cell,
            onDragStarted: () {
              print("Drag started");
            },
            onDragEnd: (details) {},
            child: Container(
              height: 25.0,
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                color: ThemeColors.blue5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SpacedRow(
                    horizontalSpace: 8.0,
                    children: [
                      KText(
                        isSelectable: false,
                        text:
                            "${cell.fromTime.hourOfPeriod}${cell.fromTime.period.name} - ${cell.toTime.hourOfPeriod}${cell.toTime.period.name}",
                        fontSize: 12,
                        fontWeight: FWeight.bold,
                      ),
                      KText(
                        isSelectable: false,
                        text: cell.username,
                        fontSize: 12,
                        fontWeight: FWeight.medium,
                      ),
                    ],
                  ),
                  IconButton(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(0.0),
                      onPressed: () {},
                      icon: const HeroIcon(
                        HeroIcons.moreVertical,
                        size: 18.0,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
