import 'package:draggable_grid/draggable_grid.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_get_builder.dart';

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
            const PagesTitleWidget(
              title: 'Schedule',
            ),
            TableWrapperWidget(
              child: SizedBox(
                width: double.infinity,
                height: controller.config.gridHeight,
                child: CustomGridWidget(config: controller.config, sidebar: [
                  SidebarMd(id: 0),
                  SidebarMd(id: 1),
                  SidebarMd(id: 2),
                  SidebarMd(id: 3),
                  SidebarMd(id: 4),
                  SidebarMd(id: 5),
                  SidebarMd(id: 6),
                  SidebarMd(id: 7),
                  SidebarMd(id: 8),
                  SidebarMd(id: 9),
                ], cells: [
                  DraggableGridCellData(
                    id: "1",
                    column: 1,
                    row: 2,
                    columnSpan: 3,
                    rowSpan: 2,
                    child: Container(
                      height: controller.config.cellHeight * 2,
                      width: controller.config.cellWidth,
                      color: Colors.red,
                      child: const Text('1'),
                    ),
                  )
                ]),
              ),
            ),
          ]),
        );
      },
    );
  }
}
