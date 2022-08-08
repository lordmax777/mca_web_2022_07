import 'package:mca_web_2022_07/manager/models/auth.dart';
import 'package:mca_web_2022_07/manager/models/users_list.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../rest/nocode_helpers.dart';
import '../../rest/rest_client.dart';
import '../states/users_state.dart';

class UsersMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case GetUsersListAction:
        return _getUsersListAction(store.state, action, next);
      default:
        return next(action);
    }
  }

  Future<List<UserRes>?> _getUsersListAction(
      AppState state, GetUsersListAction action, NextDispatcher next) async {
    final ApiResponse res =
        await restClient().getUsersList().nocodeErrorHandler();

    if (res.success) {
      final List _l = res.data['users'].values.toList();
      List<UserRes> _users = [];
      for (var v in _l) {
        _users.add(UserRes.fromJson(v));
      }
      next(UpdateUsersStateAction(usersList: _users));
      return _users;
    }
    return null;
  }
}
