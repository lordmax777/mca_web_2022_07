import 'package:equatable/equatable.dart';

class DpItem extends Equatable {
  final String id;
  final String title;
  final String? subtitle;

  const DpItem({required this.id, required this.title, this.subtitle});

  @override
  List<Object?> get props => [id, title, subtitle];
}
