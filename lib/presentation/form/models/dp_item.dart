import 'package:equatable/equatable.dart';

class DpItem<T> extends Equatable {
  final T id;
  final String title;

  const DpItem({required this.id, required this.title});

  @override
  List<Object?> get props => [id, title];
}
