class StorageItemMd {
  final int id;
  final String name;
  final bool active;
  final bool service;
  final num incomingPrice;
  final num outgoingPrice;
  final int taxId;

  StorageItemMd(
      {required this.id,
      required this.name,
      required this.active,
      required this.service,
      required this.incomingPrice,
      required this.outgoingPrice,
      required this.taxId});

  //init
  factory StorageItemMd.init({String? name}) {
    return StorageItemMd(
      id: 0,
      name: name ?? '',
      active: false,
      service: false,
      incomingPrice: 0,
      outgoingPrice: 0,
      taxId: 0,
    );
  }

  factory StorageItemMd.fromJson(Map<String, dynamic> json) {
    return StorageItemMd(
      id: json['id'],
      name: json['name'],
      active: json['active'],
      service: json['service'],
      incomingPrice: json['incomingPrice'],
      outgoingPrice: json['outgoingPrice'],
      taxId: json['taxId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'active': active,
        'service': service,
        'incomingPrice': incomingPrice,
        'outgoingPrice': outgoingPrice,
        'taxId': taxId,
      };
}
