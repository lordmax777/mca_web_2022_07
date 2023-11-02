import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class GlobalConstants {
  //Create a singleton
  static final GlobalConstants _instance = GlobalConstants.internal();
  GlobalConstants.internal();
  factory GlobalConstants() => _instance;

  static const Map<String, String> userTitleTypes = {
    "mr": "Mr",
    "mrs": "Mrs",
    "miss": "Miss",
    "dr": "Dr",
    "prof": "Prof",
  };

  //Add your global constants here
  static const String debugusername = kDebugMode ? "96189831" : "";
  // "13150519";
  static const String debugpassword = kDebugMode ? "F00tba11" : "";

  static bool enableLogger = kDebugMode;

  static const List<int> pageSizes = [10, 50, 100];

  static bool enableDebugCodes = kDebugMode;

  static bool enableLoadingIndicator = true;

  static TextInputFormatter numberAndTextOnlyFormatter =
      FilteringTextInputFormatter(RegExp(r'^[a-zA-Z0-9]+$'),
          allow: true, replacementString: '');
  static TextInputFormatter numbersOnlyFormatter =
      FilteringTextInputFormatter.digitsOnly;
  static TextInputFormatter numbersAndDecimalOnlyFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'));
  static TextInputFormatter limitLengthFormatter(int length) =>
      LengthLimitingTextInputFormatter(length);
  static DateFormat defaultDateFormat = DateFormat("yyyy-MM-dd");
}
