import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/utils.dart';

class DefaultDropdownMenu extends StatelessWidget {
  final List<DefaultMenuItem> items;
  final ValueChanged<DefaultMenuItem> onSelected;
  final DefaultMenuItem? initialValue;
  final String? label;
  final double? width;
  final TextEditingController? controller;
  final bool isLoading;
  const DefaultDropdownMenu(
      {super.key,
      required this.items,
      required this.onSelected,
      this.label,
      this.isLoading = false,
      this.controller,
      this.width,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      width: width,
      menuHeight: 300,
      controller: controller,
      textStyle: const TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
      initialSelection: initialValue,
      dropdownMenuEntries: getItems(),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 16),
      ),
      // label: label != null ? Text(label!) : null,
      hintText: label,
      leadingIcon: isLoading ? const CircularProgressIndicator() : null,
      trailingIcon: const SizedBox(),
      selectedTrailingIcon: const SizedBox(),
      onSelected: (value) {
        if (value != null) {
          onSelected(value);
        }
      },
    );
  }

  List<DropdownMenuEntry<DefaultMenuItem>> getItems() {
    return items.map<DropdownMenuEntry<DefaultMenuItem>>((e) {
      return DropdownMenuEntry(
        value: e,
        label: "${e.title}${e.subtitle != null ? " - [${e.subtitle}]" : ""}",
      );
    }).toList();
  }
}
