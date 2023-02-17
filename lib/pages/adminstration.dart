import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/drawer.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

class Adminstration extends StatelessWidget {
  const Adminstration({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final TalkerController talker = TalkerController.to;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        floatingActionButton: talker.fab(),
        drawer: DefaultDrawer(state: state),
        endDrawer: state.generalState.endDrawer,
        backgroundColor: ThemeColors.gray12,
        drawerEnableOpenDragGesture: false,
        key: Constants.scaffoldKey,
        appBar: NavbarWidget(),
        body: const AutoRouter(),
      ),
    );
  }
}
