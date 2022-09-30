import 'package:auto_route/auto_route.dart';

import '../../theme/theme.dart';

class UserDetailReviewNewReviewPopupWidget extends StatefulWidget {
  final int? id;
  const UserDetailReviewNewReviewPopupWidget({Key? key, this.id})
      : super(key: key);

  @override
  State<UserDetailReviewNewReviewPopupWidget> createState() =>
      _UserDetailReviewNewReviewPopupWidgetState();
}

class _UserDetailReviewNewReviewPopupWidgetState
    extends State<UserDetailReviewNewReviewPopupWidget> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isNew = true;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  DateTime? _conductedOn;
  String? _conductedBy;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      isNew = false;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _commentController.dispose();

    super.dispose();
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
          const SizedBox(height: 1),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 4,
            labelText: "Title",
            controller: _titleController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Title is required";
              }
            },
            onTap: () {},
          ),
          DropdownWidget(
            hintText: "Conducted By",
            value: _conductedBy,
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
            controller:
                TextEditingController(text: _conductedOn?.toIso8601String()),
            leftIcon: HeroIcons.calendar,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Date is required";
              }
            },
            onTap: () async {
              DateTime? val = await showDatePicker(
                context: context,
                initialDate: DateTime(2015),
                firstDate: DateTime(1930),
                lastDate: DateTime(2035),
              );
              if (val != null) {
                setState(() {
                  _conductedOn = val;
                });
              }
            },
          ),
          TextInputWidget(
            width: dpWidth / 4,
            enabled: false,
            labelText: "Comment",
            onTap: () {},
            controller: _commentController,
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
            text: isNew ? 'Add Review' : "Save Review",
            onPressed: () {
              formKey.currentState!.validate();
              // context.popRoute();
            },
          ),
        ],
      ),
    );
  }
}
