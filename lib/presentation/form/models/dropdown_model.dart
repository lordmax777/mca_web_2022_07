import 'package:mca_dashboard/presentation/form/models/dp_item.dart';

class DropdownModel {
  final String name;
  final List<DpItem> items;
  final String? initialValue;
  final String? hintText;
  final String? helperText;
  final String? labelText;
  final bool enabled;
  final bool hasSearchBox;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const DropdownModel({
    required this.name,
    required this.items,
    this.initialValue,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.helperText,
    this.enabled = true,
    this.hasSearchBox = false,
    this.validator,
  });
}
