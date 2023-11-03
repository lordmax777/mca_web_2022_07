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
  final String comment;
  final bool active;
  final int clientId;
  ClientMd? client(List<ClientMd> clients) =>
      clients.firstWhereOrNull((element) => element.id == clientId);
  final List<JobTemplateItemMd> items;

  const JobTemplateMd({
    required this.id,
    required this.name,
    required this.comment,
    required this.active,
    required this.clientId,
    required this.items,
  });

  @override
  List<Object?> get props => [id, name, comment, active, clientId, items];

  //fromJson
  factory JobTemplateMd.fromJson(Map<String, dynamic> json) {
    return JobTemplateMd(
      id: json['id'],
      name: json['name'],
      comment: json['comment'] ?? '',
      active: json['active'],
      clientId: json['client_id'],
      items: (json['items'] as List)
          .map((e) => JobTemplateItemMd.fromJson(e))
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
      'client_id': clientId,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class JobTemplateItemMd extends Equatable {
  final int id;
  final num quantity;
  final num price;
  final String comment;
  final bool combine;

  const JobTemplateItemMd({
    required this.id,
    required this.quantity,
    required this.price,
    required this.comment,
    required this.combine,
  });

  @override
  List<Object?> get props => [id, quantity, price, comment, combine];

  //fromJson
  factory JobTemplateItemMd.fromJson(Map<String, dynamic> json) {
    return JobTemplateItemMd(
      id: json['id'],
      quantity: json['quantity'],
      price: json['price'],
      comment: json['comment'] ?? '',
      combine: json['combine'],
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
    };
  }
}
