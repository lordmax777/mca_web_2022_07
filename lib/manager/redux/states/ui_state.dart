import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../../../comps/drawer.dart';
import '../../../utils/constants.dart';
import '../../router/router.dart';
import '../sets/app_state.dart';

@immutable
class UIState {
  final Widget? endDrawer;
  final DrawerStates drawerStates;

  UIState({
    required this.endDrawer,
    required this.drawerStates,
  });

  factory UIState.initial() {
    return UIState(
      endDrawer: null,
      drawerStates: DrawerStates(initialIndex: 1, name: const TestRoute()),
    );
  }

  UIState copyWith({
    DrawerStates? drawerStates,
    Widget? endDrawer,
  }) {
    return UIState(
      drawerStates: drawerStates ?? this.drawerStates,
      endDrawer: endDrawer,
    );
  }
}

class UpdateUIStateAction {
  final DrawerStates? drawerStates;
  final Widget? endDrawer;
  UpdateUIStateAction({
    this.drawerStates,
    this.endDrawer,
  });
}

class OpenDrawerAction {
  OpenDrawerAction(this.widget);

  final Widget widget;

  void call(Store<AppState> store, dynamic action, NextDispatcher next) async {
    store.dispatch(UpdateUIStateAction(endDrawer: widget));
    await Future.delayed(const Duration(milliseconds: 100));
    if (Constants.scaffoldKey.currentState != null) {
      if (!Constants.scaffoldKey.currentState!.isDrawerOpen) {
        Constants.scaffoldKey.currentState!.openEndDrawer();
      }
    }
  }
}
