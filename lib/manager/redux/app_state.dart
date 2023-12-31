import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';

export 'state.dart';

@immutable
class AppState extends Equatable {
  const AppState({required this.generalState});

  final GeneralState generalState;

  factory AppState.initial() {
    return AppState(
      generalState: GeneralState.initial(),
    );
  }

  AppState copyWith({
    GeneralState? generalState,
  }) {
    return AppState(
      generalState: generalState ?? this.generalState,
    );
  }

  @override
  List<Object?> get props => [generalState];
}
