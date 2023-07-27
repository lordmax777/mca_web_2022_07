import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class ChangeLanguagePopup extends StatefulWidget {
  const ChangeLanguagePopup({super.key});

  @override
  State<ChangeLanguagePopup> createState() => _ChangeLanguagePopupState();
}

class _ChangeLanguagePopupState extends State<ChangeLanguagePopup>
    with FormsMixin<ChangeLanguagePopup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then((value) {
      if (mounted) {
        final locale = appStore.state.generalState.detailsMd.locale;
        final loc =
            languages.firstWhereOrNull((element) => element.code == locale);
        setState(() {
          if (loc != null) {
            selected1 = DefaultMenuItem(
              id: 0,
              title: loc.name,
              additionalId: loc.code,
            );
          }
        });
      }
    });
  }

  final languages = [...appStore.state.generalState.languages];

  @override
  Widget build(BuildContext context) {
    logger(languages.length);
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Change language'),
          IconButton(
            onPressed: context.pop,
            icon: const Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),
      content: UserCard(title: "", items: [
        UserCardItem(
          title: "Language",
          dropdown: UserCardDropdown(
            label: selected1?.title,
            additionalValueId: selected1?.additionalId,
            onChanged: (value) {
              setState(() {
                selected1 = value;
              });
            },
            items: [
              for (int i = 0; i < languages.length; i++)
                DefaultMenuItem(
                  id: i,
                  title: languages[i].name,
                  additionalId: languages[i].code,
                )
            ],
          ),
        )
      ]),
      actions: [
        TextButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (selected1 == null) {
              context.showError('Please select language');
              return;
            }
            context.futureLoading(() async {
              final res = await dispatch<bool>(
                  ChangeLanguageAction(selected1!.additionalId!));
              if (res.isLeft && res.left) {
                context.showSuccess('Language changed successfully',
                    onClose: () {
                  context.pop(true);
                });
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
