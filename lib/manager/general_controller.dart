import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/comps/custom_loading_widget.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:mca_web_2022_07/utils/constants.dart';
import 'redux/middlewares/users_middleware.dart';
import 'redux/states/users_state/users_state.dart';

class GeneralController extends GetxController {
  static GeneralController get to => Get.find();

  final Rx<LoggedInUserMd> loggedInUser = Rx<LoggedInUserMd>(LoggedInUserMd());

  LoggedInUserMd get loggedInUserValue => loggedInUser.value;

  set setLoggedInUser(LoggedInUserMd value) {
    loggedInUser.value = value;
  }

  final Rx<CompanyMd> _companyInfo = Rx<CompanyMd>(CompanyMd.init());

  CompanyMd get companyInfo => _companyInfo.value;

  set setCompanyInfo(CompanyMd value) {
    _companyInfo.value = value;
    //Set special_word constant
    Constants.propertyName = value.special_word;
  }

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
    loggedInUser.listen((_) async {
      if (isLoggedIn) {
        await initAll();
      }
    });
  }

  Future<void> initAll() async {
    await getCompanyInfo();
    await appStore.dispatch(GetLocationAddressesAction());
    await appStore.dispatch(GetClientInfosAction());
    await appStore.dispatch(GetQuotesAction());
    await appStore.dispatch(GetApprovalAction());
    await appStore.dispatch(GetUsersListAction());
    await appStore.dispatch(GetPropertiesAction());
    await appStore.dispatch(GetChecklistTemplatesAction());
    await appStore.dispatch(GetWarehousesAction());
    await appStore.dispatch(GetAllStorageItemsAction());
    await appStore.dispatch(GetAllParamListAction());
  }
}
