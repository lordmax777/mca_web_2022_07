import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/pages/home_page.dart';
import 'package:mca_web_2022_07/pages/user/users_list_page.dart';

import '../../pages/user/user_details_page.dart';

@MaterialAutoRouter(
  // transitionsBuilder: TransitionsBuilders.fadeIn,
  routes: <AutoRoute>[
    AutoRoute(page: HomePage, initial: true, children: [
      AutoRoute(page: UsersListPage, path: "", name: "UsersListRoute"),
      AutoRoute(
          page: UserDetailsPage, path: "userDetail", name: "UserDetailsRoute"),
    ]),
  ],
)
// extend the generated private router
class $AppRouter {}
