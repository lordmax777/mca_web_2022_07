import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

class ChecklistTemplateMd extends Equatable {
  //{
  //     "id": 1,
  //     "name": "Default Checklist",
  //     "title": "Cleaning Checklist and Inventory List",
  //     "content": "{\"BATHROOM\":[\"Inside and Outside Toilet Bowl\",\"Refill Toilet Roll\",\"Close Toilet Seat\",\"Polish Mirror\",\"Cabinet Inside and Outside\",\"Empty and Line Bin and Wipe Outside Bin\",\"Clean and Dry Bath Tub and Bath Taps\",\"Clean and Dry Sink and Sink Taps\",\"Place out Complementary Toiletry\",\"Clean and Glass Shower glass\",\"Clean and Dry Shower Knobs and Heads\",\"Hoover\",\"Mop\"],\"KITCHEN\":[\"Cupboard and Doors (Inside and Outside)\",\"Kitchen Sink and Taps inc Limescale and Drying\",\"Wipe Outside Bin\",\"Empty Bins and replace Black bag\",\"Load Dishwasher and Empty Dishwasher\",\"Clean Microwave and Clean Hob\",\"Inside and Outside of Oven\",\"Wipe Kettle, Toaster\",\"Wipe Table and Chairs\",\"Wipe Washing Machine\",\"Inside and Outside Fridge and Freezer\",\"Hoover\",\"Mop\"],\"BEDROOM\":[\"Doors and Handles\",\"Clean Skirting Boards\",\"Wardrobe Doors and Inside Wardrobes\",\"Dust Chest of Draws Inside and Outside\",\"Change Bed Linen\",\"Make Bed Correctly\",\"Empty and line Bin\",\"Polish Mirrors\",\"Hoover\"],\"Items to be Checked\":[\"Iron\",\"Hair Dryer\",\"Ironing Board\"],\"OTHERS\":[\"Switch off all Lights\",\"Switch off AC\\/Heating\",\"Hoover Hallways\",\"Clean Front Door Area\"]}",
  //     "damages": [
  //       "BATHROOM",
  //       "KITCHEN",
  //       "BEDROOM"
  //     ],
  //     "active": false
  //   },
  final int? id;
  final String name;
  final String title;
  final List<ChecklistTemplateRoomMd> contents;
  final bool active;

  const ChecklistTemplateMd({
    this.id,
    required this.name,
    required this.title,
    required this.contents,
    required this.active,
  });

  @override
  List<Object?> get props => [id, name, title, contents, active];

  //from json
  factory ChecklistTemplateMd.fromJson(Map<String, dynamic> json) {
    try {
      var content;
      try {
        content = jsonDecode(json['content']);
      } catch (e) {
        content = json['content'];
      }
      if (content is! Map) {
        return ChecklistTemplateMd(
          id: json['id'],
          name: json['name'],
          title: json['title'],
          contents: const [],
          active: json['active'],
        );
      }
      for (var key in content.keys) {
        final List items = content[key];
        content[key] = items.map((e) => e.toString()).toList();
      }
      return ChecklistTemplateMd(
        id: json['id'],
        name: json['name'],
        title: json['title'],
        contents: content.keys.map((e) {
          final List<String> items = content[e];
          return ChecklistTemplateRoomMd(
            name: e,
            isDamaged: json['damages'].contains(e),
            items: items,
          );
        }).toList(),
        active: json['active'],
      );
    } on TypeError catch (e) {
      Logger.e(e.stackTrace, tag: "ChecklistTemplateMd.fromJson");
      rethrow;
    }
  }
}

class ChecklistTemplateRoomMd extends Equatable {
  final String name;
  final bool isDamaged;
  final List<String> items;

  const ChecklistTemplateRoomMd({
    required this.name,
    required this.isDamaged,
    required this.items,
  });

  @override
  List<Object?> get props => [name, isDamaged, items];
}
