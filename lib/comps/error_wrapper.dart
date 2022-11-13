import 'dart:ui';

import 'package:mca_web_2022_07/manager/redux/middlewares/auth_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';

import '../manager/redux/sets/app_state.dart';
import '../manager/redux/sets/state_value.dart';
import '../theme/theme.dart';

class ErrorWrapper extends StatefulWidget {
  final Widget child;
  final List<ErrorModel> errors;
  final double? height;
  final VoidCallback? onRetry;

  const ErrorWrapper({
    Key? key,
    required this.errors,
    required this.child,
    this.height,
    this.onRetry,
  }) : super(key: key);

  @override
  State<ErrorWrapper> createState() => _ErrorWrapperState();
}

class _ErrorWrapperState extends State<ErrorWrapper> {
  @override
  Widget build(BuildContext context) {
    if (widget.errors.any((element) => element.isError) ||
        widget.errors.any((element) => element.isLoading)) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: widget.height ?? MediaQuery.of(context).size.height - 160,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.grey.shade500.withOpacity(0.3)),
        child: widget.errors.any((element) => element.isLoading)
            ? SpacedColumn(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalSpace: 16,
                children: [
                  CircularProgressIndicator(color: ThemeColors.MAIN_COLOR),
                  KText(
                    text: "Data is Loading...",
                    fontSize: 24,
                    textColor: ThemeColors.black,
                    rowCenter: true,
                    fontWeight: FWeight.medium,
                    isSelectable: false,
                  ),
                ],
              )
            : SpacedColumn(
                verticalSpace: 28.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KText(
                    text: _gerError(),
                    fontSize: 24,
                    textColor: ThemeColors.black,
                    rowCenter: true,
                    fontWeight: FWeight.medium,
                    isSelectable: false,
                  ),
                  SizedBox(
                    width: 150,
                    child: ButtonMedium(
                        text: 'Refresh',
                        onPressed: () async {
                          if (widget.onRetry != null) {
                            widget.onRetry!();
                          } else {
                            await fetch(widget.errors
                                .firstWhere((element) => element.isError)
                                .action);
                          }
                        }),
                  )
                ],
              ),
      );
    }
    return widget.child;
  }

  String _gerError() {
    final ErrorModel firstErr =
        widget.errors.firstWhere((element) => element.isError);
    final resCode = firstErr.errorCode;
    String errorMessage = firstErr.errorMessage.toString();
    if (resCode == 401) {
      errorMessage = 'You are not authorized to perform this action';
    }
    if (firstErr.data != null &&
        firstErr.data.runtimeType
            .toString()
            .contains("_InternalLinkedHashMap") &&
        widget.errors
            .firstWhere((element) => element.isError)
            .data
            .containsKey('error')) {
      errorMessage = "[${firstErr.data['error']['code']}]" " - " +
          firstErr.data['error']['message'];
    }

    return errorMessage;
  }
}
