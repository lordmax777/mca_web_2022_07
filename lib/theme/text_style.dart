import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

class ThemeText {
  static const String _fontFamilyR = "Regular";
  static const String _fontFamilyM = "Medium";
  static const String _fontFamilyB = "Bold";
  static const TextStyle regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyR,
    fontSize: 12,
  );

  static const TextStyle md = TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyM,
    fontSize: 14,
  );

  static const TextStyle md2 = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyR,
    fontSize: 14,
  );

  static const TextStyle md1 = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyR,
    fontSize: 16,
  );

  static const TextStyle lg = TextStyle(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyM,
    fontSize: 24,
  );

  static const TextStyle tableColumnTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyR,
    color: ThemeColors.gray2,
    fontSize: 14,
  );

  static const TextStyle tabTextStyle = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyB,
    color: ThemeColors.black,
    fontSize: 16,
  );

  static const TextStyle bold14 = TextStyle(
    fontWeight: FontWeight.w800,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyB,
    color: ThemeColors.black,
    fontSize: 14,
  );
}
