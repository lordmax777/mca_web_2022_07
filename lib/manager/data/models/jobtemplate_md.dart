import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:mca_dashboard/manager/manager.dart';
import '../../manager.dart';

class JobTemplateMd extends Equatable {
  //{
  //             "id": 1,
  //             "name": "test",
  //             "comment": "no comment",
  //             "active": true,
  //             "client_id": 25,
  //             "items": [
  //                 {
  //                     "id": 65,
  //                     "quantity": 1,
  //                     "price": 122,
  //                     "comment": "",
  //                     "combine": false
  //                 }
  //             ]
  //         }
  final int id;
  final String name;
  final String? comment;
  final bool active;
  final int? clientId;
  ClientMd? client(List<ClientMd> clients) =>
      clients.firstWhereOrNull((element) => element.id == clientId);
  final List<JobTemplateItemMd> items;

  const JobTemplateMd({
    required this.id,
    required this.name,
    this.comment,
    required this.active,
    this.clientId,
    required this.items,
  });

  @override
  List<Object?> get props => [id, name, comment, active, clientId, items];

  //fromJson
  factory JobTemplateMd.fromJson(Map<String, dynamic> json) {
    final jobtemplate = JobTemplateMd(
      id: json['id'],
      name: json['name'],
      comment: json['comment'] ?? '',
      active: json['active'],
      clientId: json['client_id'],
      items: [],
    );
    return jobtemplate.copyWith(
      items: (json['items'] as List<dynamic>)
          .map((e) => JobTemplateItemMd.fromJson(e, jobtemplate))
          .toList(),
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'comment': comment,
      'active': active,
      'client_id': clientId.toString(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  //copyWith
  JobTemplateMd copyWith({
    int? id,
    String? name,
    String? comment,
    bool? active,
    int? clientId,
    List<JobTemplateItemMd>? items,
  }) {
    return JobTemplateMd(
      id: id ?? this.id,
      name: name ?? this.name,
      comment: comment ?? this.comment,
      active: active ?? this.active,
      clientId: clientId ?? this.clientId,
      items: items ?? this.items,
    );
  }
}

class JobTemplateItemMd extends Equatable {
  final int id;
  final int itemId;
  final num quantity;
  final num price;
  final String? comment;
  final bool combine;

  final JobTemplateMd? template;

  StorageItemMd? item(List<StorageItemMd> items) =>
      items.firstWhereOrNull((element) => element.id == itemId);

  const JobTemplateItemMd({
    ///Id of the item in the job template
    required this.id,

    ///Id of the item in the storage
    required this.itemId,
    required this.quantity,
    required this.price,
    this.comment,
    required this.combine,
    this.template,
  });

  @override
  List<Object?> get props => [id, quantity, price, comment, combine];

  //fromJson
  factory JobTemplateItemMd.fromJson(Map<String, dynamic> json,
      [JobTemplateMd? template]) {
    return JobTemplateItemMd(
      id: json['id'],
      itemId: json['item_id'],
      quantity: json['quantity'],
      price: json['price'],
      comment: json['comment'],
      combine: json['combine'],
      template: template,
    );
  }

  //toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'price': price,
      'comment': comment,
      'combine': combine,
      'template': template?.toJson() ?? '',
    };
  }
}
