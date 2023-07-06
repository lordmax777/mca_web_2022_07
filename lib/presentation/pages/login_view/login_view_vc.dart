import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/redux/redux.dart';
import 'package:mca_dashboard/utils/utils.dart';

import '../../../manager/manager.dart';

class LoginViewVc extends ChangeNotifier {
  final deps = DependencyManager.instance;

  final formKey = GlobalKey<FormState>();
  final TextEditingController usernameController =
      TextEditingController(text: GlobalConstants.debugusername);
  final TextEditingController passwordController =
      TextEditingController(text: GlobalConstants.debugpassword);

  bool get isTestMode => deps.db.getIsTestMode();

  set isTestMode(bool value) {
    deps.db.setIsTestMode(value);
    notifyListeners();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    deps.navigation.futureLoading(() async {
      final res = await dispatch<TokenMd>(
          GetLoginAction(usernameController.text, passwordController.text));
      res.fold((left) {
        // //Success
        print("Login success ${left.toJson()}");
        deps.navigation.loginState.login();
      }, (right) {
        // //Error
        deps.navigation.showFail(right.message);
      });
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
