import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/pages/scheduling/create_shift_popup.dart';

import '../../../comps/autocomplete_input_field.dart';
import '../../../theme/theme.dart';

class EditShiftQualifReqPopup extends StatefulWidget {
  final ShiftQualifReqMd? staff;
  final List<int>? exceptedIds;
  const EditShiftQualifReqPopup({Key? key, this.staff, this.exceptedIds})
      : super(key: key);
  @override
  State<EditShiftQualifReqPopup> createState() =>
      _EditShiftQualifReqPopupState();
}

class _EditShiftQualifReqPopupState extends State<EditShiftQualifReqPopup> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numberOfStaff = TextEditingController();
  final department = CodeMap<int>(name: null, code: null);
  final minLevel = CodeMap<int>(name: null, code: null);
  bool alternate = false;

  List<int> get exceptedIds => widget.exceptedIds ?? [];

  @override
  void initState() {
    super.initState();
    if (widget.staff != null) {
      department.name = widget.staff!.qualificationName;
      department.code = widget.staff!.qualificationId;
      minLevel.name = widget.staff!.levelName;
      minLevel.code = widget.staff!.levelId;
      numberOfStaff.text = widget.staff!.numberOfStaff.toString();
      alternate = widget.staff!.alternative;
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
            text: !isNew ? 'Edit Qualification' : 'Add Qualification',
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
    final levels = [
      ...(appStore.state.generalState.qualificationLevels
        ..add(ListQualificationLevel(id: -1, level: "N/A", rank: 0)))
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(height: 1),
          CustomAutocompleteTextField<ListQualification>(
              width: dpWidth / 5,
              height: 50,
              hintText: "Qualification",
              initialValue: TextEditingValue(text: department.name ?? ""),
              listItemWidget: (p0) => Text(p0.title),
              onCleared: () {
                department.name = null;
                department.code = null;
                setState(() {});
              },
              onSelected: (p0) {
                department.name = p0.title;
                department.code = p0.id;
                setState(() {});
              },
              displayStringForOption: (option) {
                return option.title;
              },
              options: (p0) => appStore.state.generalState.qualifications
                  .where((element) => !exceptedIds.contains(element.id))
                  .where((element) => element.title
                      .toLowerCase()
                      .contains(p0.text.toLowerCase()))),
          CustomAutocompleteTextField<ListQualificationLevel>(
              width: dpWidth / 5,
              height: 50,
              hintText: "Min Level",
              initialValue: TextEditingValue(text: minLevel.name ?? ""),
              listItemWidget: (p0) => Text(p0.level),
              onCleared: () {
                minLevel.name = null;
                minLevel.code = null;
                setState(() {});
              },
              onSelected: (p0) {
                minLevel.name = p0.level;
                minLevel.code = p0.id;
                setState(() {});
              },
              displayStringForOption: (option) {
                return option.level;
              },
              options: (p0) => levels.where((element) =>
                  element.level.toLowerCase().contains(p0.text.toLowerCase()))),
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
          labelWithField(
            "Alternative to selected",
            checkbox(alternate, (p0) {
              setState(() {
                alternate = p0;
              });
            }),
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
              if (department.code == null) {
                showError("Please select qualification");
                return;
              }
              context.popRoute(ShiftQualifReqMd(
                qualificationId: department.code!,
                numberOfStaff: int.parse(numberOfStaff.text),
                levelId: minLevel.code,
                levelName: minLevel.name,
                qualificationName: department.name!,
                alternative: alternate,
              ));
            },
          ),
        ],
      ),
    );
  }
}
