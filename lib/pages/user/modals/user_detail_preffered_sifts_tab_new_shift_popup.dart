import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';

import '../../../manager/models/list_all_md.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/sets/state_value.dart';
import '../../../manager/redux/states/general_state.dart';
import '../../../manager/redux/states/users_state/users_state.dart';
import '../../../theme/theme.dart';

class UserDetailPreferredShiftsNewShiftPopupWidget extends StatefulWidget {
  const UserDetailPreferredShiftsNewShiftPopupWidget({Key? key})
      : super(key: key);

  @override
  State<UserDetailPreferredShiftsNewShiftPopupWidget> createState() =>
      _UserDetailPreferredShiftsNewShiftPopupWidgetState();
}

class _UserDetailPreferredShiftsNewShiftPopupWidgetState
    extends State<UserDetailPreferredShiftsNewShiftPopupWidget> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  CodeMap? _day;
  CodeMap? _week;
  String? shiftItemName;
  ListShift? _shift;

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => TableWrapperWidget(
          child: Form(
        key: formKey,
        child: SpacedColumn(children: [
          _header(context),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          const SizedBox(),
          _body(dpWidth, state),
          const Divider(color: ThemeColors.gray11, height: 1.0),
          _footer(),
        ]),
      )),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: 'Add Shift',
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

  Widget _body(double dpWidth, AppState state) {
    final GeneralState generalState = state.generalState;
    final locs = generalState.paramList.data!.locations;
    final shifts = generalState.paramList.data!.shifts
        .where((element) => element.active)
        .toList();
    final List<int> weeks = [];
    final int? rotaLen = GeneralController.to.companyInfo.rotalength;

    if (rotaLen != null) {
      weeks.addAll([...Constants.weeksOfTheMonth]);
      weeks.removeWhere((element) => element > rotaLen);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(height: 1),
          DropdownWidget1(
            hintText: "Week",
            value: _week?.name,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (val) {
              setState(() {
                _week = CodeMap(name: val, code: val);
              });
            },
            items: weeks.map((e) => e.toString()).toList(),
          ),
          DropdownWidget1<MapEntry>(
            hintText: "Day",
            value: _day?.name,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            hasSearchBox: true,
            onChangedWithObj: (p0) {
              setState(() {
                _day = CodeMap(
                    name: p0.name, code: (p0.item as MapEntry).key.toString());
              });
            },
            objItems: Constants.daysOfTheWeek.entries.toList(),
            items: Constants.daysOfTheWeek.entries
                .map((e) => e.value.toString())
                .toList(),
          ),
          DropdownWidget1<ListShift>(
            hintText: "Shift",
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            value: shiftItemName,
            objItems: shifts,
            hasSearchBox: true,
            items: shifts
                .map((e) =>
                    "${locs.firstWhere((element) => element.toJson()['id'] == e.location_id).name}, ${e.name}")
                .toList(),
            onChangedWithObj: (DpItem val) {
              setState(() {
                shiftItemName = val.name;
                _shift = val.item as ListShift;
              });
            },
          ),
          const SizedBox(height: 1),
        ],
      ),
    );
  }

  Widget _footer() {
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
            text: 'Add Shift',
            onPressed: () async {
              // if (formKey.currentState!.validate()) {
              await appStore.dispatch(GetPostUserDetailsPreferredShiftAction(
                context: context,
                shiftId: _shift!.id,
                dayId: int.parse(_day!.code!),
                weekId: int.parse(_week!.code!),
                // timingId:
              ));
              // }
            },
          ),
        ],
      ),
    );
  }
}
