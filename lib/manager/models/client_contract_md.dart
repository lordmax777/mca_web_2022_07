class ClientContractMd {
  //{
  //         "id": 4,
  //         "startDate": "2019-04-01",
  //         "endDate": null,
  //         "hourlyRate": null,
  //         "creditLimit": null,
  //         "notes": "",
  //         "combine": false,
  //         "shifts": [
  //             {
  //                 "shiftId": 66,
  //                 "items": [
  //                     {
  //                         "itemId": 1,
  //                         "itemName": "Double Sheet",
  //                         "amount": 2,
  //                         "price": 0,
  //                         "notes": "",
  //                         "auto": true
  //                     },
  //                 ]
  //             },
  //         ]
  //     }

  final int id;
  final String startDate;
  final String? endDate;
  final num? hourlyRates;
  final num? creditLimit;
  final String? notes;
  final bool combine;
  final List<ClientContractShift> shifts;

  ClientContractMd({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.hourlyRates,
    required this.creditLimit,
    required this.notes,
    required this.combine,
    required this.shifts,
  });

  factory ClientContractMd.fromJson(Map<String, dynamic> json) {
    return ClientContractMd(
      id: json['id'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      hourlyRates: json['hourlyRate'],
      creditLimit: json['creditLimit'],
      notes: json['notes'],
      combine: json['combine'],
      shifts: (json['shifts'] as List)
          .map((e) => ClientContractShift.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startDate': startDate,
      'endDate': endDate,
      'hourlyRate': hourlyRates,
      'creditLimit': creditLimit,
      'notes': notes,
      'combine': combine,
      'shifts': shifts.map((e) => e.toJson()).toList(),
    };
  }
}

class ClientContractShift {
  final int shiftId;
  final List<ClientContractShiftItem> items;

  ClientContractShift({
    required this.shiftId,
    required this.items,
  });

  factory ClientContractShift.fromJson(Map<String, dynamic> json) {
    return ClientContractShift(
      shiftId: json['shiftId'],
      items: (json['items'] as List)
          .map((e) => ClientContractShiftItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shiftId': shiftId,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class ClientContractShiftItem {
  final int itemId;
  final String itemName;
  final num amount;
  final num price;
  final String? notes;
  final bool auto;

  ClientContractShiftItem({
    required this.itemId,
    required this.itemName,
    required this.amount,
    required this.price,
    required this.notes,
    required this.auto,
  });

  factory ClientContractShiftItem.fromJson(Map<String, dynamic> json) {
    return ClientContractShiftItem(
      itemId: json['itemId'],
      itemName: json['itemName'],
      amount: json['amount'],
      price: json['price'],
      notes: json['notes'],
      auto: json['auto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'amount': amount,
      'price': price,
      'notes': notes,
      'auto': auto,
    };
  }
}
