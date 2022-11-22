import 'package:auto_route/auto_route.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import '../manager/general_controller.dart';
import '../theme/theme.dart';

class DefaultDrawer extends StatelessWidget {
  final AppState state;
  const DefaultDrawer({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DrawerStates drawerState = state.generalState.drawerStates;
    final String companyTitle = GeneralController.to.companyInfo.name ?? 'MCA';

    return YSSidebar(
      title: companyTitle,
      initialIndex: drawerState.initialIndex,
      onTabChange: (p0) async {
        appStore.dispatch(UpdateGeneralStateAction(
            drawerStates:
                DrawerStates(initialIndex: p0['index'], name: p0['name'])));
        context.replaceRoute(p0['name']);
        await context.popRoute();
      },
      children: _buildItems(drawerState),
    );
  }

  _buildItems(DrawerStates drawerState) {
    return Constants.drawerItems.map<YSSidebarParentItem>((parentE) {
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
