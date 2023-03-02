import '../theme/theme.dart';

enum FWeight { regular, medium, bold, light }

class KText extends StatelessWidget {
  final dynamic text;
  TextStyle? style;
  TextAlign? textAlign;
  Color? textColor;
  double? fontSize;
  FWeight? fontWeight;
  final bool isSelectable;
  final HeroIcon? icon;
  final VoidCallback? onTap;
  final bool rowCenter;
  final MainAxisSize mainAxisSize;
  final int? maxLines;
  KText(
      {Key? key,
      required this.text,
      this.maxLines,
      this.style,
      this.rowCenter = false,
      this.onTap,
      this.textAlign,
      this.mainAxisSize = MainAxisSize.max,
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
        mainAxisSize: mainAxisSize,
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 4.0,
        children: [
          SelectableText(text.toString(),
              maxLines: maxLines, style: style, textAlign: textAlign),
          if (icon != null) icon!,
        ],
      );
    }
    if (onTap != null) {
      return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: icon == null
              ? Text(text.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: style,
                  textAlign: textAlign)
              : SpacedRow(
                  mainAxisSize: mainAxisSize,
                  mainAxisAlignment: rowCenter
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  horizontalSpace: 4.0,
                  children: [
                    Text(text.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: style,
                        textAlign: textAlign),
                    icon!,
                  ],
                ),
        ),
      );
    }
    if (icon != null) {
      return SpacedRow(
        mainAxisSize: mainAxisSize,
        mainAxisAlignment:
            rowCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 4.0,
        children: [
          Text(text.toString(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: style,
              softWrap: true,
              textAlign: textAlign),
          if (icon != null) icon!,
        ],
      );
    }
    return Text(text.toString(),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        softWrap: true,
        style: style,
        textAlign: textAlign);
  }
}
