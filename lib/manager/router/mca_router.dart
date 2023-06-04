import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/pages/auth/login_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import 'mca_routes.dart';

typedef _Redirect = FutureOr<String?> Function(
    BuildContext context, GoRouterState state);

typedef _Page = Page<dynamic> Function(
    BuildContext context, GoRouterState state);

class MCARouter {
  final MCALoginState loginState;

  MCARouter({required this.loginState});

  late final router = GoRouter(
    refreshListenable: loginState,
    debugLogDiagnostics: true,
    routes: [
      _route(
        path: MCARoutes.root,
        redirect: (context, state) =>
            // TODO: Change to Home Route
            state.namedLocation(MCARoutes.root),
      ),
      _route(
        path: MCARoutes.login,
        pageBuilder: (context, state) {
          return MaterialPage<void>(
            key: state.pageKey,
            child: const LoginPage(),
          );
        },
      )
    ],
    errorPageBuilder: (context, state) => MaterialPage<void>(
      key: state.pageKey,
      //TODO: Handle error
      child: Scaffold(
          body: Center(
        child: Text(
          'Page not found: ${state.path}\n'
          'This is the default error page.\n',
          style: const TextStyle(fontSize: 24),
        ),
      )),
    ),

    //TODO: Add redirect
    redirect: (context, state) {
      final loginLoc = state.namedLocation(MCARoutes.login.substring(1));
      final loggingIn = state.location == loginLoc;
      final loggedIn = loginState.isLoggedIn;
      final rootLoc = state.namedLocation(MCARoutes.root.substring(1));

      if (!loggedIn && !loggingIn) return loginLoc;
      if (loggedIn && loggingIn) return rootLoc;
      return null;
    },
  );

  GoRoute _route(
      {required String path, _Redirect? redirect, _Page? pageBuilder}) {
    logger(path);
    logger(path.substring(1));
    return GoRoute(
      path: path,
      name: path.substring(1),
      redirect: redirect,
      pageBuilder: pageBuilder,
    );
  }
}
