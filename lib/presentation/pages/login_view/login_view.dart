import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'login_view_vc.dart';
export 'login_view_helper.dart';
export 'login_view_vc.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginViewVc vc = LoginViewVc();

  final loginActivator = const SingleActivator(LogicalKeyboardKey.enter);

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        loginActivator: vc.login,
      },
      child: ListenableBuilder(
        listenable: vc,
        builder: (context, child) {
          if (vc.deps.navigation.loginState.isLoggingIn) {
            return Scaffold(
                body: Center(
                    child: Text(
              "Please wait loading...",
              style: context.textTheme.titleLarge,
            )));
          }
          return Scaffold(
            body: Center(
              child: SizedBox(
                width: 600,
                height: 400,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  surfaceTintColor: Theme.of(context).cardColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 64),
                    child: Form(
                      key: vc.formKey,
                      child: SpacedColumn(
                        verticalSpace: 16,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Show Title, Username field, Password field, checkbox for is test mode and a button for login
                          Text(
                            'Login',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          DefaultTextField(
                            label: "Username",
                            width: double.infinity,
                            controller: vc.usernameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username cannot be empty.';
                              }
                              return null;
                            },
                          ),
                          DefaultTextField(
                            label: "Password",
                            width: double.infinity,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            controller: vc.passwordController,
                          ),
                          DefaultSwitch(
                            label: 'Test Mode',
                            onChanged: (value) => vc.isTestMode = value,
                            value: vc.isTestMode,
                          ),
                          FilledButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                  horizontal: 60,
                                  vertical: 10,
                                ),
                              ),
                            ),
                            onPressed: vc.login,
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
