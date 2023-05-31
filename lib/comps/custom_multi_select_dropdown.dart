import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:equatable/equatable.dart';

class MultiSelectGroup extends Equatable {
  final List<MultiSelectItem> items;
  final String label;

  const MultiSelectGroup({required this.items, this.label = ""});

  SingleCategoryModel toGroup([bool isMultiSelect = false]) {
    return SingleCategoryModel(
      nameCategory: !isMultiSelect ? null : (label.isEmpty ? null : label),
      singleItemCategoryList: items.map((e) => e.toItem()).toList(),
    );
  }

  @override
  List<Object?> get props => [items, label];
}

class MultiSelectItem extends Equatable {
  final String label;
  final String? extraInfo;
  final String id;

  const MultiSelectItem(
      {required this.label, this.extraInfo, required this.id});

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
      extraInfo: item.extraInfoSingleItem,
      id: item.value,
    );
  }

  @override
  List<Object?> get props => [label, extraInfo, id];
}

typedef MultiSelectOnChange = void Function(Ret res);

class CustomMultiSelectDropdown extends StatefulWidget {
  final List<MultiSelectGroup> items;
  final List<MultiSelectItem>? initiallySelected;
  final double? width;
  final bool hasSearchBox;
  final bool isMultiSelect;
  final MultiSelectOnChange? onChange;
  final MultiSelectItem Function()? onItemRemove;
  final MultiSelectItem Function()? onItemAdd;
  const CustomMultiSelectDropdown({
    super.key,
    required this.items,
    this.initiallySelected,
    this.onItemAdd,
    this.onItemRemove,
    this.onChange,
    this.width,
    this.hasSearchBox = false,
    this.isMultiSelect = false,
  });

  @override
  State<CustomMultiSelectDropdown> createState() =>
      _CustomMultiSelectDropdownState();
}

enum RetAction {
  empty,
  add,
  remove;
}

class Ret extends Equatable {
  final String? removeId;
  final String? addId;
  late final RetAction action;

  Ret({this.removeId, required this.addId}) {
    //Empty list
    if (removeId == null && addId == null) {
      action = RetAction.empty;
      return;
    }

    //Remove something
    if (removeId != null && addId == null) {
      action = RetAction.remove;
      return;
    }

    //Add list
    if (removeId == null && addId != null) {
      action = RetAction.add;
      return;
    }
  }

  @override
  List<Object?> get props => [removeId, addId, action];
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  late SelectDataController source;
  final List<MultiSelectGroup> oldItems = [];

  List<MultiSelectItem>? get initiallySelected => widget.initiallySelected;
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
      initSelected: initiallySelected
          ?.map<SingleItemCategoryModel>((e) => e.toItem())
          .toList(),
    );
    oldItems.addAll(items);
    if (initiallySelected != null) {
      oldIds.addAll(initiallySelected!.map((e) => e.id).toList());
    }
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
      source.initSelected?.clear();
      if (initiallySelected != null) {
        source.initSelected?.addAll(
            initiallySelected!.map<SingleItemCategoryModel>((e) => e.toItem()));
      }
      oldIds.clear();
    }
    if (widget.onItemRemove != null) {
      source.removeSingleSelectedChip(widget.onItemRemove!().toItem());
    }
    if (widget.onItemAdd != null) {
      source.addSelectChip(widget.onItemAdd!().toItem());
    }
  }

  @override
  void dispose() {
    source.dispose();
    super.dispose();
  }

  String? addedId;
  String? removedId;
  final List<String> oldIds = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Select2dot1(
        onChanged: (list) {
          if (list.isEmpty) {
            addedId = null;
            removedId = null;
            oldIds.clear();
            widget.onChange?.call(Ret(removeId: null, addId: null));
            return;
          }

          final selected = list
              .map<MultiSelectItem>((e) => MultiSelectItem.fromItem(e))
              .toList();

          final ids = selected.map((e) => e.id).toList();
          bool isRemove = false;
          for (final id in oldIds) {
            if (!ids.contains(id)) {
              removedId = id;
              ids.remove(id);
              isRemove = true;
              break;
            }
          }
          if (isRemove) {
            addedId = null;
          } else {
            removedId = null;
            addedId = ids.last;
          }
          widget.onChange?.call(Ret(removeId: removedId, addId: addedId));
          addedId = null;
          removedId = null;
          oldIds.clear();
          oldIds.addAll(ids);
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
        dropdownOverlaySettings: const DropdownOverlaySettings(
          maxHeight: 300,
          animationDuration: Duration.zero,
        ),
        pillboxContentMultiSettings: const PillboxContentMultiSettings(
          pillboxOverload: 2,
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
    return groups.map((e) => e.toGroup(isMultiSelect)).toList();
  }
}
