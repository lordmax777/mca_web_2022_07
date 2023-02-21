import 'package:draggable_grid/draggable_grid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_get_builder.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';

import '../../theme/theme.dart';
import 'controllers/scheduling_controller.dart';

class SchedulingPage extends StatelessWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SchedulingController());
    return GetBuilder<SchedulingController>(
      id: 'SchedulingPage',
      builder: (controller) {
        controller.i.value;
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
                        ButtonLargeSecondary(
                          text: controller.sidebarType.name.capitalize!,
                          leftIcon: const HeroIcon(HeroIcons.loop),
                          onPressed: () {
                            controller.setSidebarType();
                          },
                        ),
                        const Spacer(),
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
  }
}
