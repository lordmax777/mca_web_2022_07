import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/router/route_guards.dart';
import 'package:mca_web_2022_07/pages/dashboard/dashboard_page.dart';
import 'package:mca_web_2022_07/pages/home.dart';
import 'package:mca_web_2022_07/pages/properties/new_property_page.dart';
import 'package:mca_web_2022_07/pages/quotes/quotes_list_page.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import 'package:mca_web_2022_07/pages/user/users_list_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../pages/approvals/approval_template_page.dart';
import '../../pages/auth/login_page.dart';
import '../../pages/checklist/checklist_list_page.dart';
import '../../pages/inventory/inventory_list_page.dart';
import '../../pages/settings/settings_page.dart';
import '../../pages/tests/test_page.dart';
import '../../pages/tiemsheet/tiemesheet_list_page.dart';
import '../../pages/tiemsheet/timesheet_summary_page.dart';
import '../../pages/tiemsheet/timesheet_user_shift_details_page.dart';
import '../../pages/user/user_details_page.dart';
import '../models/checklist_template_md.dart';
import '../models/contract_md.dart';
import '../models/property_md.dart';
import '../models/timesheet_dep_md.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    // Auth
    AutoRoute(page: LoginPage),

    AutoRoute(page: Home, name: "HomeRoute", initial: true, guards: [
      AuthGuard
    ], children: [
      AutoRoute(page: DashboardPage, path: ""),
      AutoRoute(page: TestPage, path: "test"),
      AutoRoute(page: UsersListPage, path: "users"),
      AutoRoute(page: UserDetailsPage, path: "user-detail"),
      AutoRoute(
          page: UserDetailsPayrollTabNewContractPage, path: "new-contract"),
      AutoRoute(page: DepartmentsListPage, path: "departments"),
      AutoRoute(page: QualificationsPage, path: "qualifications"),
      AutoRoute(page: LocationsListPage, path: "locations"),
      AutoRoute(page: NewLocationPage, path: "new-location"),
      AutoRoute(page: WarehousesListPage, path: "warehouses"),
      AutoRoute(page: StockItemsListPage, path: "stock-items"),
      AutoRoute(page: ChecklistTemplatesPage, path: "checklist-templates"),
      AutoRoute(page: NewChecklistTemplatePage, path: "new-checklist-template"),
      AutoRoute(page: HandoverTypesPage, path: "handover-types"),
      AutoRoute(page: TimesheetListPage, path: "timesheet"),
      AutoRoute(page: SettingsPage, path: "settings-page"),
      AutoRoute(page: PropertiesPage, path: "properties"),
      AutoRoute(page: NewPropertyPage, path: "property"),
      AutoRoute(page: SchedulingPage, path: "schedule"),
      AutoRoute(page: QuotesListPage, path: "quotes"),
      AutoRoute(page: ApprovalTemplatePage, path: "approval"),
      AutoRoute(page: InventoryListPage, path: "inventory"),
      AutoRoute(
          page: TimesheetUserShiftDetailsPage, path: "timesheet-shift-details"),
      AutoRoute(page: TimesheetSummaryPage, path: "timesheet-summary"),
      AutoRoute(page: ChecklistListPage, path: "checklist-list"),
    ]),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter {
  AppRouter({required AuthGuard authGuard}) : super(authGuard: authGuard);
}

const appInitRoute = HomeRoute(children: [DashboardRoute()]);
