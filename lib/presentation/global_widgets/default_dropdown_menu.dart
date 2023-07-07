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
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: BorderSide(color: context.colorScheme.primary)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(color: Colors.red),
        labelStyle: const TextStyle(color: Colors.grey),
      ),
      initialSelection: initialValue,
      dropdownMenuEntries: getItems(),
      label: label != null ? Text(label!) : null,
      leadingIcon: isLoading ? const CircularProgressIndicator() : null,
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
