import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/auth_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';

import 'redux/states/users_state/users_state.dart';

class GeneralController extends GetxController {
  static GeneralController get to => Get.find();

  final Rx<LoggedInUserMd> loggedInUser = Rx<LoggedInUserMd>(LoggedInUserMd());
  LoggedInUserMd get loggedInUserValue => loggedInUser.value;
  set setLoggedInUser(LoggedInUserMd value) => loggedInUser.value = value;

  final Rx<CompanyMd> _companyInfo = Rx<CompanyMd>(CompanyMd());
  CompanyMd get companyInfo => _companyInfo.value;
  set setCompanyInfo(CompanyMd value) => _companyInfo.value = value;

  bool get isLoggedIn =>
      loggedInUserValue.username != null &&
      loggedInUserValue.username!.isNotEmpty;

  Future<void> getLoggedInUser() async {
    final ApiResponse res =
        await restClient().getLoggedInUserDetails().nocodeErrorHandler();

    if (res.success) {
      final r = res.data;
      setLoggedInUser = LoggedInUserMd.fromJson(r);
    }
  }

  Future<void> getCompanyInfo() async {
    final ApiResponse res =
        await restClient().getCompanyInfo().nocodeErrorHandler();

    if (res.success) {
      final r = res.data;
      setCompanyInfo = CompanyMd.fromJson(r);
    }
  }

  @override
  void onReady() {
    super.onReady();
    loggedInUser.listen((_) {
      if (isLoggedIn) {
        initAll();
      }
    });
  }

  void initAll() async {
    getCompanyInfo();
    // await fetch(GetAllParamListAction());
    // await fetch(GetUsersListAction());
    // await fetch(GetAllLocationsAction());
    // await fetch(GetPropertiesAction());
    // return;
    await Future.wait([
      fetch(GetAllParamListAction()),
      fetch(GetUsersListAction()),
      fetch(GetAllLocationsAction()),
      fetch(GetPropertiesAction()),
    ]);
  }
}
