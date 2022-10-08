import 'package:auto_route/auto_route.dart';

import '../../theme/theme.dart';

class StocksNewItemPopupWidget extends StatefulWidget {
  const StocksNewItemPopupWidget({Key? key}) : super(key: key);

  @override
  State<StocksNewItemPopupWidget> createState() =>
      _DepartmentsNewDepWidgetState();
}

class _DepartmentsNewDepWidgetState extends State<StocksNewItemPopupWidget> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _depNameController = TextEditingController();
  final TextEditingController _ourPriceController = TextEditingController();
  final TextEditingController _customPriceController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  @override
  void dispose() {
    _depNameController.dispose();
    _ourPriceController.dispose();

    _customPriceController.dispose();
    _taxController.dispose();
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
            text: 'New Item',
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
            width: dpWidth / 5,
            labelText: "Item Name",
            controller: _depNameController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Item name is required";
              }
              return null;
            },
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            labelText: "Our Price",
            rightIcon: HeroIcons.pound,
            keyboardType: TextInputType.number,
            controller: _ourPriceController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Price is required";
              }
              return null;
            },
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            rightIcon: HeroIcons.pound,
            keyboardType: TextInputType.number,
            labelText: "Customer Price",
            controller: _customPriceController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Price is required";
              }
              return null;
            },
          ),
          TextInputWidget(
            isRequired: true,
            width: dpWidth / 5,
            rightIcon: HeroIcons.percent,
            keyboardType: TextInputType.number,
            labelText: "Tax",
            controller: _taxController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Tax is required";
              }
              return null;
            },
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
            icon: const HeroIcon(HeroIcons.check, size: 20.0),
            text: 'Add Item',
            onPressed: () {
              if (formKey.currentState!.validate()) {}
            },
          ),
        ],
      ),
    );
  }
}
