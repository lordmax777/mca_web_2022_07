import 'package:collection/collection.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/job_model.dart';

import '../../../comps/custom_multi_select_dropdown.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../theme/theme.dart';

class StorageItemsDropdown extends StatefulWidget {
  final AppState state;
  final List<StorageItemMd> initialItems;
  final void Function(int? storageItemId) onRemoved;
  final ValueChanged<StorageItemMd?> onAdded;
  const StorageItemsDropdown({
    super.key,
    required this.initialItems,
    required this.state,
    required this.onAdded,

    ///If null passed, then remove all items
    required this.onRemoved,
  });

  @override
  State<StorageItemsDropdown> createState() => _StorageItemsDropdownState();
}

class _StorageItemsDropdownState extends State<StorageItemsDropdown> {
  bool visible = true;
  @override
  void didUpdateWidget(covariant StorageItemsDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    logger(oldWidget.initialItems.length, hint: 'TESTTES 1');
    logger(widget.initialItems.length, hint: 'TESTTES 2');
    if (oldWidget.initialItems.length != widget.initialItems.length) {
      logger('TESTTES 3');
      // setState(() {
      //   visible = false;
      // });
      // Future.delayed(Duration(milliseconds: 100), () {
      //   setState(() {
      //     visible = true;
      //   });
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Visibility(
        visible: visible,
        child: CustomMultiSelectDropdown(
          isMultiSelect: true,
          width: 300,
          initiallySelected: [
            ...widget.initialItems.map((e) => MultiSelectItem(
                label: e.name,
                id: e.id.toString(),
                extraInfo:
                    e.incomingPrice.getPriceMap().formattedVer.toString()))
          ],
          items: [
            MultiSelectGroup(
                label: "Service",
                items: widget.state.generalState.storage_items
                    .where((element) => element.service)
                    .map((e) => MultiSelectItem(
                        label: e.name,
                        id: e.id.toString(),
                        extraInfo: e.incomingPrice
                            .getPriceMap()
                            .formattedVer
                            .toString()))
                    .toList()),
            MultiSelectGroup(
                label: "Product",
                items: widget.state.generalState.storage_items
                    .where((element) => !element.service)
                    .map((e) => MultiSelectItem(
                        label: e.name,
                        id: e.id.toString(),
                        extraInfo: e.incomingPrice
                            .getPriceMap()
                            .formattedVer
                            .toString()))
                    .toList()),
          ],
          onChange: (res) {
            switch (res.action) {
              case RetAction.empty:
                print("Empty");
                widget.onRemoved(null);
                break;
              case RetAction.add:
                print("Add");
                final storageItem = widget.state.generalState.storage_items
                    .firstWhereOrNull((element) =>
                        element.id == int.tryParse(res.addId.toString()));
                if (storageItem != null) {
                  widget.onAdded(storageItem);
                }
                break;
              case RetAction.remove:
                print("Remove");
                widget.onRemoved(int.tryParse(res.removeId!));
                break;
            }
          },
          // onChange: (list) {
          //   final ids = list.map((e) => int.parse(e.id)).toList();
          //   final removableRows = <PlutoRow>[];
          //   for (final row in data.gridStateManager.rows) {
          //     final rowId = row.cells['id']?.value;
          //     if (rowId == null) continue;
          //     if (!ids.contains(rowId)) {
          //       removableRows.add(row);
          //     } else {
          //       ids.remove(rowId);
          //     }
          //   }
          //   data.gridStateManager.removeRows(removableRows);
          //   for (final id in ids) {
          //     final storageItem = state.generalState.storage_items
          //         .firstWhereOrNull((element) => element.id == id);
          //     if (storageItem != null) {
          //       logger("Adding new item: ${storageItem.name}");
          //       data.gridStateManager.insertRows(0,
          //           [data.buildStorageRow(storageItem, checked: true)]);
          //     }
          //     // }
          //   }
          // },
        ),
      ),
      // CustomAutocompleteTextField<StorageItemMd>(
      //     listItemWidget: (p0) => Text(p0.name),
      //     onSelected: (p0) {
      //       final StorageItemMd? item = data.gridStateManager.rows
      //           .firstWhereOrNull((element) =>
      //               (element.cells['item']?.value as StorageItemMd)
      //                   .id ==
      //               p0.id)
      //           ?.cells['item']
      //           ?.value;
      //       final includedItemIdx = data.gridStateManager.rows
      //           .indexWhere((element) =>
      //               (element.cells['item']?.value as StorageItemMd)
      //                   .id ==
      //               p0.id);
      //       if (includedItemIdx >= 0 && item != null) {
      //         if (!item.service) {
      //           data.gridStateManager.rows[includedItemIdx]
      //               .cells['quantity']?.value = data
      //                   .gridStateManager
      //                   .rows[includedItemIdx]
      //                   .cells['quantity']
      //                   ?.value +
      //               1;
      //           setState(() {});
      //         }
      //       } else {
      //         data.gridStateManager.insertRows(
      //             0, [data.buildStorageRow(p0, checked: true)]);
      //       }
      //     },
      //     displayStringForOption: (option) {
      //       return option.name;
      //     },
      //     options: (p0) => state.generalState.storage_items
      //         .where((element) => element.name
      //             .toLowerCase()
      //             .contains(p0.text.toLowerCase()))
      //         .toList()),
    );
  }
}
