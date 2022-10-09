import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import '../../comps/dropdown_widget1.dart';
import '../../theme/theme.dart';

class HandsNewHandoverPopupWidget extends StatefulWidget {
  const HandsNewHandoverPopupWidget({Key? key}) : super(key: key);

  @override
  State<HandsNewHandoverPopupWidget> createState() =>
      _HandsNewHandoverPopupWidgetState();
}

class _HandsNewHandoverPopupWidgetState
    extends State<HandsNewHandoverPopupWidget> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  CodeMap status = CodeMap(name: null, code: null);

  @override
  void dispose() {
    _nameController.dispose();
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
            text: 'New Handover',
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
    final List<CodeMap> statuses = [
      CodeMap(name: 'Active', code: '0'),
      CodeMap(name: 'Inactive', code: '1'),
    ];
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
            labelText: "Handover Name",
            controller: _nameController,
            onTap: () {},
          ),
          DropdownWidget1<CodeMap>(
            hintText: "Status",
            value: status.name,
            dropdownBtnWidth: dpWidth / 5,
            isRequired: true,
            dropdownOptionsWidth: dpWidth / 5,
            dropdownMaxHeight: 400.0,
            hasSearchBox: true,
            objItems: statuses,
            onChangedWithObj: (value) {
              setState(() {
                status = CodeMap(code: value.item.code, name: value.name);
              });
            },
            items: statuses.map((e) => e.name).toList(),
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
            icon: const HeroIcon(HeroIcons.check,
                color: ThemeColors.white, size: 20.0),
            text: 'Add Warehouse',
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
