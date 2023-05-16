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
        child: const Home(),
      );
    },
    DashboardRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const DashboardPage(),
      );
    },
    TestRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const TestPage(),
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
          checklist: args.checklist,
        ),
      );
    },
    HandoverTypesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const HandoverTypesPage(),
      );
    },
    TimesheetListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const TimesheetListPage(),
      );
    },
    SettingsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SettingsPage(),
      );
    },
    PropertiesRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const PropertiesPage(),
      );
    },
    NewPropertyRoute.name: (routeData) {
      final args = routeData.argsAs<NewPropertyRouteArgs>(
          orElse: () => const NewPropertyRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: NewPropertyPage(
          key: args.key,
          property: args.property,
        ),
      );
    },
    SchedulingRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const SchedulingPage(),
      );
    },
    QuotesListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const QuotesListPage(),
      );
    },
    ApprovalTemplateRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const ApprovalTemplatePage(),
      );
    },
    InventoryListRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const InventoryListPage(),
      );
    },
    TimesheetUserShiftDetailsRoute.name: (routeData) {
      final args = routeData.argsAs<TimesheetUserShiftDetailsRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: TimesheetUserShiftDetailsPage(
          key: args.key,
          timesheetDep: args.timesheetDep,
        ),
      );
    },
    TimesheetSummaryRoute.name: (routeData) {
      final args = routeData.argsAs<TimesheetSummaryRouteArgs>(
          orElse: () => const TimesheetSummaryRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: TimesheetSummaryPage(key: args.key),
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
              DashboardRoute.name,
              path: '',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              TestRoute.name,
              path: 'test',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              UsersListRoute.name,
              path: 'users',
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
              TimesheetListRoute.name,
              path: 'timesheet',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              SettingsRoute.name,
              path: 'settings-page',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              PropertiesRoute.name,
              path: 'properties',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              NewPropertyRoute.name,
              path: 'property',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              SchedulingRoute.name,
              path: 'schedule',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              QuotesListRoute.name,
              path: 'quotes',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              ApprovalTemplateRoute.name,
              path: 'approval',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              InventoryListRoute.name,
              path: 'inventory',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              TimesheetUserShiftDetailsRoute.name,
              path: 'timesheet-shift-details',
              parent: HomeRoute.name,
            ),
            RouteConfig(
              TimesheetSummaryRoute.name,
              path: 'timesheet-summary',
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
/// [Home]
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
/// [DashboardPage]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute()
      : super(
          DashboardRoute.name,
          path: '',
        );

  static const String name = 'DashboardRoute';
}

/// generated route for
/// [TestPage]
class TestRoute extends PageRouteInfo<void> {
  const TestRoute()
      : super(
          TestRoute.name,
          path: 'test',
        );

  static const String name = 'TestRoute';
}

/// generated route for
/// [UsersListPage]
class UsersListRoute extends PageRouteInfo<void> {
  const UsersListRoute()
      : super(
          UsersListRoute.name,
          path: 'users',
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
    ChecklistTemplateMd? checklist,
  }) : super(
          NewChecklistTemplateRoute.name,
          path: 'new-checklist-template',
          args: NewChecklistTemplateRouteArgs(
            key: key,
            checklist: checklist,
          ),
        );

  static const String name = 'NewChecklistTemplateRoute';
}

class NewChecklistTemplateRouteArgs {
  const NewChecklistTemplateRouteArgs({
    this.key,
    this.checklist,
  });

  final Key? key;

  final ChecklistTemplateMd? checklist;

  @override
  String toString() {
    return 'NewChecklistTemplateRouteArgs{key: $key, checklist: $checklist}';
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
/// [TimesheetListPage]
class TimesheetListRoute extends PageRouteInfo<void> {
  const TimesheetListRoute()
      : super(
          TimesheetListRoute.name,
          path: 'timesheet',
        );

  static const String name = 'TimesheetListRoute';
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

/// generated route for
/// [PropertiesPage]
class PropertiesRoute extends PageRouteInfo<void> {
  const PropertiesRoute()
      : super(
          PropertiesRoute.name,
          path: 'properties',
        );

  static const String name = 'PropertiesRoute';
}

/// generated route for
/// [NewPropertyPage]
class NewPropertyRoute extends PageRouteInfo<NewPropertyRouteArgs> {
  NewPropertyRoute({
    Key? key,
    PropertiesMd? property,
  }) : super(
          NewPropertyRoute.name,
          path: 'property',
          args: NewPropertyRouteArgs(
            key: key,
            property: property,
          ),
        );

  static const String name = 'NewPropertyRoute';
}

class NewPropertyRouteArgs {
  const NewPropertyRouteArgs({
    this.key,
    this.property,
  });

  final Key? key;

  final PropertiesMd? property;

  @override
  String toString() {
    return 'NewPropertyRouteArgs{key: $key, property: $property}';
  }
}

/// generated route for
/// [SchedulingPage]
class SchedulingRoute extends PageRouteInfo<void> {
  const SchedulingRoute()
      : super(
          SchedulingRoute.name,
          path: 'schedule',
        );

  static const String name = 'SchedulingRoute';
}

/// generated route for
/// [QuotesListPage]
class QuotesListRoute extends PageRouteInfo<void> {
  const QuotesListRoute()
      : super(
          QuotesListRoute.name,
          path: 'quotes',
        );

  static const String name = 'QuotesListRoute';
}

/// generated route for
/// [ApprovalTemplatePage]
class ApprovalTemplateRoute extends PageRouteInfo<void> {
  const ApprovalTemplateRoute()
      : super(
          ApprovalTemplateRoute.name,
          path: 'approval',
        );

  static const String name = 'ApprovalTemplateRoute';
}

/// generated route for
/// [InventoryListPage]
class InventoryListRoute extends PageRouteInfo<void> {
  const InventoryListRoute()
      : super(
          InventoryListRoute.name,
          path: 'inventory',
        );

  static const String name = 'InventoryListRoute';
}

/// generated route for
/// [TimesheetUserShiftDetailsPage]
class TimesheetUserShiftDetailsRoute
    extends PageRouteInfo<TimesheetUserShiftDetailsRouteArgs> {
  TimesheetUserShiftDetailsRoute({
    Key? key,
    required TimesheetDepMd timesheetDep,
  }) : super(
          TimesheetUserShiftDetailsRoute.name,
          path: 'timesheet-shift-details',
          args: TimesheetUserShiftDetailsRouteArgs(
            key: key,
            timesheetDep: timesheetDep,
          ),
        );

  static const String name = 'TimesheetUserShiftDetailsRoute';
}

class TimesheetUserShiftDetailsRouteArgs {
  const TimesheetUserShiftDetailsRouteArgs({
    this.key,
    required this.timesheetDep,
  });

  final Key? key;

  final TimesheetDepMd timesheetDep;

  @override
  String toString() {
    return 'TimesheetUserShiftDetailsRouteArgs{key: $key, timesheetDep: $timesheetDep}';
  }
}

/// generated route for
/// [TimesheetSummaryPage]
class TimesheetSummaryRoute extends PageRouteInfo<TimesheetSummaryRouteArgs> {
  TimesheetSummaryRoute({Key? key})
      : super(
          TimesheetSummaryRoute.name,
          path: 'timesheet-summary',
          args: TimesheetSummaryRouteArgs(key: key),
        );

  static const String name = 'TimesheetSummaryRoute';
}

class TimesheetSummaryRouteArgs {
  const TimesheetSummaryRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'TimesheetSummaryRouteArgs{key: $key}';
  }
}
