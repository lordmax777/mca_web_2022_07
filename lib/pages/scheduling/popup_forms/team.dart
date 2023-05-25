import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

import '../../../manager/models/unavailable_user_md.dart';
import '../../../manager/models/users_list.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../manager/redux/states/users_state/users_state.dart';
import '../../../theme/theme.dart';
import '../scheduling_page.dart';

class JobTeam extends StatefulWidget {
  final void Function(int userId) onUnavUserFetchComplete;
  final void Function(List<UserRes> users) onTeamMemberAdded;
  final List<UserRes> users;
  final DateTime date;
  final Map<UserRes, double> addedChildren;
  const JobTeam({
    Key? key,
    required this.onUnavUserFetchComplete,
    required this.onTeamMemberAdded,
    required this.date,
    required this.users,
    required this.addedChildren,
  }) : super(key: key);

  @override
  State<JobTeam> createState() => _JobTeamState();
}

class _JobTeamState extends State<JobTeam> {
  //Getters
  DateTime get date => widget.date;
  List<UserRes> get users => widget.users;
  Map<UserRes, double> get addedChildren => widget.addedChildren;
  UnavailableUserLoad unavailableUsers = UnavailableUserLoad();

  Future<List<UserRes>?> onEditTeamMember() async {
    //Show a dialog which will allow the user to select team members from users list.
    // The content must contain a search box and a list of users.
    return await showDialog<List<UserRes>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final filteredUsers = [...users];
        final addedUsers = <UserRes>[...addedChildren.keys.toList()];
        return StatefulBuilder(builder: (context, ss) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            title: Row(
              children: [
                const Text("Select team members"),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, addedUsers);
                },
                child: const Text("Save"),
              ),
            ],
            content: SizedBox(
              height: 500,
              width: 400,
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) {
                      //Filter the users list based on the search term.
                      if (val.isEmpty) {
                        ss(() {
                          filteredUsers.clear();
                          filteredUsers.addAll(users);
                        });
                        return;
                      }
                      ss(() {
                        filteredUsers.retainWhere((element) => element.fullname
                            .toLowerCase()
                            .contains(val.toLowerCase()));
                      });
                    },
                  ),
                  Expanded(
                    child: filteredUsers.isEmpty
                        ? const Center(child: Text("Not found"))
                        : ListView.builder(
                            padding: const EdgeInsets.only(top: 8),
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              final user = filteredUsers[index];
                              final bool isAdded = addedUsers
                                  .any((element) => element.id == user.id);
                              final UnavailableUserMd? unavUser =
                                  unavailableUsers.users.firstWhereOrNull(
                                      (element) => element.userId == user.id);
                              final bool isUnavailable = unavUser != null &&
                                  unavUser.userId == user.id;
                              return ListTile(
                                  onTap: null,
                                  leading: CircleAvatar(
                                    backgroundColor: user.userRandomBgColor,
                                    child: Text(user.initials,
                                        style: TextStyle(
                                            color: user.foregroundColor)),
                                  ),
                                  title: Text(user.fullname,
                                      style: TextStyle(
                                          color: isUnavailable
                                              ? Colors.grey
                                              : Colors.black)),
                                  subtitle: isUnavailable
                                      ? Text(
                                          unavUser.unavailable
                                              .map((e) => e.reason)
                                              .join(", "),
                                          style: const TextStyle(
                                              color: Colors.red))
                                      : null,
                                  trailing: isUnavailable
                                      ? const Chip(
                                          label: Text("Unavailable"),
                                          labelStyle:
                                              TextStyle(color: Colors.grey))
                                      : IconButton(
                                          onPressed: () {
                                            if (isAdded) {
                                              addedUsers.removeWhere(
                                                  (element) =>
                                                      element.id == user.id);
                                            } else {
                                              addedUsers.add(user);
                                            }
                                            ss(() {});
                                          },
                                          icon: isAdded
                                              ? const Icon(Icons.remove,
                                                  color: Colors.red)
                                              : const Icon(Icons.add,
                                                  color: Colors.green),
                                        ));
                            },
                          ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _getUnavUsers() async {
    final unavUsers = await appStore.dispatch(GetUnavailableUsersAction(date));
    if (mounted) {
      setState(() {
        unavailableUsers.users = unavUsers;
        for (var u in unavailableUsers.users) {
          widget.onUnavUserFetchComplete(u.userId);
        }
      });
    }
  }

  @override
  void didUpdateWidget(covariant JobTeam oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _getUnavUsers();
  }

  @override
  void initState() {
    super.initState();
    _getUnavUsers();
  }

  @override
  void dispose() {
    unavailableUsers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 32, left: 8, bottom: 8),
          child: Wrap(
            alignment: WrapAlignment.start,
            direction: Axis.horizontal,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (!unavailableUsers.isLoaded)
                const Center(child: Text("Please wait loading...")),
              if (unavailableUsers.isLoaded)
                ...addedChildren.entries.map((e) {
                  final user = e.key;
                  final rate = e.value;
                  bool isRateAdded = rate > 0;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        addIcon(
                          tooltip:
                              "${!isRateAdded ? "Add" : "Remove"} Special Rate",
                          onPressed: () {
                            setState(() {
                              if (isRateAdded) {
                                addedChildren[user] = -1;
                              } else {
                                addedChildren[user] = 1;
                              }
                            });
                          },
                          icon: !isRateAdded ? HeroIcons.dollar : HeroIcons.bin,
                        ),
                        if (isRateAdded)
                          TextFormField(
                            decoration: const InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(),
                              labelText: "Rate",
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              constraints: BoxConstraints(
                                maxWidth: 120,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            initialValue: rate.toStringAsFixed(0),
                            onChanged: (value) {
                              setState(() {
                                final rate = double.tryParse(value);
                                if (rate == null) return;
                                addedChildren[user] = rate;
                              });
                            },
                          ),
                        const SizedBox(width: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InputChip(
                            label: Text(user.fullname),
                            labelStyle: TextStyle(color: user.foregroundColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            deleteButtonTooltipMessage: "Remove",
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            deleteIcon: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: user.foregroundColor.withOpacity(.2),
                                border: Border.all(
                                  color: user.foregroundColor.withOpacity(.2),
                                ),
                              ),
                              child: const Icon(Icons.close),
                            ),
                            deleteIconColor: user.foregroundColor,
                            onDeleted: () {
                              setState(() {
                                addedChildren.remove(user);
                              });
                            },
                            backgroundColor: user.userRandomBgColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList()
            ],
          ),
        ),
        if (unavailableUsers.isLoaded)
          Align(
            alignment: Alignment.topCenter,
            child: // else if (addedChildren.isEmpty)
                TextButton(
              onPressed: () async {
                List<UserRes>? addedUsers = await onEditTeamMember();
                if (addedUsers == null) return;
                widget.onTeamMemberAdded(addedUsers);
              },
              child: const Text("Add team member"),
            ),
          ),
      ],
    );
  }
}
