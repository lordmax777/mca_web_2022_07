import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/models/list_all_md.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

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
  final List<Map> items = [];
  final List<Map> backupItems = [];

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
        if (user.groupId == widget.group!.id.toString()) {
          items.add({
            "name": user.fullname,
            "time": "NO_TIME", //TODO:
            "items": "NO_ITEMS", //TODO:
            "price": "NO_PRICE", //TODO:
          });
        }
      }
    } else {
      for (var user in users) {
        if (user.groupId == widget.department!.id.toString()) {
          items.add({
            "name": user.fullname,
            "time": "NO_TIME", //TODO:
            "items": "NO_ITEMS", //TODO:
            "price": "NO_PRICE", //TODO:
          });
        }
      }
    }
    backupItems.clear();
    backupItems.addAll(items);

    _onSearch();
  }

  void _onSearch() {
    _searchController.addListener(() {
      setState(() {
        if (_searchController.text.isNotEmpty) {
          items.addAll(backupItems.where((element) {
            return element['name']
                .toLowerCase()
                .contains(RegExp(_searchController.text.toLowerCase()));
          }).toList());
        }
        items.clear();
        items.addAll(backupItems);
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
            KText(
              isSelectable: false,
              text: widget.group != null
                  ? widget.group!.name
                  : widget.department!.name,
              fontSize: 18.0,
              textColor: ThemeColors.gray2,
              fontWeight: FWeight.bold,
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
            // onChanged: (value) => _onSearch(),
            leftIcon: HeroIcons.search),
        const SizedBox(height: 16.0),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const HeroIcon(
            HeroIcons.user,
            size: 48.0,
            color: ThemeColors.gray5,
          ),
          const SizedBox(width: 16.0),
          SpacedColumn(
            verticalSpace: 4.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KText(
                isSelectable: false,
                text: items[index]['name'],
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                fontWeight: FWeight.bold,
              ),
              SpacedRow(horizontalSpace: 16.0, children: [
                SpacedRow(
                    horizontalSpace: 4.0,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const HeroIcon(
                        HeroIcons.clock,
                        color: ThemeColors.gray6,
                        size: 12.0,
                      ),
                      KText(
                        isSelectable: false,
                        text: '${items[index]['time']}',
                        fontSize: 12.0,
                        fontWeight: FWeight.medium,
                        textColor: ThemeColors.gray6,
                      ),
                    ]),
                SpacedRow(
                    horizontalSpace: 4.0,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const HeroIcon(
                        HeroIcons.briefcase,
                        color: ThemeColors.gray6,
                        size: 12.0,
                      ),
                      KText(
                        isSelectable: false,
                        text: '${items[index]['items']}',
                        fontSize: 12.0,
                        fontWeight: FWeight.medium,
                        textColor: ThemeColors.gray6,
                      ),
                    ]),
                SpacedRow(
                    horizontalSpace: 4.0,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const HeroIcon(
                        HeroIcons.pound,
                        color: ThemeColors.gray6,
                        size: 12.0,
                      ),
                      KText(
                        isSelectable: false,
                        text: '${items[index]['price']}',
                        fontSize: 12.0,
                        fontWeight: FWeight.medium,
                        textColor: ThemeColors.gray6,
                      ),
                    ]),
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
