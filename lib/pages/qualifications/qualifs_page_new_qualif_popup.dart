import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../theme/theme.dart';

class QualifsNewQualifPopupWidget extends StatefulWidget {
  const QualifsNewQualifPopupWidget({Key? key}) : super(key: key);

  @override
  State<QualifsNewQualifPopupWidget> createState() =>
      _QualifsNewQualifPopupWidgetState();
}

class _QualifsNewQualifPopupWidgetState
    extends State<QualifsNewQualifPopupWidget> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  bool hasExpire = false;
  bool hasLevels = false;
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
            text: 'New Qualification',
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
        verticalSpace: 24.0,
        children: [
          const SizedBox(height: 1),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
            labelText: "Qualification Name",
            controller: _nameController,
            onTap: () {},
          ),
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              CheckboxWidget(
                value: hasExpire,
                onChanged: (value) {
                  setState(() {
                    hasExpire = value!;
                  });
                },
              ),
              KText(
                text: "Qualification has expiry date",
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                isSelectable: false,
                fontWeight: FWeight.bold,
              )
            ],
          ),
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              CheckboxWidget(
                value: hasLevels,
                onChanged: (value) {
                  setState(() {
                    hasLevels = value!;
                  });
                },
              ),
              KText(
                text: "Qualification has levels",
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                isSelectable: false,
                fontWeight: FWeight.bold,
              )
            ],
          ),
          TextInputWidget(
            width: dpWidth / 5,
            labelText: "Comment",
            controller: _notesController,
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
            icon: const HeroIcon(HeroIcons.check,
                color: ThemeColors.white, size: 20.0),
            text: 'Add Qualification',
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // context.popRoute();
              }
            },
          ),
        ],
      ),
    );
  }
}
