import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class ChangePasswordTab extends StatefulWidget {
  const ChangePasswordTab({super.key});

  @override
  State<ChangePasswordTab> createState() => _ChangePasswordTabState();
}

class _ChangePasswordTabState extends State<ChangePasswordTab>
    with FormsMixin<ChangePasswordTab> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      alignment: Alignment.topCenter,
      content: Form(
        key: formKey,
        child: UserCard(width: context.width * .6, title: "", items: [
          UserCardItem(
            title: 'Current Password',
            controller: controller1,
            isRequired: true,
            isObscured: true,
          ),
          UserCardItem(
            title: 'New Password',
            controller: controller2,
            isRequired: true,
            isObscured: true,
          ),
          UserCardItem(
            title: 'Confirm Password',
            controller: controller3,
            isRequired: true,
            isObscured: true,
          ),
        ]),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            //todo:
            if (!isFormValid) return;
            if (controller2.text != controller3.text) {
              context.showError('Passwords do not match');
              return;
            }
            context.futureLoading(() async {
              final res = await dispatch<bool>(ChangeAccountPasswordAction(
                oldPassword: controller1.text,
                newPassword: controller2.text,
              ));
              if (res.isLeft && res.left) {
                context.pop(true);
              } else if (res.isRight) {
                context.showError(res.right.message);
              } else {
                context.showError('Something went wrong');
              }
            });
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
