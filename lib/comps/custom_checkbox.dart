import '../theme/theme.dart';

enum CheckboxLabelPosition {
  left,
  right,
  top,
  bottom,
}

class CustomCheckboxWidget extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final String? label;
  final CheckboxLabelPosition labelPosition;
  const CustomCheckboxWidget(
      {Key? key,
      required this.onChanged,
      required this.isChecked,
      this.label,
      this.labelPosition = CheckboxLabelPosition.right})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (label != null) {
      switch (labelPosition) {
        case CheckboxLabelPosition.left:
          return SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              labelWidget(),
              checkboxWidget(),
            ],
          );
        case CheckboxLabelPosition.right:
          return SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              checkboxWidget(),
              labelWidget(),
            ],
          );
        case CheckboxLabelPosition.top:
          return SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalSpace: 8.0,
            children: [
              labelWidget(),
              checkboxWidget(),
            ],
          );
        case CheckboxLabelPosition.bottom:
          return SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalSpace: 8.0,
            children: [
              checkboxWidget(),
              labelWidget(),
            ],
          );
      }
    }

    return checkboxWidget();
  }

  Widget checkboxWidget() {
    return CheckboxWidget(
        value: isChecked,
        onChanged: (value) {
          onChanged(value ?? false);
        });
  }

  Widget labelWidget() {
    return KText(
      text: label!,
      fontSize: 14.0,
      textColor: ThemeColors.gray2,
      isSelectable: false,
      fontWeight: FWeight.bold,
    );
  }
}
