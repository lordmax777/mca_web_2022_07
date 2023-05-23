import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';

import '../manager/general_controller.dart';
import '../theme/theme.dart';

class DefaultDrawer extends StatelessWidget {
  final AppState state;
  const DefaultDrawer({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerStates drawerState = state.uiState.drawerStates;
    final String companyTitle = GeneralController.to.companyInfo.name;

    return YSSidebar(
      title: companyTitle,
      initialIndex: drawerState.initialIndex,
      onTabChange: (p0) async {
        appStore.dispatch(UpdateUIStateAction(
            drawerStates:
                DrawerStates(initialIndex: p0['index'], name: p0['name'])));
        context.replaceRoute(p0['name']);
        await context.popRoute();
      },
      children: _buildItems(drawerState, context),
    );
  }

  _buildItems(DrawerStates drawerState, BuildContext context) {
    return Constants.drawerItems.map<YSSidebarParentItem>((parentE) {
      return YSSidebarParentItem(
        title: parentE['title'],
        icon: parentE['icon'],
        onPressed: parentE['children'] != null
            ? null
            : () async {
                appStore.dispatch(UpdateUIStateAction(
                    drawerStates: DrawerStates(
                        initialIndex: Constants.drawerItems.indexOf(parentE),
                        name: parentE['name'])));
                context.replaceRoute(parentE['name']);
                await context.popRoute();
              },
        children: parentE['children'] == null
            ? null
            : parentE['children'].map<YSSidebarChildItem>((childE) {
                return YSSidebarChildItem(
                  name: childE['name'],
                  title: childE['title'],
                  isSelected:
                      childE['name'].routeName == drawerState.name.routeName,
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
