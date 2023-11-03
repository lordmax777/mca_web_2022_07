import 'package:mca_dashboard/presentation/form/models/dp_item.dart';

class DropdownModel {
  final String name;
  final List<DpItem> items;
  final String? initialValue;
  final String? hintText;
  final String? helperText;
  final bool enabled;
  final bool hasSearchBox;
  final String? Function(String?)? validator;

  const DropdownModel({
    required this.name,
    required this.items,
    this.initialValue,
    this.hintText,
    this.helperText,
    this.enabled = true,
    this.hasSearchBox = false,
    this.validator,
  });
}
