// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final AuthGuard authGuard;

  @override
  final Map<String, PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    },
    UsersListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const UsersListPage(),
      );
    },
    UserDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<UserDetailsRouteArgs>(
          orElse: () => const UserDetailsRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: UserDetailsPage(
          key: args.key,
          tabIndex: args.tabIndex,
        ),
      );
    },
    UserDetailsPayrollTabNewContractRoute.name: (routeData) {
      final args = routeData.argsAs<UserDetailsPayrollTabNewContractRouteArgs>(
          orElse: () => const UserDetailsPayrollTabNewContractRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: UserDetailsPayrollTabNewContractPage(
          key: args.key,
          contract: args.contract,
        ),
      );
    },
    DepartmentsListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const DepartmentsListPage(),
      );
    },
    QualificationsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const QualificationsPage(),
      );
    },
    LocationsListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LocationsListPage(),
      );
    },
    NewLocationRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const NewLocationPage(),
      );
    },
    WarehousesListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const WarehousesListPage(),
      );
    },
    StockItemsListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const StockItemsListPage(),
      );
    },
    ChecklistTemplatesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ChecklistTemplatesPage(),
      );
    },
    NewChecklistTemplateRoute.name: (routeData) {
      final args = routeData.argsAs<NewChecklistTemplateRouteArgs>(
          orElse: () => const NewChecklistTemplateRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: NewChecklistTemplatePage(
          key: args.key,
          id: args.id,
        ),
      );
    },
    HandoverTypesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HandoverTypesPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          LoginRoute.name,
          path: '/login-page',
        ),
        RouteConfig(
          HomeRoute.name,
          path: '/',
          guards: [authGuard],
          children: [
            RouteConfig(
              UsersListRoute.name,
              path: '',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              UserDetailsRoute.name,
              path: 'user-detail',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              UserDetailsPayrollTabNewContractRoute.name,
              path: 'new-contract',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              DepartmentsListRoute.name,
              path: 'departments',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              QualificationsRoute.name,
              path: 'qualifications',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              LocationsListRoute.name,
              path: 'locations',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              NewLocationRoute.name,
              path: 'new-location',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              WarehousesListRoute.name,
              path: 'warehouses',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              StockItemsListRoute.name,
              path: 'stock-items',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              ChecklistTemplatesRoute.name,
              path: 'checklist-templates',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              NewChecklistTemplateRoute.name,
              path: 'new-checklist-template',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              HandoverTypesRoute.name,
              path: 'handover-types',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              SettingsRoute.name,
              path: 'settings-page',
              parent: HomeRoute.name,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '/login-page',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [UsersListPage]
class UsersListRoute extends PageRouteInfo<void> {
  const UsersListRoute()
      : super(
          UsersListRoute.name,
          path: '',
        );

  static const String name = 'UsersListRoute';
}

/// generated route for
/// [UserDetailsPage]
class UserDetailsRoute extends PageRouteInfo<UserDetailsRouteArgs> {
  UserDetailsRoute({
    Key? key,
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

  final Key? key;

  final int? tabIndex;

  @override
  String toString() {
    return 'UserDetailsRouteArgs{key: $key, tabIndex: $tabIndex}';
  }
}

/// generated route for
/// [UserDetailsPayrollTabNewContractPage]
class UserDetailsPayrollTabNewContractRoute
    extends PageRouteInfo<UserDetailsPayrollTabNewContractRouteArgs> {
  UserDetailsPayrollTabNewContractRoute({
    Key? key,
    ContractMd? contract,
  }) : super(
          UserDetailsPayrollTabNewContractRoute.name,
          path: 'new-contract',
          args: UserDetailsPayrollTabNewContractRouteArgs(
            key: key,
            contract: contract,
          ),
        );

  static const String name = 'UserDetailsPayrollTabNewContractRoute';
}

class UserDetailsPayrollTabNewContractRouteArgs {
  const UserDetailsPayrollTabNewContractRouteArgs({
    this.key,
    this.contract,
  });

  final Key? key;

  final ContractMd? contract;

  @override
  String toString() {
    return 'UserDetailsPayrollTabNewContractRouteArgs{key: $key, contract: $contract}';
  }
}

/// generated route for
/// [DepartmentsListPage]
class DepartmentsListRoute extends PageRouteInfo<void> {
  const DepartmentsListRoute()
      : super(
          DepartmentsListRoute.name,
          path: 'departments',
        );

  static const String name = 'DepartmentsListRoute';
}

/// generated route for
/// [QualificationsPage]
class QualificationsRoute extends PageRouteInfo<void> {
  const QualificationsRoute()
      : super(
          QualificationsRoute.name,
          path: 'qualifications',
        );

  static const String name = 'QualificationsRoute';
}

/// generated route for
/// [LocationsListPage]
class LocationsListRoute extends PageRouteInfo<void> {
  const LocationsListRoute()
      : super(
          LocationsListRoute.name,
          path: 'locations',
        );

  static const String name = 'LocationsListRoute';
}

/// generated route for
/// [NewLocationPage]
class NewLocationRoute extends PageRouteInfo<void> {
  const NewLocationRoute()
      : super(
          NewLocationRoute.name,
          path: 'new-location',
        );

  static const String name = 'NewLocationRoute';
}

/// generated route for
/// [WarehousesListPage]
class WarehousesListRoute extends PageRouteInfo<void> {
  const WarehousesListRoute()
      : super(
          WarehousesListRoute.name,
          path: 'warehouses',
        );

  static const String name = 'WarehousesListRoute';
}

/// generated route for
/// [StockItemsListPage]
class StockItemsListRoute extends PageRouteInfo<void> {
  const StockItemsListRoute()
      : super(
          StockItemsListRoute.name,
          path: 'stock-items',
        );

  static const String name = 'StockItemsListRoute';
}

/// generated route for
/// [ChecklistTemplatesPage]
class ChecklistTemplatesRoute extends PageRouteInfo<void> {
  const ChecklistTemplatesRoute()
      : super(
          ChecklistTemplatesRoute.name,
          path: 'checklist-templates',
        );

  static const String name = 'ChecklistTemplatesRoute';
}

/// generated route for
/// [NewChecklistTemplatePage]
class NewChecklistTemplateRoute
    extends PageRouteInfo<NewChecklistTemplateRouteArgs> {
  NewChecklistTemplateRoute({
    Key? key,
    int? id,
  }) : super(
          NewChecklistTemplateRoute.name,
          path: 'new-checklist-template',
          args: NewChecklistTemplateRouteArgs(
            key: key,
            id: id,
          ),
        );

  static const String name = 'NewChecklistTemplateRoute';
}

class NewChecklistTemplateRouteArgs {
  const NewChecklistTemplateRouteArgs({
    this.key,
    this.id,
  });

  final Key? key;

  final int? id;

  @override
  String toString() {
    return 'NewChecklistTemplateRouteArgs{key: $key, id: $id}';
  }
}

/// generated route for
/// [HandoverTypesPage]
class HandoverTypesRoute extends PageRouteInfo<void> {
  const HandoverTypesRoute()
      : super(
          HandoverTypesRoute.name,
          path: 'handover-types',
        );

  static const String name = 'HandoverTypesRoute';
}

/// generated route for
/// [SettingsPage]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute()
      : super(
          SettingsRoute.name,
          path: 'settings-page',
        );

  static const String name = 'SettingsRoute';
}
