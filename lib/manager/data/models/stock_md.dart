import 'package:collection/collection.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/utils/utils.dart';

final class StockMd {
  //{
  //             "itemId": 6,
  //             "itemName": "Bath Matt1",
  //             "storageId": 1,
  //             "storageName": "Canary Wharf WA",
  //             "lastUpdate": "2023-01-17 14:39:22",
  //             "current": "38",
  //             "minimum": null,
  //             "removed": null
  //         }
  final int? itemId;
  StorageItemMd? itemMd(List<StorageItemMd> items) {
    return items.firstWhereOrNull((element) => element.id == itemId);
  }

  final String? itemName;
  final int? storageId;
  WarehouseMd? storageMd(List<WarehouseMd> storages) {
    return storages.firstWhereOrNull((element) => element.id == storageId);
  }

  final String? storageName;
  final String? lastUpdate;
  DateTime? get lastUpdateDt {
    if (lastUpdate == null) return null;
    return DateTime.tryParse(lastUpdate!);
  }

  final num? current;
  final num? minimum;
  final num? removed;

  const StockMd({
    this.itemId,
    this.itemName,
    this.storageId,
    this.storageName,
    this.lastUpdate,
    this.current,
    this.minimum,
    this.removed,
  });

  //from json
  factory StockMd.fromJson(Map<String, dynamic> json) => StockMd(
        itemId: json["itemId"],
        itemName: json["itemName"],
        storageId: json["storageId"],
        storageName: json["storageName"],
        lastUpdate: json["lastUpdate"],
        current: json["current"] is String
            ? num.tryParse(json["current"])
            : json["current"],
        minimum: json["minimum"] is String
            ? num.tryParse(json["minimum"])
            : json["minimum"],
        removed: json["removed"] is String
            ? num.tryParse(json["removed"])
            : json["removed"],
      );
}
