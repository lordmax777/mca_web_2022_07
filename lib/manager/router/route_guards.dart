import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/hive.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';
import '../redux/sets/app_state.dart';
import '../redux/states/auth_state.dart';

class AuthGuard extends AutoRedirectGuard {
  static bool isLoaded = false;
  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    final isLoggedIn = HiveController.to.isUserLoggedIn;
    if (isLoggedIn) {
      //Do login again using refresh token
      if (!isLoaded) {
        await appStore.dispatch(GetRefreshTokenAction());
        isLoaded = true;
      }
      resolver.next();
    } else {
      router.replaceAll([const LoginRoute()]);
    }
  }

  @override
  Future<bool> canNavigate(RouteMatch route) {
    throw UnimplementedError();
  }
}
