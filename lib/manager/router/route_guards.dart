import 'package:auto_route/auto_route.dart';

class AuthGuard extends AutoRedirectGuard {
  static bool isLoaded = false;
  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    resolver.next();
  }

  @override
  Future<bool> canNavigate(RouteMatch route) {
    throw UnimplementedError();
  }
}
