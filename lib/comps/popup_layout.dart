import '../theme/theme.dart';

class PopupLayout extends StatelessWidget {
  List<Widget> children;
  Widget? title;
  double? horizontalPadding;
  double borderRadius;
  double paddingTop;
  double paddingBottom;
  AlignmentGeometry? alignment;
  Color? backgroundColor;
  PopupLayout(
      {required this.children,
      this.title,
      this.alignment,
      this.borderRadius = 0,
      this.paddingTop = 32,
      this.paddingBottom = 32,
      this.horizontalPadding = 64,
      this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: backgroundColor,
      alignment: alignment,
      contentPadding: EdgeInsets.only(
          bottom: paddingBottom,
          left: horizontalPadding!,
          right: horizontalPadding!,
          top: paddingTop),
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 25),
      title: title,
      // titleTextStyle:
      //     ThemeTextSemiBold.xl.copyWith(color: ThemeColors.coolgray900),
      children: children,
    );
  }
}
