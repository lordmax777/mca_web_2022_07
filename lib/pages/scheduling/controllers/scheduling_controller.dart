import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:draggable_grid/draggable_grid.dart';

enum ScheduleType { day, week, month }

enum SidebarType { user, location }

const Map<ScheduleType, double> cellWidths = {
  ScheduleType.day: 50,
  ScheduleType.week: 200,
  ScheduleType.month: 200,
};

extension ScheduleTypeExt on ScheduleType {
  String get name => toString().split('.').last;
}

extension SidebarTypeExt on SidebarType {
  String get name => toString().split('.').last;
}

class SchedulingController extends GetxController {
  static SchedulingController get to => Get.find();
  final RxInt i = 0.obs;

  final Rx<ScheduleType> _scheduleType = ScheduleType.day.obs;
  ScheduleType get scheduleType => _scheduleType.value;
  set scheduleType(ScheduleType value) => _scheduleType.value = value;

  final Rx<SidebarType> _sidebarType = SidebarType.user.obs;
  SidebarType get sidebarType => _sidebarType.value;
  set sidebarType(SidebarType value) => _sidebarType.value = value;

  void setScheduleType(value) {
    // if (scheduleType == ScheduleType.day) {
    //   scheduleType = ScheduleType.week;
    // } else if (scheduleType == ScheduleType.week) {
    //   scheduleType = ScheduleType.month;
    // } else {
    //   scheduleType = ScheduleType.day;
    // }
    scheduleType = ScheduleType.values.firstWhere(
      (element) => element.name == value,
    );
    update(['SchedulingPage']);
  }

  void setSidebarType() {
    if (sidebarType == SidebarType.user) {
      sidebarType = SidebarType.location;
    } else {
      sidebarType = SidebarType.user;
    }
    update(['SchedulingPage']);
  }

  Configs get config => Configs(
      times: times,
      gridDecoration: gridDecoration,
      cellWidth: cellWidths[scheduleType]!);

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

  List<SidebarMd> get sidebar {
    switch (sidebarType) {
      case SidebarType.user:
        return [
          SidebarMd(id: 0, child: const Text('User 1')),
          SidebarMd(id: 1, child: const Text('User 2')),
          SidebarMd(id: 2, child: const Text('User 3')),
          SidebarMd(id: 3, child: const Text('User 4')),
        ];
      case SidebarType.location:
        return [
          SidebarMd(id: 0, child: const Text('Location 1')),
          SidebarMd(id: 1, child: const Text('Location 2')),
          SidebarMd(id: 2, child: const Text('Location 3')),
          SidebarMd(id: 3, child: const Text('Location 4')),
        ];
    }
  }

  List<DraggableGridCellData> cells = [
    DraggableGridCellData(
      id: "1",
      column: 1,
      row: 2,
      columnSpan: 1,
      rowSpan: 1,
      child: Container(
        // height: config.cellHeight * 2,
        // width: config.cellWidth,
        color: Colors.red.withOpacity(.5),
        child: const Text('1'),
      ),
    )
  ];
}
