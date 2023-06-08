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
  static LoginController get to {
    if (Get.isRegistered<LoginController>()) {
      return Get.find<LoginController>();
    } else {
      return Get.put<LoginController>(LoginController());
    }
  }

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool _isTestMode = false.obs;
  bool get isTestMode => _isTestMode.value;
  set isTestMode(bool value) => _isTestMode.value = value;

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

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      showLoading(barrierDismissible: false);
      final ApiResponse res = await appStore.dispatch(GetAccessTokenAction(
        domain: Constants.domain,
        username: nameController.text,
        password: passwordController.text,
        isTestMode: isTestMode,
      ));

      final isLoggedIn = GeneralController.to.isLoggedIn;

      await closeLoading();
      if (isLoggedIn) {
        await HiveController.to.setAppDbVersion();
        appRouter.popAndPushAll([appInitRoute]);
      } else {
        await closeLoading();
        try {
          showError("Login Failed: ${res.rawError?.data['error_description']}");
        } catch (e) {
          showError("Something went wrong!");
        }
      }
    }
  }

  void toggleTestMode() {
    isTestMode = !isTestMode;
    // nameController.text = "";
    // passwordController.text = "";
  }
}
