class Constants {
  static const String appName = "MCA Web";
  static const String appVersion = "1.0.0";

  //REST API related data

  static const String apiBaseUrlDev = "https://timesheet.skillfill.co.uk";
  static const String apiBaseUrlProd = "https://www.onlinetimeclock.co.uk";
  //Auth
  static const String domain = "timesheet.skillfill.co.uk";
  static const String clientId =
      "1_3bcbxd9e24g0gk4swg0kwgcwg4o8k8g4g888kwc44gcc0gwwk4";
  static const String clientSecret =
      "4ok2x70rlfokc8g0wws8c8kwcokw80k44sg48goc0ok4w0so0k";
  static const String token_type = "bearer";
  static const String grant_type = "password";
  static const String username = "91403765";
  static const String password = "F00tba11";

  // Etc
  static const List<int> tablePageSizes = [10, 50, 100];

  static const Map<String, String> userTitleTypes = {
    "mr": "Mr",
    "mrs": "Mrs",
    "miss": "Miss",
    "dr": "Dr",
    "prof": "Prof.",
  };

  static const Map<String, String> userMartialStatusTypes = {
    "notDisclosed": "Not disclosed",
    "single": "Single",
    "married": "Married/Civil Partner",
    "divorced": "Divorced",
    "widowed": "Widowed/Surviving Civil Partner",
    "separated": "Separated",
  };

  static const Map<bool, String> userAccountStatusTypes = {
    true: "Active",
    false: "Inactive",
  };

  static const Map<String, String> userDisplayLangs = {
    "en": "English",
    "hu": "Hungarian",
    "pt": "Portuguese",
  };

  static const Map<String, int> userLoginMethods = {
    "web": 1,
    "mobile": 2,
    "tablet": 3,
    "mobileadmin": 9,
    "api": 12,
    "other": 99,
  };
}
