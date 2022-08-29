import 'package:pluto_grid/pluto_grid.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

// ignore: must_be_immutable
class MobileStatusWidget extends StatefulWidget {
  AppState state;
  MobileStatusWidget({Key? key, required this.state}) : super(key: key);

  @override
  State<MobileStatusWidget> createState() => _MobileStatusWidgetState();
}

class _MobileStatusWidgetState extends State<MobileStatusWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(48.0),
      child: SizedBox(
        width: double.infinity,
        child: SpacedColumn(
          verticalSpace: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _top(),
            const Divider(height: 40.0, color: ThemeColors.gray11),
            _bottom(),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return SpacedRow(horizontalSpace: 48.0, children: [
      _topLeft(),
      Container(
        width: 1,
        height: 400,
        color: ThemeColors.gray11,
      ),
      _topRight(),
    ]);
  }

  Widget _topLeft() {
    final dpWidth = MediaQuery.of(context).size.width;

    return SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 24.0,
        children: [
          KText(
            text: 'Current Status',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          DropdownWidget(
            hintText: "Status",
            disableAll: true,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Location",
            disableAll: true,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Shift",
            disableAll: true,
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          TextInputWidget(
            disableAll: true,
            width: dpWidth / 4,
            maxLines: 4,
            labelText: "Comment",
            onTap: () {},
          ),
        ]);
  }

  Widget _topRight() {
    final dpWidth = MediaQuery.of(context).size.width;

    return SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 24.0,
        children: [
          KText(
            text: 'New Status',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          DropdownWidget(
            hintText: "Status",
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Location",
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Shift",
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          TextInputWidget(
            width: dpWidth / 4,
            maxLines: 4,
            labelText: "Comment",
            onTap: () {},
          ),
          SizedBox(
            width: dpWidth / 4,
            child: SpacedRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SpacedRow(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  horizontalSpace: 8.0,
                  children: [
                    CheckboxWidget(
                      value: true,
                      onChanged: (value) {},
                    ),
                    KText(
                      text: "Confirm",
                      fontSize: 14.0,
                      textColor: ThemeColors.gray2,
                      isSelectable: false,
                      fontWeight: FWeight.bold,
                    )
                  ],
                ),
                ButtonLarge(
                  icon: const HeroIcon(HeroIcons.check),
                  text: "Submit",
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ]);
  }

  Widget _bottom() {
    final dpWidth = MediaQuery.of(context).size.width;

    return SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalSpace: 8.0,
        children: [
          KText(
            text: 'Mobile Authorization',
            fontSize: 18.0,
            fontWeight: FWeight.bold,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          KText(
            text: 'Mobile device was last authorized on 22/07/2022 at 06:05',
            fontSize: 16.0,
            isSelectable: false,
            textColor: ThemeColors.gray2,
          ),
          const SizedBox(height: 4.0),
          DropdownWidget(
            hintText: "Action",
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          const SizedBox(height: 4.0),
          SizedBox(
            width: dpWidth / 4,
            child: SpacedRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SpacedRow(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  horizontalSpace: 8.0,
                  children: [
                    CheckboxWidget(
                      value: true,
                      onChanged: (value) {},
                    ),
                    KText(
                      text: "Confirm",
                      fontSize: 14.0,
                      textColor: ThemeColors.gray2,
                      isSelectable: false,
                      fontWeight: FWeight.bold,
                    )
                  ],
                ),
                ButtonLarge(
                  icon: const HeroIcon(HeroIcons.check),
                  text: "Submit",
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ]);
  }
}
