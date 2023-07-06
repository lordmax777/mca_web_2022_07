import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mca_dashboard/manager/data/data.dart';

final class StorageItemMd extends Equatable {
  //{
  //             "id": 1,
  //             "name": "Double Sheet",
  //             "active": true,
  //             "service": false,
  //             "incomingPrice": 0.33,
  //             "outgoingPrice": 3.5,
  //             "taxId": 1
  //         }
  final int id;
  final String name;
  final bool active;
  final bool service;
  final num incomingPrice;
  num outgoingPrice;
  final int? taxId;

  TaxMd? getTaxMd(List<TaxMd> taxes) =>
      taxes.firstWhereOrNull((element) => element.id == taxId);

  bool auto;
  int quantity;

  StorageItemMd({
    required this.id,
    required this.name,
    required this.active,
    required this.service,
    required this.incomingPrice,
    required this.outgoingPrice,
    required this.taxId,
    this.auto = true,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        active,
        service,
        incomingPrice,
        outgoingPrice,
        taxId,
        auto,
        quantity,
      ];

  factory StorageItemMd.fromJson(Map<String, dynamic> json) => StorageItemMd(
        id: json['id'] as int,
        name: json['name'] ?? '',
        active: json['active'] ?? false,
        service: json['service'] ?? false,
        incomingPrice: json['incomingPrice'] ?? 0,
        outgoingPrice: json['outgoingPrice'] ?? 0,
        taxId: json['taxId'],
      );

  //copyWith
  StorageItemMd copyWith({
    int? id,
    String? name,
    bool? active,
    bool? service,
    num? incomingPrice,
    num? outgoingPrice,
    int? taxId,
    bool? auto,
    int? quantity,
  }) {
    return StorageItemMd(
      id: id ?? this.id,
      name: name ?? this.name,
      active: active ?? this.active,
      service: service ?? this.service,
      incomingPrice: incomingPrice ?? this.incomingPrice,
      outgoingPrice: outgoingPrice ?? this.outgoingPrice,
      taxId: taxId ?? this.taxId,
      auto: auto ?? this.auto,
      quantity: quantity ?? this.quantity,
    );
  }
}
