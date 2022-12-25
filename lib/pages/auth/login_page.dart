import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/pages/auth/controllers/login_controller.dart';

import '../../manager/hive.dart';
import '../../theme/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    HiveController.to.deleteRefreshToken();
    HiveController.to.deleteAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color(0xffe3e3e3), body: Center(child: Body()));
  }
}

class Body extends GetView<LoginController> {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return TableWrapperWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 6,
            horizontal: MediaQuery.of(context).size.height / 8),
        child: _formLogin(),
      ),
    );
  }

  Widget _formLogin() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          KText(
            mainAxisSize: MainAxisSize.min,
            text: "Sign In",
            textColor: ThemeColors.gray3,
            fontWeight: FWeight.medium,
            fontSize: 24,
          ),
          const SizedBox(height: 20),
          TextInputWidget(
            isRequired: true,
            leftIcon: HeroIcons.user,
            labelText: "Username",
            controller: controller.nameController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Username is required";
              }
              return null;
            },
          ),
          const SizedBox(height: 30),
          TextInputWidget(
            isRequired: true,
            leftIcon: HeroIcons.password,
            labelText: "Password",
            isPassword: true,
            controller: controller.passwordController,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return "Password is required";
              }
              return null;
            },
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 300,
            height: 40,
            child: ButtonLarge(
              text: "Login",
              onPressed: controller.login,
            ),
          )
        ],
      ),
    );
  }
}
