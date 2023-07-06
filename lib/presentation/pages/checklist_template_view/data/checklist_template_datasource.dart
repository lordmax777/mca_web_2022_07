import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';

import '../../../../manager/manager.dart';

class ChecklistTemplateDataSource
    with DataSourceMixin<ChecklistTemplateDataSource> {
  final int? id;
  final TextEditingController name;
  final TextEditingController title;
  final List<ChecklistTemplateRoomDataSource> contents;
  final bool active;

  bool get isCreate => id == null;

  const ChecklistTemplateDataSource({
    this.id,
    required this.name,
    required this.title,
    required this.contents,
    required this.active,
  });

  @override
  ChecklistTemplateDataSource copyWith({
    int? id,
    bool? active,
    List<ChecklistTemplateRoomDataSource>? contents,
  }) {
    return ChecklistTemplateDataSource(
      id: id ?? this.id,
      active: active ?? this.active,
      contents: contents ?? this.contents,
      name: name,
      title: title,
    );
  }

  @override
  void dispose() {
    name.dispose();
    title.dispose();
    for (var element in contents) {
      element.dispose();
    }
  }

  @override
  List<Object?> get props => [id, name, title, contents, active];

  //init
  factory ChecklistTemplateDataSource.init({int? id}) {
    return ChecklistTemplateDataSource(
      id: id,
      active: true,
      name: TextEditingController(),
      title: TextEditingController(),
      contents: [],
    );
  }

  factory ChecklistTemplateDataSource.fromModel(ChecklistTemplateMd? model) {
    if (model == null) return ChecklistTemplateDataSource.init();

    return ChecklistTemplateDataSource(
      id: model.id,
      active: model.active,
      name: TextEditingController(text: model.name),
      title: TextEditingController(text: model.title),
      contents: model.contents
          .map((e) => ChecklistTemplateRoomDataSource(
                name: TextEditingController(text: e.name),
                isDamaged: e.isDamaged,
                items:
                    e.items.map((e) => TextEditingController(text: e)).toList(),
              ))
          .toList(),
    );
  }
}

class ChecklistTemplateRoomDataSource
    with DataSourceMixin<ChecklistTemplateRoomDataSource> {
  final TextEditingController name;
  final bool isDamaged;
  final List<TextEditingController> items;

  const ChecklistTemplateRoomDataSource({
    required this.name,
    required this.isDamaged,
    required this.items,
  });

  @override
  ChecklistTemplateRoomDataSource copyWith({bool? isDamaged}) {
    return ChecklistTemplateRoomDataSource(
      name: name,
      items: items,
      isDamaged: isDamaged ?? this.isDamaged,
    );
  }

  @override
  void dispose() {
    name.dispose();
    for (var element in items) {
      element.dispose();
    }
  }

  @override
  List<Object?> get props => [name, isDamaged, items];

  //init
  factory ChecklistTemplateRoomDataSource.init() {
    return ChecklistTemplateRoomDataSource(
      name: TextEditingController(),
      isDamaged: false,
      items: [],
    );
  }
}
