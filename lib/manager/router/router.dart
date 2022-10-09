import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/pages/home_page.dart';
import 'package:mca_web_2022_07/pages/user/users_list_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../../pages/user/user_details_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true, children: [
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
class $AppRouter {}
