import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/drawer.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../manager/redux/middlewares/auth_middleware.dart';
import '../manager/redux/states/auth_state.dart';
import '../manager/redux/states/general_state.dart';
import '../manager/redux/states/users_state/users_state.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        drawer: DefaultDrawer(state: state),
        endDrawer: state.generalState.endDrawer,
        backgroundColor: ThemeColors.gray12,
        drawerEnableOpenDragGesture: false,
        key: scaffoldKey,
        appBar: NavbarWidget(scaffoldKey: scaffoldKey),
        body: const AutoRouter(),
      ),
    );
  }
}
