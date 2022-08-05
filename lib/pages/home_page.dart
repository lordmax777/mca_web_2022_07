import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/comps/sidebar_widget.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

import '../comps/nav_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Do init stuff here
    });
  }

  @override
  Widget build(BuildContext context) {
    final _w = MediaQuery.of(context).size.width;

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (_, state) => Scaffold(
        drawer: YSSidebar(
          children: [
            YSSidebarParentItem(
              title: "Home",
              children: const [
                YSSidebarChildItem(
                  title: "Test",
                ),
              ],
            ),
          ],
        ),
        backgroundColor: ThemeColors.gray12,
        drawerEnableOpenDragGesture: false,
        key: _scaffoldKey,
        appBar: NavbarWidget(scaffoldKey: _scaffoldKey),
        body: const Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              // constraints: const BoxConstraints(maxWidth: 1448),
              child: AutoRouter()),
        ),
      ),
    );
  }
}
