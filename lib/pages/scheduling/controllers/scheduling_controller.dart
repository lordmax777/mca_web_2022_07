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

  final Rx<ScheduleType> _scheduleType = ScheduleType.day.obs;
  ScheduleType get scheduleType => _scheduleType.value;
  set scheduleType(ScheduleType value) => _scheduleType.value = value;

  final Rx<SidebarType> _sidebarType = SidebarType.user.obs;
  SidebarType get sidebarType => _sidebarType.value;
  set sidebarType(SidebarType value) => _sidebarType.value = value;

  Map<int, UserRes> filteredUsers = {};
  Map<int, LocationItemMd> filteredLocations = {};

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
      draggable: scheduleType != ScheduleType.day,
      times: times,
      sidebarWidth: scheduleType == ScheduleType.month ? 1 : 360,
      gridFullWidth: Get.width - Constants.pagePaddingHorizontal * 2,
      gridDecoration: gridDecoration,
      cellHeight: cellHeight[scheduleType]!,
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

  List<DraggableGridCellData> cells = [];

  void setCells() {
    cells = [
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
