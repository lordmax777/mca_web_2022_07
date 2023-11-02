import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:mca_dashboard/presentation/form/elements/form_input.dart';
import 'package:mca_dashboard/presentation/form/models/dp_item.dart';
import 'package:mca_dashboard/presentation/form/models/dropdown_model.dart';
import 'package:mca_dashboard/presentation/form/models/input_model.dart';
import 'package:mca_dashboard/utils/utils.dart';

import '../../global_widgets/widgets.dart';

class FormDropdown extends StatelessWidget {
  final DropdownModel vm;
  FormDropdown({super.key, required this.vm})
      : assert(vm.items.isNotEmpty, "Items cannot be empty");

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<DpItem>(
      name: vm.name,
      builder: (FormFieldState<DpItem> item) {
        return DefaultDropdown2(vm: vm);
      },
    );
  }
}

class DefaultDropdown2 extends StatefulWidget {
  final DropdownModel vm;

  const DefaultDropdown2({super.key, required this.vm});

  @override
  State<DefaultDropdown2> createState() => _DefaultDropdown2State();
}

class _DefaultDropdown2State extends State<DefaultDropdown2> {
  final TextEditingController searchController = TextEditingController();

  DropdownModel get vm => widget.vm;

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
        dropdownStyleData: DropdownStyleData(
          offset: const Offset(0, -10),
          elevation: 10,
          maxHeight: vm.hasSearchBox ? 300 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[400]!),
          ),
        ),
        buttonStyleData: ButtonStyleData(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade400)),
        ),
        hint: vm.hintText == null
            ? null
            : Text(vm.hintText!,
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.w400)),
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
        selectedItemBuilder: (context) {
          return vm.items
              .map((e) => Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: true,
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  "${GlobalConstants.enableDebugCodes ? "[${e.id}] - " : ""}${e.title}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith()),
                          // if (e.subtitle != null)
                          //   TextSpan(
                          //       text: " / ${e.subtitle}",
                          //       style: const TextStyle(color: Colors.grey)),
                        ])),
                  ))
              .toList();
        },
        items: getItems(),
        onChanged: vm.onChanged == null
            ? null
            : (value) {
                if (value != null) {
                  vm.onChanged?.call(value.id);
                }
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
            // if (e.subtitle != null)
            //   Text(e.subtitle!,
            //       style: const TextStyle(fontSize: 14, color: Colors.grey),
            //       softWrap: false,
            //       overflow: TextOverflow.ellipsis),
          ],
        ),
      );
    }).toList();
  }
}
