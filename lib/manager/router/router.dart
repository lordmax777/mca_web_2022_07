import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/router/route_guards.dart';
import 'package:mca_web_2022_07/pages/home_page.dart';
import 'package:mca_web_2022_07/pages/user/users_list_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../pages/auth/login_page.dart';
import '../../pages/user/user_details_page.dart';
import '../models/contract_md.dart';

part 'router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: LoginPage),
    AutoRoute(page: HomePage, initial: true, guards: [
      AuthGuard
    ], children: [
      AutoRoute(page: UsersListPage, path: ""),
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
    ]),
  ],
)
// extend the generated private router
class AppRouter extends _$AppRouter {
  AppRouter({required AuthGuard authGuard}) : super(authGuard: authGuard);
}
