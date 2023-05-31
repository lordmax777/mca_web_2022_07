import 'package:get/get.dart';

import '../theme/theme.dart';

Future showOverlayPopup({
  String? buttonText,
  required Widget body,
  EdgeInsetsGeometry? margin,
  double? horizontalPadding = 0.0,
  AlignmentGeometry? alignment,
  double paddingTop = 0.0,
  double paddingBottom = 0.0,
  double borderRadius = 16,
  bool autoDismiss = false,
  bool barrierDismissible = true,
  required BuildContext context,
  Color? backgroundColor = ThemeColors.white,
}) async {
  Future<bool> _onWillPop() {
    if (barrierDismissible) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  return await showDialog(
    useRootNavigator: false,
    routeSettings: const RouteSettings(name: 'simple_dialog'),
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return Container(
        margin: margin ?? EdgeInsets.zero,
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: PopupLayout(
            alignment: alignment,
            borderRadius: borderRadius,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            horizontalPadding: horizontalPadding,
            backgroundColor: backgroundColor,
            children: [body],
          ),
        ),
      );
    },
  );
}
