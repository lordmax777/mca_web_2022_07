import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/auth_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';

import '../../../manager/general_controller.dart';
import '../../../manager/redux/states/auth_state.dart';
import '../../../theme/theme.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      showLoading();
      await fetch(GetAccessTokenAction(
          domain: Constants.domain,
          username: nameController.text,
          password: passwordController.text));

      final isLoggedIn = GeneralController.to.isLoggedIn;

      await closeLoading();
      if (isLoggedIn) {
        appRouter.replaceAll([
          const HomeRoute(children: [
            UsersListRoute(),
          ])
        ]);
      } else {
        showError("Login Failed");
      }
    }
  }

  @override
  void onReady() {
    super.onReady();

    nameController.text = Constants.username;
    passwordController.text = Constants.password;
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
