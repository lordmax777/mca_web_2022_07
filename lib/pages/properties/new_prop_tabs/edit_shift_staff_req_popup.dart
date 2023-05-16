import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';

import '../../../comps/autocomplete_input_field.dart';
import '../../../theme/theme.dart';

class EditShiftStaffReqPopup extends StatefulWidget {
  final ShiftStaffReqMd? staff;
  final List<int>? exceptedIds;
  const EditShiftStaffReqPopup({Key? key, this.staff, this.exceptedIds})
      : super(key: key);
  @override
  State<EditShiftStaffReqPopup> createState() => _EditShiftStaffReqPopupState();
}

class _EditShiftStaffReqPopupState extends State<EditShiftStaffReqPopup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numberOfStaff = TextEditingController();
  final TextEditingController maxStaff = TextEditingController();
  final department = CodeMap<int>(name: null, code: null);

  List<int> get exceptedIds => widget.exceptedIds ?? [];

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      numberOfStaff.text = widget.staff!.min.toString();
      maxStaff.text = widget.staff!.max.toString();
      department.name = widget.staff!.group;
      department.code = widget.staff!.groupId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;
    return TableWrapperWidget(
      child: Form(
        key: formKey,
        child: SpacedColumn(children: [
          _header(context),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          const SizedBox(),
          _body(dpWidth),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          _footer(context),
        ]),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final bool isNew = widget.staff == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: !isNew ? 'Edit Staff' : 'Add Staff',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          IconButton(
              onPressed: context.popRoute,
              icon: const HeroIcon(HeroIcons.x,
                  color: ThemeColors.gray2, size: 20.0)),
        ],
      ),
    );
  }

  Widget _body(double dpWidth) {
    final bool isNew = widget.staff == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(height: 1),
          CustomAutocompleteTextField<ListGroup>(
              width: dpWidth / 5,
              height: 50,
              hintText: "Department",
              listItemWidget: (p0) => Text(p0.name),
              onCleared: () {
                department.name = null;
                department.code = null;
                setState(() {});
              },
              onSelected: (p0) {
                department.name = p0.name;
                department.code = p0.id;
                setState(() {});
              },
              displayStringForOption: (option) {
                return option.name;
              },
              options: (p0) => appStore.state.generalState.groups
                  .where((element) => !exceptedIds.contains(element.id))
                  .where((element) => element.name
                      .toLowerCase()
                      .contains(p0.text.toLowerCase()))),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            labelText: "Number of Staff",
            controller: numberOfStaff,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Please enter number of staff";
              }
              return null;
            },
          ),
          TextInputWidget(
            width: dpWidth / 5,
            labelText: "Maximum Staff",
            controller: maxStaff,
          ),
          const SizedBox(width: 1),
        ],
      ),
    );
  }

  Widget _footer(BuildContext context) {
    final bool isNew = widget.staff == null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.end,
        horizontalSpace: 16.0,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ButtonLargeSecondary(
            text: 'Cancel',
            paddingWithoutIcon: true,
            onPressed: () {
              context.popRoute();
            },
          ),
          ButtonLarge(
            paddingWithoutIcon: true,
            icon: const HeroIcon(HeroIcons.check, size: 20.0),
            text: isNew ? "Add New" : "Save Changes",
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              context.popRoute(ShiftStaffReqMd(
                groupId: department.code ?? -1,
                group: department.name ?? "",
                min: int.parse(numberOfStaff.text),
                max: int.tryParse(maxStaff.text),
              ));
            },
          ),
        ],
      ),
    );
  }
}
