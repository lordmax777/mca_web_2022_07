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
      // didChangeDependencies: (state) {
      //   print("DIDCHANGEDEPENDENCIES");
      //   logger(state.mounted, hint: "DASHBOARD PAGE DIDCHANGEDEP");
      //   logger(state.controller, hint: "DASHBOARD PAGE DIDCHANGEDEP");
      //   // if (state.mounted) {
      //   //   if (state.controller != null) {
      //   //     if (!state.controller!.initializedAll) {
      //   //       showDialog(
      //   //           context: Get.context!,
      //   //           builder: (context) {
      //   //             return const CustomLoadingWidget();
      //   //           });
      //   //     }
      //   //   }
      //   // }
      // },
      // didUpdateWidget: (oldWidget, state) {
      //   print("DIDUPDATEWIDGET");
      // },
      // dispose: (state) {
      //   print("DISPOSE");
      // },
      // initState: (state) {},
      builder: (controller) => Center(
        child: KText(
          text: "Dashboard (Soon!)",
          fontSize: 32,
          fontWeight: FWeight.medium,
          textColor: Colors.black,
          mainAxisSize: MainAxisSize.min,
        ),
      ),
    );
  }
}
