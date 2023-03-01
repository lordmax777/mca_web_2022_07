import 'package:mca_web_2022_07/theme/theme.dart';

class ThemeText {
  static const String fontFamilyR = "Regular";
  static const String fontFamilyM = "Medium";
  static const String fontFamilyB = "Bold";
  static const TextStyle regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: fontFamilyR,
    fontSize: 12,
  );

  static const TextStyle md = TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontFamily: fontFamilyM,
    fontSize: 14,
  );

  static const TextStyle md2 = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: fontFamilyR,
    fontSize: 14,
  );

  static const TextStyle md1 = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: fontFamilyR,
    fontSize: 16,
  );

  static const TextStyle lg = TextStyle(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily: fontFamilyM,
    fontSize: 24,
  );

  static const TextStyle tableColumnTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: fontFamilyR,
    color: ThemeColors.gray2,
    fontSize: 14,
  );

  static const TextStyle tabTextStyle = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontFamily: fontFamilyB,
    color: ThemeColors.black,
    fontSize: 16,
  );

  static const TextStyle bold14 = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontFamily: fontFamilyB,
    color: ThemeColors.black,
    fontSize: 14,
  );
}
