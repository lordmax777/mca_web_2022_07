import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/pages/home_page.dart';
import 'package:mca_web_2022_07/pages/users_list_page.dart';

@MaterialAutoRouter(
  // transitionsBuilder: TransitionsBuilders.fadeIn,
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true, children: [
      AutoRoute(page: UsersListPage, path: "", name: "UsersListPage"),
    ]),
  ],
)
// extend the generated private router
class $AppRouter {}
