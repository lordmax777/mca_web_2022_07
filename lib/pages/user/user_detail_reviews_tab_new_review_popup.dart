import 'package:auto_route/auto_route.dart';

import '../../theme/theme.dart';

class UserDetailReviewNewReviewPopupWidget extends StatefulWidget {
  const UserDetailReviewNewReviewPopupWidget({Key? key}) : super(key: key);

  @override
  State<UserDetailReviewNewReviewPopupWidget> createState() =>
      _UserDetailReviewNewReviewPopupWidgetState();
}

class _UserDetailReviewNewReviewPopupWidgetState
    extends State<UserDetailReviewNewReviewPopupWidget> {
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
            text: 'New Review',
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
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 4,
            enabled: false,
            labelText: "Title",
            onTap: () {},
          ),
          DropdownWidget(
            hintText: "Conducted By",
            dropdownBtnWidth: dpWidth / 4,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 4,
            onChanged: (_) {},
            items: [],
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 6,
            enabled: false,
            labelText: "Conducted On",
            leftIcon: HeroIcons.calendar,
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime(2015),
                firstDate: DateTime(2015),
                lastDate: DateTime(2035),
              );
            },
          ),
          TextInputWidget(
            width: dpWidth / 4,
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
            text: 'Save',
            onPressed: () {
              context.popRoute();
            },
          ),
        ],
      ),
    );
  }
}
