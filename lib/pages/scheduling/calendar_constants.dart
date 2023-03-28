import 'package:flutter/cupertino.dart';

abstract class CalendarConstants {
  static double fullHeight(BuildContext context) =>
      MediaQuery.of(context).size.height - 150;

  static double tableHeight(BuildContext context) =>
      MediaQuery.of(context).size.height - 300;

  static const double resourceWidth = 300;

  static const double shiftHeight = 30;

  static int resourceCount(BuildContext context) =>
      (tableHeight(context) / (shiftHeight * 3)).ceil();
}