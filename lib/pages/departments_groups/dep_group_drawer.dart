import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:faker/faker.dart';
import 'package:mca_web_2022_07/manager/models/list_all_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../../manager/models/users_list.dart';
import '../../theme/theme.dart';

class DepGroupDrawer extends StatefulWidget {
  final ListGroup? group;
  final ListJobTitle? department;
  const DepGroupDrawer({Key? key, this.group, this.department})
      : super(key: key);

  @override
  State<DepGroupDrawer> createState() => _DepGroupDrawerState();
}

class _DepGroupDrawerState extends State<DepGroupDrawer> {
  final List<UserRes> items = [];
  final List<UserRes> backupItems = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    items.clear();
    final users = appStore.state.usersState.usersList.data!;
    if (widget.group != null) {
      for (var user in users) {
        if (user.groupId == widget.group?.id.toString()) {
          items.add(user);
        }
      }
    } else {
      for (var user in users) {
        if (user.groupId == widget.department?.id.toString()) {
          items.add(user);
        }
      }
    }
    backupItems.clear();
    backupItems.addAll(items);
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        setState(() {
          items.clear();
          items.addAll(backupItems);
        });
      }
    });
    _onSearch();
  }

  void _onSearch() {
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isNotEmpty) {
          items.clear();
          items.addAll(backupItems.where((element) {
            return element.fullname
                .toLowerCase()
                .contains((_searchController.text.toLowerCase()));
          }).toList());
          if (items.isEmpty) {
            items.addAll(backupItems.where((element) {
              return element.username
                  .toLowerCase()
                  .contains((_searchController.text.toLowerCase()));
            }).toList());
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 535,
      backgroundColor: ThemeColors.white,
      elevation: 0.8,
      child: SpacedColumn(
        children: [
          _header(),
          const Divider(
            height: 1.0,
            thickness: 1.0,
            color: ThemeColors.gray11,
          ),
          _body(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 440,
              child: KText(
                isSelectable: false,
                text: widget.group != null
                    ? widget.group!.name
                    : widget.department!.name,
                fontSize: 18.0,
                textColor: ThemeColors.gray2,
                fontWeight: FWeight.bold,
              ),
            ),
            InkWell(
                child: const HeroIcon(
                  HeroIcons.x,
                  size: 16.0,
                  color: ThemeColors.gray5,
                ),
                onTap: () {
                  context.popRoute();
                }),
          ]),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SpacedColumn(children: [
        TextInputWidget(
            hintText: "Search users by name...",
            controller: _searchController,
            defaultBorderColor: ThemeColors.gray11,
            width: double.infinity,
            onChanged: (value) => _onSearch(),
            leftIcon: HeroIcons.search),
        const SizedBox(height: 16.0),
        if (items.isEmpty)
          KText(
              text: "No users found",
              textColor: ThemeColors.gray5,
              fontSize: 14.0,
              fontWeight: FWeight.bold)
        else
          SizedBox(
            height: MediaQuery.of(context).size.height - 200,
            width: double.infinity,
            child: ListView.builder(
                itemBuilder: _itemBuilder, itemCount: items.length),
          ),
      ]),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    final user = items[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: user.userRandomBgColor,
            maxRadius: 24.0,
            child: KText(
              fontSize: 16.0,
              isSelectable: false,
              textColor: ThemeColors.black,
              fontWeight: FWeight.bold,
              text:
                  "${user.firstName.substring(0, 1)}${user.lastName.substring(0, 1)}"
                      .toUpperCase(),
            ),
          ),
          const SizedBox(width: 16.0),
          SpacedColumn(
            verticalSpace: 4.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(
                text: user.fullname,
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                fontWeight: FWeight.bold,
              ),
              KText(
                text: user.username,
                fontSize: 14.0,
                textColor: ThemeColors.black,
                fontWeight: FWeight.regular,
              ),
              // SpacedRow(horizontalSpace: 16.0, children: [
              //   SpacedRow(
              //       horizontalSpace: 4.0,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         const HeroIcon(
              //           HeroIcons.clock,
              //           color: ThemeColors.gray6,
              //           size: 12.0,
              //         ),
              //         KText(
              //           isSelectable: false,
              //           text: '${items[index]['time']}',
              //           fontSize: 12.0,
              //           fontWeight: FWeight.medium,
              //           textColor: ThemeColors.gray6,
              //         ),
              //       ]),
              //   SpacedRow(
              //       horizontalSpace: 4.0,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         const HeroIcon(
              //           HeroIcons.briefcase,
              //           color: ThemeColors.gray6,
              //           size: 12.0,
              //         ),
              //         KText(
              //           isSelectable: false,
              //           text: '${items[index]['items']}',
              //           fontSize: 12.0,
              //           fontWeight: FWeight.medium,
              //           textColor: ThemeColors.gray6,
              //         ),
              //       ]),
              //   SpacedRow(
              //       horizontalSpace: 4.0,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         const HeroIcon(
              //           HeroIcons.pound,
              //           color: ThemeColors.gray6,
              //           size: 12.0,
              //         ),
              //         KText(
              //           isSelectable: false,
              //           text: '${items[index]['price']}',
              //           fontSize: 12.0,
              //           fontWeight: FWeight.medium,
              //           textColor: ThemeColors.gray6,
              //         ),
              //       ]),
              // ]),
            ],
          ),
        ],
      ),
    );
  }
}
