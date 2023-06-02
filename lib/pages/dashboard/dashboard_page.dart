import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/mca_loading.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/router/router.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GeneralController>(
      id: "dashboardPage",
      filter: (value) => value.initializedAll,
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (!controller.initializedAll)
          //   const Center(child: CircularProgressIndicator()),
          if (!controller.initializedAll)
            KText(
              text: "App is loading, please wait..",
              fontSize: 32,
              fontWeight: FWeight.medium,
              textColor: Colors.black,
              mainAxisSize: MainAxisSize.min,
            )
          else
            KText(
              text:
                  "Welcome ${controller.loggedInUserValue.firstName} ${controller.loggedInUserValue.lastName} !",
              fontSize: 32,
              fontWeight: FWeight.medium,
              textColor: Colors.black,
              mainAxisSize: MainAxisSize.min,
            ),

          if (kDebugMode)
            TextButton(
                onPressed: () {
                  context.pushRoute(const SchedulingRoute());
                },
                child: const Text("Scheduling")),
        ],
      ),
    );
  }
}
