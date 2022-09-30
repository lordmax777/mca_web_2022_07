import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';

import '../manager/router/router.gr.dart';
import '../theme/theme.dart';

class DefaultDrawer extends StatelessWidget {
  final AppState state;
  DefaultDrawer({Key? key, required this.state}) : super(key: key);

  List<Map<String, dynamic>> items = [
    {
      "icon": HeroIcons.clipboard,
      "title": "Operational Tasks",
      "name": "operational_tasks",
      "children": [
        {
          "title": "Scheduling",
          "name": const UsersListRoute(),
        }
      ]
    },
    {
      "icon": HeroIcons.users,
      "title": "Administrations",
      "name": "administrations",
      "children": [
        {
          "title": "Users Management",
          "name": const UsersListRoute(),
        },
        {
          "title": "Departments/ Groups",
          "name": const DepartmentsListRoute(),
        },
        {
          "title": "Qualifications and Skills",
          "name": const QualificationsRoute(),
        },
        {
          "title": "Locations",
          "name": const UsersListRoute(),
        },
        {
          "title": "Properties",
          "name": const UsersListRoute(),
        },
        {
          "title": "Warehouses",
          "name": const UsersListRoute(),
        },
        {
          "title": "Stock Items",
          "name": const UsersListRoute(),
        },
        {
          "title": "Checklist Templates",
          "name": const UsersListRoute(),
        },
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final DrawerStates drawerState = state.generalState.drawerStates;
    return YSSidebar(
      initialIndex: drawerState.initialIndex,
      onTabChange: (p0) async {
        appStore.dispatch(UpdateGeneralStateAction(
            drawerStates:
                DrawerStates(initialIndex: p0['index'], name: p0['name'])));
        context.navigateTo(p0['name']);
        await context.popRoute();
      },
      children: _buildItems(drawerState),
    );
  }

  _buildItems(DrawerStates drawerState) {
    return items.map<YSSidebarParentItem>((parentE) {
      return YSSidebarParentItem(
        title: parentE['title'],
        icon: parentE['icon'],
        children: parentE['children'].map<YSSidebarChildItem>((childE) {
          return YSSidebarChildItem(
            name: childE['name'],
            title: childE['title'],
            isSelected: childE['name'].routeName == drawerState.name.routeName,
          );
        }).toList(),
      );
    }).toList();
  }
}

class DrawerStates {
  final int initialIndex;
  final dynamic name;

  DrawerStates({
    required this.initialIndex,
    required this.name,
  });
}
