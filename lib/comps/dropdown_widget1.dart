import 'package:dropdown_button2/dropdown_button2.dart';
import '../theme/theme.dart';

class DpItem<T> {
  String name;
  T item;

  Map toJson() => {'name': name, 'item': item};

  DpItem(this.name, this.item);
}

class DropdownWidget1<T> extends StatefulWidget {
  final ValueChanged? onChanged;
  void Function(DpItem)? onChangedWithObj;
  List<T>? objItems;

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
  final bool hasSearchBox;
  final String? Function(String?)? validator;

  /// Dropdown-button-width, Dropdown-Options-Width
  ///  are changeable.
  /// * DO NOT PASS the SAME TEXT in items.
  DropdownWidget1(
      {Key? key,
      required this.items,
      this.onChanged,
      this.objItems,
      this.onChangedWithObj,
      this.validator,
      this.isRequired = false,
      this.disableAll = false,
      this.hasSearchBox = false,
      this.value,
      this.leftIcon,
      this.dropdownBtnWidth = 125,
      this.dropdownOptionsWidth = 224,
      this.hintText,
      this.dropdownMaxHeight = 400.0,
      this.dropdownBtnColor,
      this.showDropdownIcon = true})
      : super(key: key) {
    if (value == null) isValueNull = true;
    hintText ??= "Options";
    objItems ??= [];
  }

  @override
  State<DropdownWidget1> createState() => _DropdownWidget1State<T>();
}

class _DropdownWidget1State<T> extends State<DropdownWidget1> {
  List itemList = [];
  final TextEditingController searchcontroller = TextEditingController();

  bool isError = false;

  bool isOpen = false;

  @override
  void dispose() {
    searchcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      itemList.addAll(widget.items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      width: widget.dropdownBtnWidth,
      child: DropdownButtonFormField2(
        validator: widget.validator ??
            (value) {
              if (widget.isRequired) {
                if (value == null) {
                  setState(() {
                    isError = true;
                  });
                  return "This field is required";
                }
              }
              setState(() {
                isError = false;
              });
              return null;
            },
        onMenuStateChange: (open) {
          setState(() {
            isOpen = open;
          });
        },
        searchInnerWidget: widget.hasSearchBox
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextInputWidget(
                  width: MediaQuery.of(context).size.width,
                  hintText: 'Search',
                  labelText: 'Search',
                  defaultBorderColor: ThemeColors.gray10,
                  controller: searchcontroller,
                ),
              )
            : null,
        searchController: searchcontroller,
        itemPadding: EdgeInsets.zero,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
        ),
        onChanged: widget.disableAll
            ? null
            : widget.onChangedWithObj != null
                ? (value) => widget.onChangedWithObj!(DpItem<T>(
                    value.toString(),
                    widget.objItems![itemList.indexOf(value)]))
                : ((value) {
                    return widget.onChanged != null
                        ? widget.onChanged!(value)
                        : null;
                  }),
        isExpanded: true,
        focusColor: ThemeColors.transparent,
        autofocus: true,
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: ThemeColors.black.withOpacity(0.2),
                offset: const Offset(0, 1),
                blurRadius: 4)
          ],
        ),
        barrierColor: ThemeColors.black.withOpacity(0.1),
        buttonPadding: EdgeInsets.zero,
        value: widget.value != null ? (widget.value as String) : null,
        dropdownWidth: widget.dropdownOptionsWidth,
        dropdownMaxHeight: widget.dropdownMaxHeight,

        customButton: MouseRegion(
          cursor: widget.disableAll
              ? SystemMouseCursors.forbidden
              : (widget.items.isNotEmpty
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic),
          child: Container(
            height: 56,
            padding: const EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: isError
                    ? ThemeColors.red3
                    : isOpen
                        ? ThemeColors.MAIN_COLOR
                        : (widget.dropdownBtnColor ?? ThemeColors.gray11),
                width: isOpen
                    ? 2.0
                    : (widget.dropdownBtnColor == null ? 1.0 : 0.0),
              ),
              borderRadius: BorderRadius.circular(18.0),
              color: (widget.disableAll
                  ? ThemeColors.gray12
                  : (widget.dropdownBtnColor ?? ThemeColors.white)),
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
                      style: ThemeText.bold14,
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
                  fontWeight: FWeight.bold,
                  textColor: ThemeColors.gray2,
                ),
              ],
            )),
      if (widget.showDropdownIcon!)
        AnimatedRotation(
          duration: const Duration(milliseconds: 200),
          turns: !isOpen ? 0 : 0.5,
          child: Align(
              alignment: Alignment.centerRight,
              child: HeroIcon(
                HeroIcons.up,
                color: isOpen ? ThemeColors.MAIN_COLOR : ThemeColors.gray2,
                size: 15,
              )),
        ),
    ];
  }

  List<DropdownMenuItem<String>> _getItems() {
    List listValues = itemList;
    List<DropdownMenuItem<String>> _menuItems = [];
    int len = listValues.length;
    for (int i = 0; i < len; i++) {
      _menuItems.add(
        DropdownMenuItem<String>(
          value: listValues[i].toString(),
          child: Container(
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(14),
              color: widget.value == listValues[i]
                  ? ThemeColors.MAIN_COLOR
                  : ThemeColors.transparent,
            ),
            alignment: Alignment.centerLeft,
            // margin: const EdgeInsets.symmetric(horizontal: 16.0),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            height: double.infinity,
            child: KText(
              text: listValues[i].toString(),
              textColor: widget.value == listValues[i]
                  ? ThemeColors.white
                  : ThemeColors.black,
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
