import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_switch.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/create_schedule_popup.dart';

class DebugView extends StatefulWidget {
  const DebugView({super.key});

  @override
  State<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label("Test Button"),
            ElevatedButton(
              onPressed: () async {
                dispatch(GetListsAction());
                return;
                for (var i in appStore.state.generalState.properties) {
                  await Future.wait([
                    appStore.dispatch(GetPropertyStaffAction(i.id)) as Future,
                    appStore.dispatch(GetPropertyQualificationAction(i.id))
                        as Future
                  ]);
                }
              },
              child: const Text('Test Button'),
            ),
            label("Test Button 2"),
            ElevatedButton(
              onPressed: () async {
                DependencyManager.instance.navigation.loginState.logout();
              },
              child: const Text('Logout'),
            ),
            label("Enable Debug Codes"),
            DefaultSwitch(
                value: GlobalConstants.enableDebugCodes,
                onChanged: (value) {
                  GlobalConstants.enableDebugCodes = value;
                  if (mounted) setState(() {});
                }),
            label("Enable Logger"),
            DefaultSwitch(
                value: GlobalConstants.enableLogger,
                onChanged: (value) {
                  GlobalConstants.enableLogger = value;
                  Logger.init(GlobalConstants.enableLogger,
                      isShowFile: false,
                      isShowNavigation: false,
                      isShowTime: false);
                  if (mounted) setState(() {});
                }),
            label("Enable Loading Indicator"),
            DefaultSwitch(
                value: GlobalConstants.enableLoadingIndicator,
                onChanged: (value) {
                  GlobalConstants.enableLoadingIndicator = value;
                  if (mounted) setState(() {});
                }),
            label("Enable Live Mode"),
            DefaultSwitch(
                value: DependencyManager.instance.db.getIsTestMode(),
                onChanged: (value) {
                  DependencyManager.instance.db.setIsTestMode(value);
                  DependencyManager.instance.db
                      .setDomain(value ? domainRealStr : domainDevStr);

                  if (mounted) setState(() {});
                }),
          ],
        ),
      ),
    );
  }
}
