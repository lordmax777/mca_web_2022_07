import '../theme/theme.dart';

enum FWeight { regular, medium, bold, light }

class KText extends StatelessWidget {
  final String text;
  TextStyle? style;
  TextAlign? textAlign;
  Color? textColor;
  double? fontSize;
  FWeight? fontWeight;
  final bool isSelectable;
  final HeroIcon? icon;
  final VoidCallback? onTap;
  KText(
      {Key? key,
      required this.text,
      this.style,
      this.onTap,
      this.textAlign,
      this.fontWeight,
      this.icon,
      this.fontSize,
      this.textColor,
      this.isSelectable = true})
      : super(key: key) {
    textColor ??= ThemeColors.white;
    fontWeight ??= FWeight.regular;
    FontWeight? fontW;
    String? fontF;
    switch (fontWeight) {
      case FWeight.regular:
        fontW = FontWeight.w400;
        fontF = "Regular";
        break;
      case FWeight.medium:
        fontW = FontWeight.w500;
        fontF = "Medium";
        break;
      case FWeight.bold:
        fontW = FontWeight.w700;
        fontF = "Bold";
        break;
      case FWeight.light:
        fontW = FontWeight.w300;
        fontF = "Light";
        break;
      default:
        break;
    }
    if (style == null) {
      style = ThemeText.regular
          .apply(color: textColor!)
          .copyWith(fontSize: fontSize, fontWeight: fontW, fontFamily: fontF);
    } else {
      style = style!
          .copyWith(fontSize: fontSize, fontWeight: fontW, fontFamily: fontF);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isSelectable) {
      return SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 4.0,
        children: [
          SelectableText(text, style: style, textAlign: textAlign),
          if (icon != null) icon!,
        ],
      );
    }
    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 4.0,
            children: [
              Text(text, style: style, textAlign: textAlign),
              if (icon != null) icon!,
            ],
          ),
        ),
      );
    }
    return SpacedRow(
      crossAxisAlignment: CrossAxisAlignment.center,
      horizontalSpace: 4.0,
      children: [
        Text(text, style: style, textAlign: textAlign),
        if (icon != null) icon!,
      ],
    );
  }
}
