import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';
import '../utils/helpers.dart';

class McaLoading {
  // Create a singleton
  static final McaLoading _mcaLoading = McaLoading._internal();
  factory McaLoading() => _mcaLoading;
  McaLoading._internal();

  static CancelFunc showLoading({bool allowClick = false}) {
    return BotToast.showLoading(
      clickClose: false,
      allowClick: allowClick,
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
}
