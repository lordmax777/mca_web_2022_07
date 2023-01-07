import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:redux/redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import '../states/users_state/users_state.dart';

class UsersMiddleware extends MiddlewareClass<AppState> {
  @override
  call(Store<AppState> store, action, next) {
    switch (action.runtimeType) {
      case GetUsersListAction:
        return GetUsersListAction.getUsersListAction(store.state, action, next);
      case GetUserDetailsDetailAction:
        return GetUserDetailsDetailAction.getUserDetailsDetailAction(
            store.state, action, next);
      case GetUserDetailsContractsAction:
        return GetUserDetailsContractsAction.getUserDetailsContractsAction(
            store.state, action, next);
      case GetUserDetailsReviewsAction:
        return GetUserDetailsReviewsAction.getUserDetailsReviewsAction(
            store.state, action, next);
      case GetUserDetailsVisasAction:
        return GetUserDetailsVisasAction.getUserDetailsVisasAction(
            store.state, action, next);
      case GetUserDetailsQualifsAction:
        return GetUserDetailsQualifsAction.getUserDetailsQualifsAction(
            store.state, action, next);
      case GetUserDetailsStatusAction:
        return GetUserDetailsStatusAction.getUserDetailsStatusAction(
            store.state, action, next);
      case GetUserDetailsMobileAction:
        return GetUserDetailsMobileAction.getUserDetailsMobileAction(
            store.state, action, next);
      case GetUserDetailsPreferredShiftsAction:
        return GetUserDetailsPreferredShiftsAction
            .getUserDetailsPreferredShiftsAction(store.state, action, next);
      case GetUserDetailsPhotosAction:
        return GetUserDetailsPhotosAction.getUserDetailsPhotosAction(
            store.state, action, next);
      case GetSaveGeneralDetailsAction:
        return GetSaveGeneralDetailsAction.getSaveGeneralDetailsAction(
            store.state, action, next);
      case GetSaveUserPhotoAction:
        return GetSaveUserPhotoAction.getSaveUserPhotoAction(
            store.state, action, next);
      case GetDeleteUserPhotoAction:
        return GetDeleteUserPhotoAction.getDeleteUserPhotoAction(
            store.state, action, next);
      case GetPostUserDetailsReviewAction:
        return GetPostUserDetailsReviewAction.getPostUserDetailsReviewAction(
            store.state, action, next);
      case GetDeleteUserDetailsReviewsAction:
        return GetDeleteUserDetailsReviewsAction
            .getDeleteUserDetailsReviewsAction(store.state, action, next);
      case GetPostUserDetailsVisaAction:
        return GetPostUserDetailsVisaAction.getPostUserDetailsVisaAction(
            store.state, action, next);
      case GetDeleteUserDetailsVisaAction:
        return GetDeleteUserDetailsVisaAction.getDeleteUserDetailsVisaAction(
            store.state, action, next);
      case GetPostUserDetailsQualifsAction:
        return GetPostUserDetailsQualifsAction.getPostUserDetailsQualifsAction(
            store.state, action, next);
      case GetDeleteUserDetailsQualifsAction:
        return GetDeleteUserDetailsQualifsAction
            .getDeleteUserDetailsQualifsAction(store.state, action, next);
      case GetPostUserDetailsStatusAction:
        return GetPostUserDetailsStatusAction.getPostUserDetailsStatusAction(
            store.state, action, next);
      case GetDeleteUserDetailsMobileAction:
        return GetDeleteUserDetailsMobileAction
            .getDeleteUserDetailsMobileAction(store.state, action, next);
      case GetPostUserDetailsContractAction:
        return GetPostUserDetailsContractAction
            .getPostUserDetailsContractAction(store.state, action, next);
      case GetDeleteUserDetailsContractAction:
        return GetDeleteUserDetailsContractAction
            .getDeleteUserDetailsContractAction(store.state, action, next);
      case GetPostUserDetailsPreferredShiftAction:
        return GetPostUserDetailsPreferredShiftAction.fetch(
            store.state, action, next);
      case GetDeleteUserPreferredShiftAction:
        return GetDeleteUserPreferredShiftAction.fetch(
            store.state, action, next);
      default:
        return next(action);
    }
  }
}

Future<void> showLoading({bool? barrierDismissible = false}) async {
  final TalkerController talker = TalkerController.to;

  showDialog(
    barrierDismissible: barrierDismissible!,
    context: appRouter.navigatorKey.currentContext!,
    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 8,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(
                ThemeColors.MAIN_COLOR.withOpacity(0.8)),
            color: ThemeColors.MAIN_COLOR,
          ),
          FloatingActionButton.small(
              onPressed: talker.goToLogs,
              child: const Icon(Icons.developer_mode))
        ],
      );
    },
  );
}

Future<void> showError(dynamic msg,
    {bool? barrierDismissible = false, String titleMsg = "Error"}) async {
  showDialog(
    context: appRouter.navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        title: Text(titleMsg),
        content: Text(msg.toString()),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () => context.popRoute(),
          )
        ],
      );
    },
  );
}

Future<void> closeLoading() async {
  await Future.delayed(300.milliseconds);
  await appRouter.pop();
}
