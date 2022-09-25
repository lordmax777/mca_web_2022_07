import 'package:auto_route/auto_route.dart';

import '../../theme/theme.dart';

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

  String? _day;
  String? _week;
  String? _location;
  String? _shift;

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
        _footer(),
      ]),
    ));
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
              onPressed: () {
                context.popRoute();
              },
              icon: const HeroIcon(HeroIcons.x,
                  color: ThemeColors.gray2, size: 20.0)),
        ],
      ),
    );
  }

  Widget _body(double dpWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 32.0,
        children: [
          const SizedBox(),
          DropdownWidget(
            hintText: "Week",
            value: _week,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (val) {
              setState(() {
                _week = val;
              });
            },
            items: [],
          ),
          DropdownWidget(
            hintText: "Location",
            value: _location,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (val) {
              setState(() {
                _location = val;
              });
            },
            items: [],
          ),
          DropdownWidget(
            hintText: "Day",
            value: _day,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            hasSearchBox: true,
            onChanged: (val) {
              setState(() {
                _day = val;
              });
            },
            items: Constants.daysOfTheWeek.entries
                .map((e) => e.value.toString())
                .toList(),
          ),
          DropdownWidget(
            hintText: "Shift",
            value: _shift,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (val) {
              setState(() {
                _shift = val;
              });
            },
            items: [],
          ),
          const SizedBox(),
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
            onPressed: () {
              if (formKey.currentState!.validate()) {}
            },
          ),
        ],
      ),
    );
  }
}
