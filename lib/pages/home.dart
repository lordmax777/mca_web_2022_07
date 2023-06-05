import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/drawer.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/user/users_list_page.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TalkerController talker = TalkerController.to;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        floatingActionButton: talker.fab(),
        drawer: DefaultDrawer(state: state),
        endDrawer: state.uiState.endDrawer,
        backgroundColor: ThemeColors.gray12,
        drawerEnableOpenDragGesture: false,
        key: Constants.scaffoldKey,
        appBar: NavbarWidget(),
        body: const UsersListPage(),
      ),
    );
  }
}
