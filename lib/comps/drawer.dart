import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';

import '../theme/theme.dart';

class DefaultDrawer extends StatelessWidget {
  final AppState state;
  DefaultDrawer({Key? key, required this.state}) : super(key: key);

  List<Map<String, dynamic>> items = [
    {
      "icon": HeroIcons.users,
      "title": "Adminstrations",
      "name": "adminstrations",
      "children": [
        {
          "title": "Users Management",
          "name": "users_management",
        },
        {
          "title": "Departments/ Groups",
          "name": "departments_groups",
        }
      ]
    },
    {
      "icon": HeroIcons.clipboard,
      "title": "Operational Tasks",
      "name": "operational_tasks",
      "children": [
        {
          "title": "Scheduling",
          "name": "scheduling",
        }
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    final DrawerStates drawerState = state.generalState.drawerStates;
    return YSSidebar(
      initialIndex: drawerState.initialIndex,
      onTabChange: (p0) {
        appStore.dispatch(UpdateGeneralStateAction(
            drawerStates: DrawerStates(
                initialIndex: p0['index'], currentPage: p0['name'])));
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
            isSelected: childE['name'] == drawerState.currentPage,
          );
        }).toList(),
      );
    }).toList();
  }
}

class DrawerStates {
  final int initialIndex;
  final String currentPage;

  DrawerStates({
    required this.initialIndex,
    required this.currentPage,
  });
}
