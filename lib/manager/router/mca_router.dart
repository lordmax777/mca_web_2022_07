import 'dart:async';
import 'package:mca_web_2022_07/pages/auth/login_page.dart';
import 'package:mca_web_2022_07/pages/home.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:provider/provider.dart';

import 'mca_routes.dart';

typedef _Redirect = FutureOr<String?> Function(
    BuildContext context, GoRouterState state);

typedef _Page = Page<dynamic> Function(
    BuildContext context, GoRouterState state);

class MCARouter {
  late final router = GoRouter(
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: "/",
        name: "root",
        redirect: (state, context) => state.namedLocation(MCARoutes.home),
      ),
      _route(
        path: MCARoutes.login,
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
          );
        },
      ),
      _route(
        path: MCARoutes.home,
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const Home(),
          );
        },
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      child: Scaffold(
          body: Center(
        child: Text(
          'Page not found: ${state.path}\n'
          'This is the default error page.\n',
          style: const TextStyle(fontSize: 24),
        ),
      )),
    ),
    redirect: (context, state) {
      //locations
      final loginLoc = state.namedLocation(MCARoutes.login.substring(1));
      final homeLoc = state.namedLocation(MCARoutes.home.substring(1));

      //checking if logged in
      final loggedIn = Provider.of<MCALoginState>(context).isLoggedIn;

      //checking if logging in
      final loggingIn = state.location == loginLoc;

      //returning location
      if (!loggedIn && !loggingIn) return loginLoc;
      if (loggedIn && loggingIn) return homeLoc;
      return null;
    },
  );

  GoRoute _route(
      {required String path, _Redirect? redirect, _Page? pageBuilder}) {
    return GoRoute(
      path: path,
      name: path.substring(1),
      redirect: redirect,
      pageBuilder: pageBuilder,
    );
  }
}
