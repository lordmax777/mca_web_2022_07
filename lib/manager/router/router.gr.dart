// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:flutter/material.dart' as _i5;

import '../../pages/home_page.dart' as _i1;
import '../../pages/user_details_page.dart' as _i3;
import '../../pages/users_list_page.dart' as _i2;

class AppRouter extends _i4.RootStackRouter {
  AppRouter([_i5.GlobalKey<_i5.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i4.PageFactory> pagesMap = {
    HomePageRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.HomePage());
    },
    UsersListRoute.name: (routeData) {
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.UsersListPage());
    },
    UserDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<UserDetailsRouteArgs>(
          orElse: () => const UserDetailsRouteArgs());
      return _i4.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.UserDetailsPage(key: args.key));
    }
  };

  @override
  List<_i4.RouteConfig> get routes => [
        _i4.RouteConfig(HomePageRoute.name, path: '/', children: [
          _i4.RouteConfig(UsersListRoute.name,
              path: '', parent: HomePageRoute.name),
          _i4.RouteConfig(UserDetailsRoute.name,
              path: 'userDetail', parent: HomePageRoute.name)
        ])
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomePageRoute extends _i4.PageRouteInfo<void> {
  const HomePageRoute({List<_i4.PageRouteInfo>? children})
      : super(HomePageRoute.name, path: '/', initialChildren: children);

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i2.UsersListPage]
class UsersListRoute extends _i4.PageRouteInfo<void> {
  const UsersListRoute() : super(UsersListRoute.name, path: '');

  static const String name = 'UsersListRoute';
}

/// generated route for
/// [_i3.UserDetailsPage]
class UserDetailsRoute extends _i4.PageRouteInfo<UserDetailsRouteArgs> {
  UserDetailsRoute({_i5.Key? key})
      : super(UserDetailsRoute.name,
            path: 'userDetail', args: UserDetailsRouteArgs(key: key));

  static const String name = 'UserDetailsRoute';
}

class UserDetailsRouteArgs {
  const UserDetailsRouteArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'UserDetailsRouteArgs{key: $key}';
  }
}
