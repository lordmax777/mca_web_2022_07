import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/hive.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';
import 'package:mca_web_2022_07/pages/home.dart';

import '../../../manager/general_controller.dart';
import '../../../manager/redux/states/auth_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../theme/theme.dart';

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      showLoading(barrierDismissible: false);
      final ApiResponse res = await appStore.dispatch(GetAccessTokenAction(
          domain: Constants.domain,
          username: nameController.text,
          password: passwordController.text));

      final isLoggedIn = GeneralController.to.isLoggedIn;

      if (isLoggedIn) {
        await HiveController.to.setAppDbVersion();
        appRouter.popAndPushAll([appInitRoute]);
        await closeLoading();
      } else {
        showError("Login Failed: ${res.rawError!.data['error_description']}");
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (kDebugMode) {
      nameController.text = Constants.username;
      passwordController.text = Constants.password;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
