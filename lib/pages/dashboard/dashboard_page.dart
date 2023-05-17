import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
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
          if (!controller.initializedAll)
            const Center(child: CircularProgressIndicator()),
          if (!controller.initializedAll)
            KText(
              text:
                  "Please do not move to other pages until the app is fully initialized.",
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
            )
        ],
      ),
    );
  }
}
