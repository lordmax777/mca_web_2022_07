import 'package:get/get.dart';

import '../../../manager/models/property_md.dart';
import '../../../manager/models/shift_staff_req_md.dart';
import '../../../theme/theme.dart';
import '../controllers/staff_req_controller.dart';

class StaffReqTab extends StatelessWidget {
  final PropertiesMd property;
  const StaffReqTab({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => StaffReqController(property: property));
    return const TableWrapperWidget(
        padding: EdgeInsets.symmetric(vertical: 16.0), child: StaffReqTable());
  }
}

class StaffReqTable extends StatelessWidget {
  const StaffReqTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GetBuilder<StaffReqController>(
        builder: (controller) => SpacedColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(context, controller),
            _body(context, controller),
            const Divider(),
            _footer(context, controller),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, StaffReqController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          KText(
              text: "Staff Requirements", //TODO: Name
              fontSize: 18.0,
              textColor: ThemeColors.gray2,
              fontWeight: FWeight.bold),
          SpacedRow(
              horizontalSpace: 16.0,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ButtonMedium(
                  text: "Add Staff",
                  icon: const HeroIcon(
                    HeroIcons.plusCircle,
                    size: 20,
                  ),
                  onPressed: () => controller.onEditClick(context),
                ),
              ]),
        ],
      ),
    );
  }

  Widget _body(BuildContext context, StaffReqController controller) {
    return DepsListTable(
      onSmReady: controller.setSm,
      rows: [],
      cols: controller.columns(context),
    );
  }

  Widget _footer(BuildContext context, StaffReqController controller) {
    return SaveAndCancelButtonsWidget(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      saveText: "Save",
      onSave: () => controller.onSave(context),
    );
  }
}
