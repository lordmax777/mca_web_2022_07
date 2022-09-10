import 'package:auto_route/auto_route.dart';

import '../../theme/theme.dart';

class UserDetailQualifNewQualifPopupWidget extends StatefulWidget {
  const UserDetailQualifNewQualifPopupWidget({Key? key}) : super(key: key);

  @override
  State<UserDetailQualifNewQualifPopupWidget> createState() =>
      _UserDetailQualifNewQualifPopupWidgetState();
}

class _UserDetailQualifNewQualifPopupWidgetState
    extends State<UserDetailQualifNewQualifPopupWidget> {
  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width;

    return TableWrapperWidget(
        child: SpacedColumn(children: [
      _header(context),
      const Divider(color: ThemeColors.gray11, height: 1.0),
      const SizedBox(),
      _body(dpWidth),
      const Divider(color: ThemeColors.gray11, height: 1.0),
      _footer(),
    ]));
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          KText(
            text: 'Add Qualification',
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
            hintText: "Qualification",
            dropdownBtnWidth: dpWidth / 3 + 12,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 3 + 12,
            onChanged: (_) {},
            items: [],
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 3 + 12,
            enabled: false,
            labelText: "Certificate #",
            onTap: () {},
          ),
          DropdownWidget(
            hintText: "Level",
            dropdownBtnWidth: dpWidth / 6 + 12,
            dropdownOptionsWidth: dpWidth / 3 + 12,
            onChanged: (_) {},
            items: [],
          ),
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              CheckboxWidget(
                value: true,
                onChanged: (value) {},
              ),
              KText(
                text: "Has Expiry Date",
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                isSelectable: false,
                fontWeight: FWeight.bold,
              )
            ],
          ),
          SpacedRow(
            horizontalSpace: 12.0,
            children: [
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 6,
                enabled: false,
                labelText: "Start Date",
                leftIcon: HeroIcons.calendar,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime(1930),
                    firstDate: DateTime(1930),
                    lastDate: DateTime(2035),
                  );
                },
              ),
              TextInputWidget(
                isRequired: true,
                width: dpWidth / 6,
                enabled: false,
                labelText: "Expiry Date",
                leftIcon: HeroIcons.calendar,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime(1930),
                    firstDate: DateTime(1930),
                    lastDate: DateTime(2035),
                  );
                },
              ),
            ],
          ),
          TextInputWidget(
            width: dpWidth / 3 + 12,
            enabled: false,
            labelText: "Comment",
            onTap: () {},
            maxLines: 4,
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
            text: 'Add Qualification',
            onPressed: () {
              context.popRoute();
            },
          ),
        ],
      ),
    );
  }
}
