import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mca_web_2022_07/comps/simple_popup_menu.dart';

import '../theme/theme.dart';

class CustomDropdownV3 extends StatefulWidget {
  final List<SimplePopupMenu> menus;
  final double? width;
  final double? height;
  final bool hasSearch;

  const CustomDropdownV3(
      {Key? key,
      required this.menus,
      this.width,
      this.height,
      this.hasSearch = false})
      : super(key: key);

  @override
  State<CustomDropdownV3> createState() => _CustomDropdownV3State();
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _CustomDropdownV3State extends State<CustomDropdownV3> {
  final TextEditingController controller = TextEditingController();
  final List<SimplePopupMenu> backupMenus = [];

  List<SimplePopupMenu> menus = [];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  final _debouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    menus.addAll(List.from(widget.menus));
    backupMenus.addAll(List.from(menus));
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addListener(() {
        // _debouncer.run(() {
        //   if (controller.text.isEmpty) {
        //     setState(() {
        //       menus.clear();
        //       menus.addAll(backupMenus);
        //     });
        //     return;
        //   }
        //   setState(() {
        //     menus.clear();
        //     menus.addAll(backupMenus.where((e) =>
        //         e.label.toLowerCase().contains(controller.text.toLowerCase())));
        //     // Navigator.of(context).pop();
        //     // if (_popupMenuButton().createState().mounted) {
        //     // _popupMenuButton().createState().showButtonMenu();
        //     logger(_popupMenuButton().createState().mounted);
        //     // }
        //   });
        // });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _popupMenuButton();
  }

  PopupMenuButton<String> _popupMenuButton() {
    return PopupMenuButton<String>(
      tooltip: "Dropdown",
      constraints: const BoxConstraints(
        maxHeight: 300,
      ),
      position: PopupMenuPosition.under,
      offset: const Offset(0, 10),
      itemBuilder: (_) => _build(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ThemeColors.gray9),
          borderRadius: BorderRadius.circular(8),
        ),
        width: widget.width ?? 200,
        height: widget.height ?? 40,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 8.0),
        child: const Text(
          "Dropdown",
          style: TextStyle(
            color: ThemeColors.gray2,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  //
  // void showButtonMenu() {
  //   final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
  //   final RenderBox button = context.findRenderObject()! as RenderBox;
  //   final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
  //   final Offset offset;
  //   switch (widget.position) {
  //     case PopupMenuPosition.over:
  //       offset = widget.offset;
  //       break;
  //     case PopupMenuPosition.under:
  //       offset = Offset(0.0, button.size.height - (widget.padding.vertical / 2)) + widget.offset;
  //       break;
  //   }
  //   final RelativeRect position = RelativeRect.fromRect(
  //     Rect.fromPoints(
  //       button.localToGlobal(offset, ancestor: overlay),
  //       button.localToGlobal(button.size.bottomRight(Offset.zero) + offset, ancestor: overlay),
  //     ),
  //     Offset.zero & overlay.size,
  //   );
  //   final List<PopupMenuEntry<T>> items = widget.itemBuilder(context);
  //   // Only show the menu if there is something to show
  //   if (items.isNotEmpty) {
  //     showMenu<T?>(
  //       context: context,
  //       elevation: widget.elevation ?? popupMenuTheme.elevation,
  //       items: items,
  //       initialValue: widget.initialValue,
  //       position: position,
  //       shape: widget.shape ?? popupMenuTheme.shape,
  //       color: widget.color ?? popupMenuTheme.color,
  //       constraints: widget.constraints,
  //     )
  //         .then<void>((T? newValue) {
  //       if (!mounted) {
  //         return null;
  //       }
  //       if (newValue == null) {
  //         widget.onCanceled?.call();
  //         return null;
  //       }
  //       widget.onSelected?.call(newValue);
  //     });
  //   }
  // }
  //

  List<PopupMenuItem<String>> _build() {
    final List<PopupMenuItem<String>> list = [
      if (widget.hasSearch) _buildSearch(),
    ];

    for (final e in menus) {
      list.add(_buildItem(e));
    }

    return list;
  }

  PopupMenuItem<String> _buildItem(SimplePopupMenu e) {
    return PopupMenuItem<String>(
      value: e.label,
      padding: const EdgeInsets.all(0),
      height: 36,
      enabled: false,
      child: InkWell(
        onTap: e.onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  color: menus.last == e
                      ? ThemeColors.transparent
                      : ThemeColors.gray10),
            ),
          ),
          padding: const EdgeInsets.only(left: 8.0),
          alignment: Alignment.centerLeft,
          height: 36,
          child: Text(
            e.label,
            style: const TextStyle(
              color: ThemeColors.gray2,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildSearch() {
    return PopupMenuItem<String>(
      value: "Search",
      padding: const EdgeInsets.all(0),
      height: 36,
      enabled: false,
      child: TextFormField(
        autofocus: true,
        // controller: controller,
        onChanged: (value) {
          _debouncer.run(() {
            if (controller.text.isEmpty) {
              setState(() {
                menus.clear();
                menus.addAll(backupMenus);
              });
              return;
            }
            setState(() {
              menus.clear();
              menus.addAll(backupMenus.where((e) => e.label
                  .toLowerCase()
                  .contains(controller.text.toLowerCase())));
              // Navigator.of(context).pop();
              // if (_popupMenuButton().createState().mounted) {
              // _popupMenuButton().createState().showButtonMenu();
              logger(_popupMenuButton().createState().mounted);
              // }
            });
          });
        },
        decoration: const InputDecoration(
          constraints: const BoxConstraints(
            maxHeight: 40,
          ),
          hintText: "Search",
          hintStyle: const TextStyle(
            color: ThemeColors.gray2,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: ThemeColors.gray9,
          )),
          contentPadding: const EdgeInsets.only(left: 8.0),
        ),
      ),
    );
  }
}
