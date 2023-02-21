import 'package:draggable_grid/draggable_grid.dart';
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
    return GBuilder<SchedulingController>(
      tag: 'SchedulingPage',
      child: (controller) {
        controller.i.value;
        return PageWrapper(
          child: SpacedColumn(verticalSpace: 16.0, children: [
            PagesTitleWidget(
              title: 'Schedule',
              btnText: controller.scheduleType.name,
              onRightBtnClick: controller.setScheduleType,
            ),
            TableWrapperWidget(
              child: Column(
                children: [
                  Row(
                    children: [
                      DropdownWidget(
                        items: const ["user", "location"],
                        value: controller.sidebarType.name,
                        onChanged: (value) {
                          controller.setSidebarType();
                        },
                      ),
                    ],
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
