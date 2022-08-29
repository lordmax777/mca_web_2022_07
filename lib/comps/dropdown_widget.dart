import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mix/mix.dart';

import '../theme/theme.dart';

class DropdownWidget extends StatefulWidget {
  final ValueChanged? onChanged;

  ///Pass the first item of the items list. This param is deprecated
  final dynamic value;
  final List items;
  final HeroIcons? leftIcon;
  String? hintText;
  bool isValueNull = false;
  final double? dropdownBtnWidth;
  final double? dropdownOptionsWidth;
  final bool? showDropdownIcon;
  final double? dropdownMaxHeight;
  final Color? dropdownBtnColor;
  final bool isRequired;
  final bool disableAll;

  /// Dropdown-button-width, Dropdown-Options-Width
  ///  are changeable.
  /// * DO NOT PASS the SAME TEXT in items.
  DropdownWidget(
      {Key? key,
      required this.items,
      this.onChanged,
      this.isRequired = false,
      this.disableAll = false,
      this.value,
      this.leftIcon,
      this.dropdownBtnWidth = 115,
      this.dropdownOptionsWidth = 224,
      this.hintText,
      this.dropdownMaxHeight,
      this.dropdownBtnColor,
      this.showDropdownIcon = true})
      : super(key: key) {
    if (value == null) isValueNull = true;
    hintText ??= "Options";
  }

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.dropdownBtnWidth,
      height: 56,
      child: DropdownButton2(
        itemPadding: EdgeInsets.zero,
        alignment: Alignment.centerLeft,
        underline: const SizedBox(),
        onChanged: widget.disableAll ? null : widget.onChanged,
        isExpanded: true,
        focusColor: ThemeColors.transparent,
        onMenuStateChange: (bool changed) {},
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: ThemeColors.black.withOpacity(0.2),
                offset: const Offset(0, 1),
                blurRadius: 4)
          ],
        ),
        value: widget.value,
        dropdownWidth: widget.dropdownOptionsWidth,
        dropdownMaxHeight: widget.dropdownMaxHeight,
        customButton: Container(
          height: 56,
          padding: const EdgeInsets.only(left: 15.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.dropdownBtnColor ?? ThemeColors.gray11,
              width: widget.dropdownBtnColor == null ? 1.0 : 0.0,
            ),
            // boxShadow: ThemeShadows.shadowSm,
            borderRadius: BorderRadius.circular(18.0),
            color: widget.disableAll
                ? ThemeColors.gray12
                : (widget.dropdownBtnColor ?? ThemeColors.white),
          ),
          child: SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 15,
            children: [
              if (widget.isValueNull)
                ..._buildHint()
              else
                ..._buildSelectedItem(context)
            ],
          ),
        ),
        // itemHeight: 56.h,
        items: _getItems(),
      ),
    );
  }

  List<Widget> _buildHint() {
    return [
      if (widget.leftIcon != null)
        HeroIcon(widget.leftIcon!, color: ThemeColors.gray10),
      if (widget.isValueNull)
        SizedBox(
          width: widget.leftIcon != null
              ? widget.dropdownBtnWidth! - (55 + 55)
              : widget.showDropdownIcon!
                  ? widget.dropdownBtnWidth! - 60
                  : widget.dropdownBtnWidth! - 30,
          child: SpacedRow(
            horizontalSpace: 4.0,
            children: [
              KText(
                text: widget.hintText!,
                isSelectable: false,
                fontSize: 16.0,
                textColor: ThemeColors.gray8,
              ),
              if (widget.isRequired)
                KText(
                  text: "*",
                  isSelectable: false,
                  fontSize: 16.0,
                  textColor: ThemeColors.red3,
                ),
            ],
          ),
        ),
      if (widget.showDropdownIcon!)
        const Align(
            alignment: Alignment.centerRight,
            child: HeroIcon(
              HeroIcons.down,
              color: ThemeColors.gray2,
              size: 15,
            )),
    ];
  }

  List<Widget> _buildSelectedItem(BuildContext ctx) {
    return [
      if (widget.leftIcon != null)
        HeroIcon(widget.leftIcon!, color: ThemeColors.gray10),
      if (!widget.isValueNull)
        SizedBox(
            width: widget.leftIcon != null
                ? widget.dropdownBtnWidth! - (55 + 55)
                : widget.showDropdownIcon!
                    ? widget.dropdownBtnWidth! - 60
                    : widget.dropdownBtnWidth! - 30,
            child: SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpacedRow(
                  horizontalSpace: 4.0,
                  children: [
                    KText(
                      text: widget.hintText!,
                      isSelectable: false,
                      fontSize: 14.0,
                      textColor: widget.disableAll
                          ? ThemeColors.gray8
                          : ThemeColors.gray2,
                    ),
                    if (widget.isRequired)
                      KText(
                        text: "*",
                        isSelectable: false,
                        fontSize: 16.0,
                        textColor: ThemeColors.red3,
                      ),
                  ],
                ),
                KText(
                  text: widget.value.toString(),
                  isSelectable: false,
                  fontSize: 14.0,
                  fontWeight: FWeight.medium,
                  textColor: ThemeColors.gray2,
                ),
              ],
            )),
      if (widget.showDropdownIcon!)
        const Align(
            alignment: Alignment.centerRight,
            child: HeroIcon(
              HeroIcons.down,
              color: ThemeColors.gray2,
              size: 15,
            )),
    ];
  }

  List<DropdownMenuItem<String>> _getItems() {
    List listValues = widget.items;
    List<DropdownMenuItem<String>> _menuItems = [];
    for (int i = 0; i < listValues.length; i++) {
      _menuItems.add(
        DropdownMenuItem<String>(
          value: listValues[i].toString(),
          child: Container(
            decoration: BoxDecoration(
                color: widget.value == listValues[i]
                    ? ThemeColors.blue11
                    : ThemeColors.white,
                border: Border(
                    bottom: BorderSide(
                        width: 1,
                        color: listValues.length - 1 == i
                            ? ThemeColors.transparent
                            : ThemeColors.gray11))),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            height: double.infinity,
            child: KText(
              text: listValues[i].toString(),
              textColor: ThemeColors.black,
              isSelectable: false,
              fontSize: 16.0,
            ),
          ),
        ),
      );
    }

    return _menuItems;
  }
}
