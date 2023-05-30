import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mca_web_2022_07/theme/colors.dart';
import 'package:mca_web_2022_07/theme/text_style.dart';
import 'package:multiselect_dropdown_flutter/multiselect_dropdown_flutter.dart';
import 'package:select2dot1/select2dot1.dart';

import '../utils/log_tester.dart';

import 'package:equatable/equatable.dart';

class MultiSelectGroup extends Equatable {
  final List<MultiSelectItem> items;
  final String label;
  late String id;

  MultiSelectGroup({required this.items, this.label = ""}) {
    id = "item_cat_$label";
    for (final item in items) {
      id += "_${item.id}";
    }
  }

  SingleCategoryModel toGroup() {
    return SingleCategoryModel(
      nameCategory: label.isEmpty ? null : label,
      singleItemCategoryList: items.map((e) => e.toItem()).toList(),
    );
  }

  @override
  List<Object?> get props => [items, label, id];
}

class MultiSelectItem extends Equatable {
  final String label;
  final String id;
  final String? extraInfo;

  const MultiSelectItem(
      {required this.label, required this.id, this.extraInfo});

  SingleItemCategoryModel toItem() {
    return SingleItemCategoryModel(
      nameSingleItem: label,
      extraInfoSingleItem: extraInfo,
      value: id,
    );
  }

  factory MultiSelectItem.fromItem(SingleItemCategoryModel item) {
    return MultiSelectItem(
      label: item.nameSingleItem,
      id: item.value,
      extraInfo: item.extraInfoSingleItem,
    );
  }

  @override
  List<Object?> get props => [label, id, extraInfo];
}

class CustomMultiSelectDropdown extends StatefulWidget {
  final List<MultiSelectGroup> items;
  final List<MultiSelectGroup>? initiallySelected;
  final double? width;
  final bool hasSearchBox;
  final bool isMultiSelect;
  final ValueChanged<List<MultiSelectItem>>? onChange;
  const CustomMultiSelectDropdown({
    super.key,
    required this.items,
    this.initiallySelected,
    this.onChange,
    this.width,
    this.hasSearchBox = false,
    this.isMultiSelect = false,
  });

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  late SelectDataController source;
  final List<MultiSelectGroup> oldItems = [];

  List<MultiSelectGroup> get initiallySelected =>
      widget.initiallySelected ?? [];
  List<MultiSelectGroup> get items => widget.items;
  double? get width => widget.width;
  bool get hasSearchBox => widget.hasSearchBox;
  bool get isMultiSelect => widget.isMultiSelect;

  @override
  void initState() {
    super.initState();
    source = SelectDataController(
      data: toCategory(items),
      isMultiSelect: isMultiSelect,
    );
    oldItems.addAll(items);
  }

  @override
  void didUpdateWidget(covariant CustomMultiSelectDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!const ListEquality().equals(oldItems, items)) {
      source.data
        ..clear()
        ..addAll(toCategory(items));
      oldItems
        ..clear()
        ..addAll(items);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Select2dot1(
        onChanged: (value) {
          final selectedGroups =
              value.map((e) => MultiSelectItem.fromItem(e)).toList();
          widget.onChange?.call(selectedGroups);
        },
        globalSettings: GlobalSettings(
          mainColor: ThemeColors.MAIN_COLOR,
          fontFamily: ThemeText.fontFamilyR,
        ),
        isSearchable: hasSearchBox,
        selectDataController: source,
        selectEmptyInfoSettings: const SelectEmptyInfoSettings(
          text: "Select",
        ),
        selectChipSettings: SelectChipSettings(
          iconColor: ThemeColors.MAIN_COLOR,
          chipDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(
              width: 2,
              color: ThemeColors.MAIN_COLOR,
            ),
          ),
        ),
      ),
    );
  }

  List<SingleCategoryModel> toCategory(List<MultiSelectGroup> groups) {
    return groups.map((e) => e.toGroup()).toList();
  }
}
