class StorageItemMd {
  int? id;
  String? name;
  bool? active;
  bool? service;
  num? incomingPrice;
  num? outgoingPrice;
  int? taxId;

  StorageItemMd(
      {this.id,
      this.name,
      this.active,
      this.service,
      this.incomingPrice,
      this.outgoingPrice,
      this.taxId});

  StorageItemMd.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    active = json['active'];
    service = json['service'];
    incomingPrice = json['incomingPrice'];
    outgoingPrice = json['outgoingPrice'];
    taxId = json['taxId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['active'] = active;
    data['service'] = service;
    data['incomingPrice'] = incomingPrice;
    data['outgoingPrice'] = outgoingPrice;
    data['taxId'] = taxId;
    return data;
  }
}
