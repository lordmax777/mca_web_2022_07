import 'dart:convert';
import '../redux/sets/state_value.dart';

class ChecklistTemplateMd {
  int id;
  String name;
  String title;
  String content;
  List<String> damages;
  bool active;

  ChecklistTemplateMd(
      {required this.id,
      required this.name,
      required this.title,
      required this.content,
      required this.damages,
      required this.active});

  List<CodeMap<List<String>>> get getRooms {
    if (content.isEmpty) return [];
    var rooms = jsonDecode(content);
    List<CodeMap<List<String>>> list = [];

    if (rooms.isNotEmpty) {
      for (var room in rooms.entries) {
        list.add(CodeMap<List<String>>(
          code: (room.value as List).map<String>((e) => e.toString()).toList(),
          name: room.key,
        ));
      }
    }
    return list;
  }

  factory ChecklistTemplateMd.fromJson(Map<String, dynamic> json) {
    return ChecklistTemplateMd(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      content: json['content'],
      damages: json['damages'].cast<String>(),
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['title'] = title;
    data['content'] = content;
    data['damages'] = damages;
    data['active'] = active;
    return data;
  }
}
