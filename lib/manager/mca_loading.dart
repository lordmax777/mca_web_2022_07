import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';

import '../comps/custom_loading_widget.dart';
import '../theme/colors.dart';
import '../utils/helpers.dart';

class McaLoading {
  // Create a singleton
  static final McaLoading _mcaLoading = McaLoading._internal();
  factory McaLoading() => _mcaLoading;
  McaLoading._internal();

  static CancelFunc showLoading(
      {bool barrierDismissible = false, bool showCancelButton = false}) {
    return BotToast.showCustomLoading(
      toastBuilder: (cancelFunc) {
        return CustomLoadingWidget(
            onClose: showCancelButton ? cancelFunc : null);
      },
      clickClose: barrierDismissible,
      allowClick: false,
      backButtonBehavior: BackButtonBehavior.ignore,
    );
  }

  static void closeLoading() {
    BotToast.closeAllLoading();
  }

  static Future<T> futureLoading<T>(Future<T> Function() future) async {
    CancelFunc cancel = showLoading();
    T result = await future();
    cancel();
    return result;
  }

  static Future<bool> showAlert(BuildContext context) async {
    return await showConfirmationDialog(context);
  }

  static void showSuccess(String msg) {
    showError(msg, titleMsg: "Success");
  }

  static void showFail(String msg) {
    showError(msg);
  }
}
