import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/scheduling_page.dart';
import '../../../theme/theme.dart';
import '../../manager/redux/middlewares/users_middleware.dart';
import '../../manager/rest/nocode_helpers.dart';
import '../../manager/models/storage_item_md.dart';
import '../../utils/global_functions.dart';

Widget labelWithField(String label, Widget? child,
    {Widget? customLabel,
    Widget? childHelperWidget,
    TextStyle? labelStyle,
    double? labelWidth}) {
  return SpacedColumn(
    verticalSpace: 0,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SpacedRow(
        horizontalSpace: 12,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: labelStyle ?? ThemeText.md1,
            ),
          ),
          if (customLabel != null) customLabel,
        ],
      ),
      if (child != null)
        SpacedRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          horizontalSpace: 8,
          children: [
            child,
            if (childHelperWidget != null) childHelperWidget,
          ],
        )
    ],
  );
}

Widget toggle(bool value, Function(bool) onToggle) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: ToggleCheckboxWidget(
        value: value,
        width: 36.0,
        height: 18.0,
        toggleSize: 16.0,
        padding: 1.0,
        inactiveColor: ThemeColors.gray10,
        onToggle: onToggle),
  );
}

Widget radio(int value, int groupVal, Function(int) onToggle) {
  return Radio(
    value: value,
    groupValue: groupVal,
    onChanged: (int? value) {
      if (value == null) return;
      onToggle(value);
    },
  );
}

Widget checkbox(bool value, Function(bool) onToggle) {
  return CustomCheckboxWidget(
    isChecked: value,
    onChanged: onToggle,
  );
}
