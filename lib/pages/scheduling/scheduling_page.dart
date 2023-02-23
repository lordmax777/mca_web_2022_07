import 'package:draggable_grid/draggable_grid.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_get_builder.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/models/location_item_md.dart';

import '../../manager/models/users_list.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';
import 'controllers/scheduling_controller.dart';

class SchedulingPage extends StatelessWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SchedulingController());
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final u = state.usersState.usersList.data ?? [];
        final l = state.generalState.locationItems.data ?? [];
        final sh = state.generalState.paramList.data?.shifts ?? [];
        return GetBuilder<SchedulingController>(
          id: 'SchedulingPage',
          builder: (controller) {
            final users = [
              UserRes(
                  username: "All",
                  loginRequired: false,
                  locationAdmin: false,
                  lastStatus: "",
                  lastName: "All",
                  groupAdmin: false,
                  fullname: "All",
                  firstName: "All",
                  id: -1,
                  title: ""),
              ...u
            ];

            final locations = [LocationItemMd(name: "All"), ...l];
            final shifts = [...sh];
            return PageWrapper(
              child: SpacedColumn(verticalSpace: 16.0, children: [
                const PagesTitleWidget(
                  title: 'Schedule',
                ),
                TableWrapperWidget(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            SpacedRow(
                              horizontalSpace: 16,
                              children: [
                                if (controller.sidebarType == SidebarType.user)
                                  DropdownWidget1(
                                    dropdownOptionsWidth: 250,
                                    dropdownBtnWidth: 250,
                                    hintText: "User",
                                    items:
                                        users.map((e) => e.fullname).toList(),
                                    objItems: users,
                                    customItemIcons: controller.filteredUsers
                                        .map((key, value) =>
                                            MapEntry(key, HeroIcons.check)),
                                    value: controller.filteredUsers.isEmpty
                                        ? "All"
                                        : controller.filteredUsers.values.first
                                            .fullname,
                                    onChangedWithObj: (p0) {
                                      controller.addFilteredUser(
                                          users.indexOf(p0.item), p0);
                                    },
                                  ),
                                if (controller.sidebarType ==
                                    SidebarType.location)
                                  DropdownWidget1(
                                    dropdownOptionsWidth: 400,
                                    dropdownBtnWidth: 250,
                                    hintText: "Location",
                                    items:
                                        locations.map((e) => e.name).toList(),
                                    objItems: locations,
                                    customItemIcons: controller
                                        .filteredLocations
                                        .map((key, value) =>
                                            MapEntry(key, HeroIcons.check)),
                                    value: controller.filteredLocations.isEmpty
                                        ? "All"
                                        : controller.filteredLocations.values
                                            .first.name,
                                    onChangedWithObj: (p0) {
                                      controller.addFilteredLocation(
                                          locations.indexOf(p0.item), p0);
                                    },
                                  ),
                                DropdownWidget1(
                                  dropdownOptionsWidth: 150,
                                  dropdownBtnWidth: 150,
                                  hintText: "Time View",
                                  items: [
                                    ScheduleType.day.name,
                                    ScheduleType.week.name,
                                    ScheduleType.month.name,
                                  ],
                                  value: controller.scheduleType.name,
                                  onChanged: controller.setScheduleType,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                if (controller.scheduleType != ScheduleType.day)
                                  ButtonLargeSecondary(
                                    text:
                                        controller.sidebarType.name.capitalize!,
                                    leftIcon: const HeroIcon(HeroIcons.loop),
                                    onPressed: () {
                                      controller.setSidebarType();
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      CustomGridWidget(
                          config: controller.config,
                          sidebar: controller.sidebar,
                          cells: controller.cells),
                    ],
                  ),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}
