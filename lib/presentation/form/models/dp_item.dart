import 'package:equatable/equatable.dart';

class DpItem extends Equatable {
  final String id;
  final String title;

  const DpItem({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}
