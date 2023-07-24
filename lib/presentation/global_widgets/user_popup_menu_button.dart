import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import '../../manager/manager.dart';

class UserPopupMenuButton extends StatelessWidget {
  final String fullName;
  const UserPopupMenuButton({super.key, required this.fullName});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      tooltip: "User menu",
      offset: const Offset(0, 40),
      padding: const EdgeInsets.all(0),
      itemBuilder: (context) {
        return [
          //Account settings
          // PopupMenuItem(
          //   value: "account_settings",
          //   child: SpacedRow(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     horizontalSpace: 8,
          //     children: [
          //       Icon(Icons.settings, color: context.colorScheme.primary),
          //       const Text("Account settings"),
          //     ],
          //   ),
          // ),
          //Change password
          // PopupMenuItem(
          //   value: "change_password",
          //   child: SpacedRow(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     horizontalSpace: 8,
          //     children: [
          //       Icon(Icons.lock, color: context.colorScheme.primary),
          //       const Text("Change password"),
          //     ],
          //   ),
          // ),
          //Change language
          PopupMenuItem(
            value: "change_language",
            child: SpacedRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              horizontalSpace: 8,
              children: [
                Icon(Icons.language, color: context.colorScheme.primary),
                const Text("Change language"),
              ],
            ),
          ),
          // logout button
          PopupMenuItem(
            value: "logout",
            child: SpacedRow(
              horizontalSpace: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Icon(Icons.logout, color: Colors.red),
                Text("Logout"),
              ],
            ),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case "logout":
            //show logout dialog
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Logout"),
                  content: const Text("Are you sure?"),
                  actions: [
                    TextButton(
                      onPressed: context.pop,
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        DependencyManager.instance.navigation.loginState
                            .logout();
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                );
              },
            );
            break;
          // case "account_settings":
          //   context.go("/account");
          //   break;
          // case "change_password":
          //   context.showDialog(const ChangePasswordPopup());
          //   break;
          case "change_language":
            context.showDialog(const ChangeLanguagePopup());
            break;
        }
      },
      child: SpacedRow(
        horizontalSpace: 8,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: context.colorScheme.primary,
            ),
          ),
          Text(fullName,
              style:
                  context.textTheme.bodyLarge!.copyWith(color: Colors.white)),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }
}
