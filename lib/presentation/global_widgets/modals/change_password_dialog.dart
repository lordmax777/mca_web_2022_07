import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class ChangePasswordPopup extends StatefulWidget {
  const ChangePasswordPopup({super.key});

  @override
  State<ChangePasswordPopup> createState() => _ChangePasswordPopupState();
}

class _ChangePasswordPopupState extends State<ChangePasswordPopup>
    with FormsMixin<ChangePasswordPopup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Change Password'),
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),
      content: Form(
        key: formKey,
        child: UserCard(title: "", items: [
          UserCardItem(
            title: 'Old Password',
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
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
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
