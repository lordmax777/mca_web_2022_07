import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';

class GeneralController extends GetxController {
  static GeneralController get to => Get.find();

  final Rx<LoggedInUserMd> loggedInUser = Rx<LoggedInUserMd>(LoggedInUserMd());
  LoggedInUserMd get loggedInUserValue => loggedInUser.value;
  set setLoggedInUser(LoggedInUserMd value) => loggedInUser.value = value;

  Future<void> getLoggedInUser() async {
    final ApiResponse res =
        await restClient().getLoggedInUserDetails().nocodeErrorHandler();
    if (res.success) {
      final r = res.data;
      setLoggedInUser = LoggedInUserMd.fromJson(r);
    }
  }
}
