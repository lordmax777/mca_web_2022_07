import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/get_timesheet_action.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_switch.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/dialogs/create_schedule_popup.dart';

class DebugView extends StatefulWidget {
  const DebugView({super.key});

  @override
  State<DebugView> createState() => _DebugViewState();
}

class _DebugViewState extends State<DebugView> {
  final state = appStore.state.generalState;
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
                final res = await dispatch(GetTimesheetAction(
                    timestamp: DateTime.now().millisecondsSinceEpoch));
                return;
                bool sendEmail = false;
                final bool exited = await context.showDialog(
                    barrierDismissible: false,
                    AlertDialog(
                      title: const Text("Saved Successfully"),
                      content: StatefulBuilder(builder: (context, ss) {
                        return DefaultCheckbox(
                          value: sendEmail,
                          label: 'Email Quote to Client',
                          onChanged: (value) {
                            ss(() {
                              sendEmail = value;
                            });
                          },
                        );
                      }),
                      actions: [
                        TextButton(
                            onPressed: () {
                              context.pop(sendEmail);
                            },
                            child: const Text("Ok"))
                      ],
                    ));
                // print(state.companyInfo.);
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
