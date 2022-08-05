import 'package:flutter/material.dart';
import 'package:mca_web_2022_07/theme/theme.dart';

class ThemeText {
  static const String _fontFamilyR = "Regular";
  static const String _fontFamilyM = "Medium";
  static const regular = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyR,
    fontSize: 12.0,
  );

  static const md = TextStyle(
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyM,
    fontSize: 14.0,
  );

  static const lg = TextStyle(
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyM,
    fontSize: 24.0,
  );

  static const tableColumnTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontFamily: _fontFamilyR,
    color: ThemeColors.gray2,
    fontSize: 14.0,
  );
}
