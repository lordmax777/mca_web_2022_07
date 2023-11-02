import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mca_dashboard/presentation/form/models/dp_item.dart';
import 'package:mca_dashboard/presentation/form/models/dropdown_model.dart';
import 'package:mca_dashboard/utils/utils.dart';

import '../../global_widgets/widgets.dart';

class FormDropdown extends StatelessWidget {
  final DropdownModel vm;
  FormDropdown({super.key, required this.vm})
      : assert(vm.items.isNotEmpty, "Items cannot be empty");

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: vm.name,
      validator: vm.validator,
      enabled: vm.enabled,
      initialValue: vm.initialValue,
      builder: (FormFieldState<String> state) {
        return DefaultDropdown2(state: state, vm: vm);
      },
    );
  }
}

class DefaultDropdown2 extends StatefulWidget {
  final FormFieldState<String> state;
  final DropdownModel vm;

  const DefaultDropdown2({super.key, required this.state, required this.vm});

  @override
  State<DefaultDropdown2> createState() => _DefaultDropdown2State();
}

class _DefaultDropdown2State extends State<DefaultDropdown2> {
  final TextEditingController searchController = TextEditingController();

  DropdownModel get vm => widget.vm;
  FormFieldState<String> get state => widget.state;
  String? get errorText => state.errorText;

  DpItem? get selectedItem =>
      vm.items.firstWhereOrNull((element) => element.id == state.value);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<DpItem>(
        value: vm.initialValue != null
            ? vm.items
                .firstWhereOrNull((element) => element.id == vm.initialValue)
            : null,
        isExpanded: true,
        dropdownSearchData: vm.hasSearchBox
            ? DropdownSearchData(
                searchController: searchController,
                searchInnerWidgetHeight: 48,
                searchInnerWidget: Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                  child: TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(hintText: "Search")),
                ),
                searchMatchFn: (item, searchValue) {
                  bool found = false;
                  if (item.value?.title
                          .toLowerCase()
                          .contains(searchValue.toLowerCase()) ??
                      false) {
                    found = true;
                  }
                  return found;
                },
              )
            : null,
        customButton: InputDecorator(
            decoration: InputDecoration(
              border: InputBorder.none,
              errorText: errorText,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (selectedItem != null)
                    SizedBox(
                      width: constraints.maxWidth - 48,
                      child: RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: selectedItem!.title,
                                  style: const TextStyle(color: Colors.black)),
                              if (selectedItem!.subtitle != null)
                                if (selectedItem!.subtitle != null)
                                  TextSpan(
                                      text: " / ${selectedItem!.subtitle}",
                                      style:
                                          const TextStyle(color: Colors.grey)),
                            ],
                          )),
                    )
                  else
                    Text(vm.hintText ?? "",
                        // (vm.items.isNotEmpty ? vm.items.first.title : ""),
                        style: TextStyle(color: Colors.grey.shade500)),
                  const Icon(Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey),
                ],
              );
            })),
        dropdownStyleData: DropdownStyleData(
          offset: const Offset(0, -10),
          elevation: 10,
          maxHeight: vm.hasSearchBox ? 300 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[400]!),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          selectedMenuItemBuilder: (context, child) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: context.colorScheme.primary.withOpacity(0.1),
              ),
              child: child,
            );
          },
        ),
        underline: const SizedBox(),
        // selectedItemBuilder: (context) {
        //   return vm.items
        //       .map((e) => Align(
        //             alignment: Alignment.centerLeft,
        //             child: RichText(
        //                 overflow: TextOverflow.ellipsis,
        //                 maxLines: 2,
        //                 softWrap: true,
        //                 text: TextSpan(children: [
        //                   TextSpan(
        //                       text:
        //                           "${GlobalConstants.enableDebugCodes ? "[${e.id}] - " : ""}${e.title}",
        //                       style: Theme.of(context)
        //                           .textTheme
        //                           .bodyLarge!
        //                           .copyWith()),
        //                   if (e.subtitle != null)
        //                     TextSpan(
        //                         text: " / ${e.subtitle}",
        //                         style: const TextStyle(color: Colors.grey)),
        //                 ])),
        //           ))
        //       .toList();
        // },
        items: getItems(),
        onChanged: (value) {
          state.didChange(value?.id);
        });
  }

  List<DropdownMenuItem<DpItem>> getItems() {
    return vm.items.map<DropdownMenuItem<DpItem>>((e) {
      return DropdownMenuItem<DpItem>(
        value: e,
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${GlobalConstants.enableDebugCodes ? "[${e.id}] - " : ""}${e.title}",
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
            if (e.subtitle != null)
              Text(e.subtitle!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  softWrap: false,
                  overflow: TextOverflow.ellipsis),
          ],
        ),
      );
    }).toList();
  }
}
