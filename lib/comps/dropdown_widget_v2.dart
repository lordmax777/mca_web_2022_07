import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import '../theme/theme.dart';

// ignore: must_be_immutable
class DropdownWidgetV2 extends StatefulWidget {
  final ValueChanged<int>? onChanged;

  /// DpItem.name => returns the selected name from items list
  ///
  /// DpItem.item => returns the selected item from objItems list with type of T

  ///Pass the first item of the items list. This param is deprecated
  final CustomDropdownValue? value;
  final List<CustomDropdownValue> items;
  final Widget? leftIcon;
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
  final String? Function(CustomDropdownValue?)? validator;
  final Map<int, HeroIcons>? customItemIcons;
  final String? tooltipWhileDisabled;

  /// Dropdown-button-width, Dropdown-Options-Width
  ///  are changeable.
  /// * DO NOT PASS the SAME TEXT in items.
  DropdownWidgetV2(
      {Key? key,
      required this.items,
      this.onChanged,
      this.customItemIcons,
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
      this.showDropdownIcon = true,
      this.tooltipWhileDisabled})
      : super(key: key) {
    // if (value == null) {
    isValueNull = value == null || value!.name == null || value!.name!.isEmpty
        ? true
        : false;
    // }
    ;
    hintText ??= "";
  }

  @override
  State<DropdownWidgetV2> createState() => _DropdownWidgetV2State();
}

class _DropdownWidgetV2State extends State<DropdownWidgetV2> {
  List<CustomDropdownValue> itemList = [];
  final TextEditingController searchController = TextEditingController();

  bool isError = false;

  bool isOpen = false;

  String? get tooltip =>
      widget.tooltipWhileDisabled != null && widget.disableAll
          ? widget.tooltipWhileDisabled
          : null;

  @override
  void dispose() {
    searchController.dispose();
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
  void didUpdateWidget(covariant DropdownWidgetV2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    itemList.clear();
    setState(() {
      itemList.addAll(widget.items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      width: widget.dropdownBtnWidth,
      child: Tooltip(
        message: tooltip ?? "",
        child: DropdownButtonFormField2<CustomDropdownValue>(
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
                  padding:
                      const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  child: TextInputWidget(
                    width: MediaQuery.of(context).size.width,
                    hintText: 'Search',
                    labelText: 'Search',
                    defaultBorderColor: ThemeColors.gray10,
                    controller: searchController,
                  ),
                )
              : null,
          // searchInnerWidgetHeight: widget.hasSearchBox ? 56 : null,
          searchController: searchController,
          itemPadding: EdgeInsets.zero,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
          onChanged: widget.disableAll
              ? null
              : (val) {
                  widget.onChanged?.call(itemList.indexOf(val!));
                },
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
          value: widget.value != null
              ? widget.value!.name != null
                  ? widget.value!.name!.isNotEmpty
                      ? widget.value
                      : null
                  : null
              : null,
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
                          : (widget.dropdownBtnColor ?? ThemeColors.gray10),
                  width: isOpen
                      ? 1.0
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
      ),
    );
  }

  List<Widget> _buildHint() {
    return [
      if (widget.leftIcon != null) widget.leftIcon!,
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
      if (widget.leftIcon != null) widget.leftIcon!,
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
                // if (widget.hintText != null && widget.hintText!.isNotEmpty)
                //   SpacedRow(
                //     horizontalSpace: 4.0,
                //     children: [
                //       KText(
                //         text: widget.hintText!,
                //         isSelectable: false,
                //         style: ThemeText.bold14,
                //         fontSize: 14.0,
                //         textColor: widget.disableAll
                //             ? ThemeColors.gray8
                //             : ThemeColors.gray2,
                //       ),
                //       if (widget.isRequired)
                //         KText(
                //           text: "*",
                //           isSelectable: false,
                //           fontSize: 16.0,
                //           textColor: ThemeColors.red3,
                //         ),
                //     ],
                //   ),
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

  List<DropdownMenuItem<CustomDropdownValue>> _getItems() {
    List<CustomDropdownValue> listValues = itemList;
    List<DropdownMenuItem<CustomDropdownValue>> menuItems = [];
    int len = listValues.length;
    for (int i = 0; i < len; i++) {
      menuItems.add(
        DropdownMenuItem<CustomDropdownValue>(
          // enabled: false,
          onTap: () {
            searchController.clear();
          },
          value: listValues[i],
          child: InkWell(
            // onTap: widget.disableAll
            //     ? null
            //     : () {
            //         widget.onChanged?.call(itemList.indexOf(listValues[i]));
            //       },
            child: Container(
              decoration: BoxDecoration(
                color: widget.value == listValues[i]
                    ? ThemeColors.MAIN_COLOR
                    : ThemeColors.transparent,
                border: const Border(
                  bottom: BorderSide(
                    color: ThemeColors.gray10,
                    width: 1.0,
                  ),
                ),
              ),
              alignment: Alignment.centerLeft,
              // margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              height: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: widget.dropdownBtnWidth! - 60,
                    child: KText(
                      maxLines: 2,
                      text: listValues[i].toString(),
                      textColor: widget.value == listValues[i]
                          ? ThemeColors.white
                          : ThemeColors.black,
                      isSelectable: false,
                      fontSize: 16.0,
                    ),
                  ),
                  if (widget.customItemIcons?[i] != null)
                    HeroIcon(
                      widget.customItemIcons![i]!,
                      color: widget.value == listValues[i]
                          ? ThemeColors.white
                          : ThemeColors.black,
                    )
                ],
              ),
            ),
          ),
        ),
      );
    }

    return menuItems;
  }
}

class CustomDropdownValue {
  final String? name;
  CustomDropdownValue({required this.name});

  @override
  String toString() {
    return name.toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomDropdownValue && other.name == name;
  }

  @override
  int get hashCode => name.hashCode + Random().nextInt(100);
}

class CustomDropdownViewOptions {
  final double? dropdownBtnWidth;
  final double? dropdownOptionsMaxHeight;
  final HeroIcons? leftIcon;
  final Color? dropdownBtnColor;
  final bool showDropdownIcon;

  const CustomDropdownViewOptions({
    this.dropdownBtnWidth = 125,
    this.dropdownOptionsMaxHeight = 400,
    this.leftIcon,
    this.dropdownBtnColor,
    this.showDropdownIcon = true,
  });
}

class CustomDropdownStateOptions {
  final bool disableAll;
  final bool hasSearchBox;
  final bool isRequired;
  final String? tooltipOnDisabledState;
  final String? Function(String?)? validator;

  const CustomDropdownStateOptions({
    this.disableAll = false,
    this.hasSearchBox = false,
    this.isRequired = false,
    this.tooltipOnDisabledState,
    this.validator,
  });
}
//
// class CustomDropdownButton extends StatefulWidget {
//   final List<CustomDropdownValue> items;
//   final CustomDropdownValue? value;
//   final void Function(int) onSelected;
//   final String? hintText;
//   final CustomDropdownViewOptions? viewOptions;
//   final CustomDropdownStateOptions? stateOptions;
//
//   const CustomDropdownButton({
//     Key? key,
//     this.value,
//     required this.items,
//     required this.onSelected,
//     this.hintText,
//     this.viewOptions = const CustomDropdownViewOptions(),
//     this.stateOptions = const CustomDropdownStateOptions(),
//   }) : super(key: key);
//
//   @override
//   State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
// }
//
// class _CustomDropdownButtonState extends State<CustomDropdownButton> {
//   CustomDropdownStateOptions get stateOptions => widget.stateOptions!;
//   CustomDropdownViewOptions get viewOptions => widget.viewOptions!;
//   List<CustomDropdownValue> items = [];
//   CustomDropdownValue? get value =>
//       widget.value != null && items.isNotEmpty && widget.value!.name.isNotEmpty
//           ? widget.value
//           : null;
//
//   final TextEditingController searchController = TextEditingController();
//
//   bool isError = false;
//
//   String? get tooltip => stateOptions.tooltipOnDisabledState != null &&
//           stateOptions.tooltipOnDisabledState!.isNotEmpty
//       ? stateOptions.tooltipOnDisabledState
//       : null;
//
//   @override
//   void initState() {
//     super.initState();
//     items = widget.items;
//     if (stateOptions.hasSearchBox) {
//       searchController.addListener(searchListener);
//     }
//   }
//
//   void searchListener() {
//     final String text = searchController.text.toLowerCase();
//     setState(() {
//       items = widget.items
//           .where((element) => element.name.toLowerCase().contains(text))
//           .toList();
//     });
//   }
//
//   @override
//   void didUpdateWidget(covariant CustomDropdownButton oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     searchController.removeListener(searchListener);
//     searchController.addListener(searchListener);
//     setState(() {
//       items = widget.items;
//     });
//   }
//
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton(
//       splashRadius: 0,
//       enableFeedback: false,
//       position: PopupMenuPosition.under,
//       tooltip: tooltip ?? "",
//       onSelected: (value) {
//         widget.onSelected(items.indexOf(value as CustomDropdownValue));
//       },
//       onCanceled: () {
//         searchController.clear();
//         items = widget.items;
//       },
//       offset: const Offset(-10, 10),
//       itemBuilder: getItems,
//       child: MouseRegion(
//         cursor: stateOptions.disableAll
//             ? SystemMouseCursors.forbidden
//             : (items.isNotEmpty
//                 ? SystemMouseCursors.click
//                 : SystemMouseCursors.basic),
//         child: Container(
//           height: 56,
//           width: viewOptions.dropdownBtnWidth! + 2,
//           margin: const EdgeInsets.only(top: 7),
//           padding: const EdgeInsets.symmetric(horizontal: 15.0),
//           decoration: BoxDecoration(
//             border: Border.all(
//               color: isError
//                   ? ThemeColors.red3
//                   : (viewOptions.dropdownBtnColor ?? ThemeColors.gray10),
//               width: (viewOptions.dropdownBtnColor == null ? 1.0 : 0.0),
//             ),
//             borderRadius: BorderRadius.circular(18.0),
//             color: (stateOptions.disableAll
//                 ? ThemeColors.gray12
//                 : (viewOptions.dropdownBtnColor ?? ThemeColors.white)),
//           ),
//           child: SpacedRow(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             horizontalSpace: 15,
//             children: [
//               if (value == null)
//                 ..._buildHint()
//               else
//                 ..._buildSelectedItem(context)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   List<PopupMenuEntry<CustomDropdownValue>> getItems(BuildContext context) {
//     final List<PopupMenuEntry<CustomDropdownValue>> menuItems = [];
//     logger("items ${items.map((e) => e.name).toList()}}");
//     int len = items.length;
//     if (items.isNotEmpty) {
//       if (stateOptions.hasSearchBox) len += 1;
//       for (int i = 0; i < len; i++) {
//         if (stateOptions.hasSearchBox && i == 0) {
//           menuItems.add(
//             PopupMenuItem<CustomDropdownValue>(
//                 enabled: false,
//                 height: 56,
//                 child: SizedBox(
//                     width: viewOptions.dropdownBtnWidth!,
//                     child: TextInputWidget(
//                       width: MediaQuery.of(context).size.width,
//                       hintText: 'Search',
//                       labelText: 'Search',
//                       defaultBorderColor: ThemeColors.gray10,
//                       controller: searchController,
//                     ))),
//           );
//           continue;
//         }
//         final item = items[i - 1];
//         final isSelected = value == item;
//         menuItems.add(
//           PopupMenuItem<CustomDropdownValue>(
//               height: 56,
//               textStyle: TextStyle(
//                 fontSize: 16,
//                 color: isSelected ? ThemeColors.MAIN_COLOR : ThemeColors.black,
//               ),
//               value: item,
//               child: SizedBox(
//                   width: viewOptions.dropdownBtnWidth!,
//                   child: Text(item.name))),
//         );
//       }
//     }
//     return menuItems;
//   }
//
//   List<Widget> _buildHint() {
//     return [
//       if (viewOptions.leftIcon != null)
//         HeroIcon(viewOptions.leftIcon!, color: ThemeColors.gray10),
//       SizedBox(
//         width: viewOptions.leftIcon != null
//             ? viewOptions.dropdownBtnWidth! - (55 + 55)
//             : viewOptions.showDropdownIcon
//                 ? viewOptions.dropdownBtnWidth! - 60
//                 : viewOptions.dropdownBtnWidth! - 30,
//         child: SpacedRow(
//           horizontalSpace: 4.0,
//           children: [
//             KText(
//               text: widget.hintText!,
//               isSelectable: false,
//               fontSize: 16.0,
//               textColor: ThemeColors.gray8,
//             ),
//             if (stateOptions.isRequired)
//               KText(
//                 text: "*",
//                 isSelectable: false,
//                 fontSize: 16.0,
//                 textColor: ThemeColors.red3,
//               ),
//           ],
//         ),
//       ),
//       if (viewOptions.showDropdownIcon)
//         const Align(
//             alignment: Alignment.centerRight,
//             child: HeroIcon(
//               HeroIcons.down,
//               color: ThemeColors.gray2,
//               size: 15,
//             )),
//     ];
//   }
//
//   List<Widget> _buildSelectedItem(BuildContext ctx) {
//     return [
//       if (widget.value != null)
//         KText(
//           text: widget.value?.name.toString(),
//           isSelectable: false,
//           fontSize: 14.0,
//           fontWeight: FWeight.bold,
//           textColor: ThemeColors.gray2,
//         ),
//       const Spacer(),
//       if (viewOptions.showDropdownIcon)
//         const HeroIcon(
//           HeroIcons.up,
//           color: ThemeColors.gray2,
//           size: 15,
//         ),
//     ];
//   }
// }
