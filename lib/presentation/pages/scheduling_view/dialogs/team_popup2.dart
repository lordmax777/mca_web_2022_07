import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';

class TeamPopup2 extends StatefulWidget {
  final List<UserMd> addedUsers;
  final List<UserMd> unavailableUsers;

  const TeamPopup2(
      {super.key, required this.addedUsers, required this.unavailableUsers});

  @override
  State<TeamPopup2> createState() => _TeamPopup2State();
}

class _TeamPopup2State extends State<TeamPopup2> {
  final List<UserMd> addedUsers = [];
  final filteredUsers = <UserMd>[];

  List<UserMd> get unavailableUsers => widget.unavailableUsers;

  @override
  void initState() {
    addedUsers.addAll(widget.addedUsers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<UserMd>>(
      converter: (store) => store.state.generalState.users,
      onInit: (store) {
        final users = [...store.state.generalState.users];
        filteredUsers.addAll(users);
      },
      builder: (context, vm) {
        final users = [...vm];
        return AlertDialog(
          title: const Text('Edit Team'),
          scrollable: true,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SearchBar(
                hintText: 'Filter users',
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      filteredUsers.clear();
                      filteredUsers.addAll(users);
                      return;
                    }
                    filteredUsers.clear();
                    filteredUsers.addAll(users.where((element) => element
                        .fullname
                        .toLowerCase()
                        .contains(value.toLowerCase())));
                  });
                },
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(width: .5, color: Colors.grey),
                )),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      final bool isAdded =
                          addedUsers.any((element) => element.id == user.id);
                      return ListTile(
                        enabled: !user.unavailability.isUnavailable,
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        title: Text(
                          user.fullname,
                        ),
                        subtitle: user.unavailability.reason != null
                            ? Text(
                                user.unavailability.reason!,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              )
                            : null,
                        trailing: IconButton(
                          onPressed: user.unavailability.isUnavailable
                              ? null
                              : () {
                                  //add/remove user
                                  if (isAdded) {
                                    addedUsers.removeWhere(
                                        (element) => element.id == user.id);
                                  } else {
                                    addedUsers.add(user.copyWith());
                                  }
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                          icon: Icon(
                            isAdded ? Icons.remove : Icons.add,
                            color: user.unavailability.isUnavailable
                                ? null
                                : isAdded
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      );
                    },
                    itemCount: filteredUsers.length),
              ),
              const Divider(color: Colors.grey),
            ],
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
                context.pop(addedUsers
                    // ..users.sort((a, b) {
                    //   return a.fullname.compareTo(b.fullname);
                    // })
                    );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
