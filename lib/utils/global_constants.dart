import 'package:flutter/foundation.dart';

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

  static const Map<String, String> userDisplayLanguages = {
    "en": "English",
    "hu": "Hungarian",
    "pt": "Portuguese",
  };

  //Add your global constants here
  static const String debugusername = kDebugMode ? "13150519" : "";
  // "13150519";
  static const String debugpassword = kDebugMode ? "F00tba11" : "";

  static bool enableLogger = kDebugMode;

  static const List<int> pageSizes = [10, 50, 100];

  static bool enableDebugCodes = kDebugMode;

  static bool enableLoadingIndicator = kDebugMode;
}
