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
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../../pages/home_page.dart' as _i1;
import '../../pages/user/user_details_page.dart' as _i3;
import '../../pages/user/users_list_page.dart' as _i2;
import '../../theme/theme.dart' as _i4;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i1.HomePage(),
      );
    },
    UsersListRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i2.UsersListPage(),
      );
    },
    UserDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<UserDetailsRouteArgs>(
          orElse: () => const UserDetailsRouteArgs());
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i3.UserDetailsPage(
          key: args.key,
          tabIndex: args.tabIndex,
        ),
      );
    },
    UserDetailsPayrollTabNewContractRoute.name: (routeData) {
      final args = routeData.argsAs<UserDetailsPayrollTabNewContractRouteArgs>(
          orElse: () => const UserDetailsPayrollTabNewContractRouteArgs());
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i4.UserDetailsPayrollTabNewContractPage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    DepartmentsListRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.DepartmentsListPage(),
      );
    },
    QualificationsRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.QualificationsPage(),
      );
    },
    LocationsListRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
        routeData: routeData,
        child: const _i4.LocationsListPage(),
      );
    },
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(
          HomeRoute.name,
          path: '/',
          children: [
            _i5.RouteConfig(
              UsersListRoute.name,
              path: '',
              parent: HomeRoute.name,
            ),
            _i5.RouteConfig(
              UserDetailsRoute.name,
              path: 'user-detail',
              parent: HomeRoute.name,
            ),
            _i5.RouteConfig(
              UserDetailsPayrollTabNewContractRoute.name,
              path: 'new-contract',
              parent: HomeRoute.name,
            ),
            _i5.RouteConfig(
              DepartmentsListRoute.name,
              path: 'departments',
              parent: HomeRoute.name,
            ),
            _i5.RouteConfig(
              QualificationsRoute.name,
              path: 'qualifications',
              parent: HomeRoute.name,
            ),
            _i5.RouteConfig(
              LocationsListRoute.name,
              path: 'locations',
              parent: HomeRoute.name,
            ),
          ],
        )
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i5.PageRouteInfo<void> {
  const HomeRoute({List<_i5.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.UsersListPage]
class UsersListRoute extends _i5.PageRouteInfo<void> {
  const UsersListRoute()
      : super(
          UsersListRoute.name,
          path: '',
        );

  static const String name = 'UsersListRoute';
}

/// generated route for
/// [_i3.UserDetailsPage]
class UserDetailsRoute extends _i5.PageRouteInfo<UserDetailsRouteArgs> {
  UserDetailsRoute({
    _i4.Key? key,
    int? tabIndex,
  }) : super(
          UserDetailsRoute.name,
          path: 'user-detail',
          args: UserDetailsRouteArgs(
            key: key,
            tabIndex: tabIndex,
          ),
        );

  static const String name = 'UserDetailsRoute';
}

class UserDetailsRouteArgs {
  const UserDetailsRouteArgs({
    this.key,
    this.tabIndex,
  });

  final _i4.Key? key;

  final int? tabIndex;

  @override
  String toString() {
    return 'UserDetailsRouteArgs{key: $key, tabIndex: $tabIndex}';
  }
}

/// generated route for
/// [_i4.UserDetailsPayrollTabNewContractPage]
class UserDetailsPayrollTabNewContractRoute
    extends _i5.PageRouteInfo<UserDetailsPayrollTabNewContractRouteArgs> {
  UserDetailsPayrollTabNewContractRoute({
    _i4.Key? key,
    int? id,
  }) : super(
          UserDetailsPayrollTabNewContractRoute.name,
          path: 'new-contract',
          args: UserDetailsPayrollTabNewContractRouteArgs(
            key: key,
            id: id,
          ),
        );

  static const String name = 'UserDetailsPayrollTabNewContractRoute';
}

class UserDetailsPayrollTabNewContractRouteArgs {
  const UserDetailsPayrollTabNewContractRouteArgs({
    this.key,
    this.id,
  });

  final _i4.Key? key;

  final int? id;

  @override
  String toString() {
    return 'UserDetailsPayrollTabNewContractRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [_i4.DepartmentsListPage]
class DepartmentsListRoute extends _i5.PageRouteInfo<void> {
  const DepartmentsListRoute()
      : super(
          DepartmentsListRoute.name,
          path: 'departments',
        );

  static const String name = 'DepartmentsListRoute';
}

/// generated route for
/// [_i4.QualificationsPage]
class QualificationsRoute extends _i5.PageRouteInfo<void> {
  const QualificationsRoute()
      : super(
          QualificationsRoute.name,
          path: 'qualifications',
        );

  static const String name = 'QualificationsRoute';
}

/// generated route for
/// [_i4.LocationsListPage]
class LocationsListRoute extends _i5.PageRouteInfo<void> {
  const LocationsListRoute()
      : super(
          LocationsListRoute.name,
          path: 'locations',
        );

  static const String name = 'LocationsListRoute';
}
