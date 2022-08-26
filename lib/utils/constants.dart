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
  static const String username = "11690550";
  static const String password = "2WillPass";

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
    "notDisclosed": "Not Disclosed",
    "single": "Single",
    "married": "Married/Civil Partner",
    "divorced": "Divorced",
    "widowed": "Widowed/Surviving Civil Partner",
    "separated": "Separated",
  };

  static const Map<String, String> userAccountStatusTypes = {
    "active": "Active",
    "inactive": "Inactive",
  };
}
