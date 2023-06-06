import 'package:collection/collection.dart';
import 'package:mca_web_2022_07/pages/scheduling/models/job_model.dart';

import '../../../comps/custom_multi_select_dropdown.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../theme/theme.dart';

class StorageItemsDropdown extends StatelessWidget {
  final JobModel data;
  final AppState state;
  final void Function(List<PlutoRow>) onChanged;
  const StorageItemsDropdown(
      {super.key,
      required this.data,
      required this.state,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomMultiSelectDropdown(
        isMultiSelect: true,
        width: 300,
        initiallySelected: [
          ...data.getAddedStorageItems(state.generalState.storage_items).map(
              (e) => MultiSelectItem(
                  label: e.name,
                  id: e.id.toString(),
                  extraInfo:
                      e.incomingPrice.getPriceMap().formattedVer.toString()))
        ],
        items: [
          MultiSelectGroup(
              label: "Service",
              items: state.generalState.storage_items
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
              items: state.generalState.storage_items
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
              data.gridStateManager.removeAllRows();
              break;
            case RetAction.add:
              print("Add");
              final storageItem = state.generalState.storage_items
                  .firstWhereOrNull((element) =>
                      element.id == int.tryParse(res.addId.toString()));
              if (storageItem != null) {
                data.gridStateManager.insertRows(
                    0, [data.buildStorageRow(storageItem, checked: true)]);
              }
              break;
            case RetAction.remove:
              print("Remove");
              final row = data.gridStateManager.rows.firstWhereOrNull(
                  (element) =>
                      element.cells['id']?.value ==
                      int.tryParse(res.removeId.toString()));
              if (row != null) {
                data.gridStateManager.removeRows([row]);
              }
              break;
          }
          onChanged(data.gridStateManager.rows);
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
