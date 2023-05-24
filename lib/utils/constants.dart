import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/pages/checklist/checklist_list_page.dart';
import 'package:mca_web_2022_07/pages/quotes/quotes_list_page.dart';
import 'package:mca_web_2022_07/utils/global_functions.dart';

import '../manager/router/router.dart';
import '../theme/theme.dart';

class Constants {
  static const String appName = "MCA Web";
  static const int mj = 0;
  static const int mn = 1;
  static const int up = 18;
  static String appVersion = "$mj.$mn.$up";
  static bool isDebug = true;
  static bool enableTalker = false;

  static double defaultWidth(BuildContext context) =>
      MediaQuery.of(context).size.width - 16;

  //REST API related data
  static const String apiBaseUrlDev = "https://timesheet.skillfill.co.uk";
  static const String apiBaseUrlProd = "https://www.onlinetimeclock.co.uk";

  static String get apiBaseUrl => isDebug ? apiBaseUrlDev : apiBaseUrlProd;

  //Auth
  static const String domain = "timesheet.skillfill.co.uk";
  static const String clientId =
      "1_3bcbxd9e24g0gk4swg0kwgcwg4o8k8g4g888kwc44gcc0gwwk4";
  static const String clientSecret =
      "4ok2x70rlfokc8g0wws8c8kwcokw80k44sg48goc0ok4w0so0k";
  static const String token_type = "bearer";

  static String grant_type({bool refresh = false}) =>
      refresh ? "refresh_token" : "password";
  static const String username = "96189831";
  static const String password = "F00tba11";

  ///geo.ipify.org api key
  static const String geoIpifyApiKey = "at_in4YK83J9JYwn3ZzaVAr5gwlaEMLP";

  //Google Maps API Key
  static const String googleMapApiKey =
      "AIzaSyAJppOsTzcnks6yfcR9WmJk-Cjqfw3zIww";

  //String constants
  static String propertyName = "Property";

  //Drawer
  static GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  static const double pagePaddingHorizontal = 8.0;

  static List<Map<String, dynamic>> drawerItems = [
    {
      "icon": HeroIcons.home,
      "title": "Dashboard",
      "name": const DashboardRoute(),
    },
    {
      "icon": HeroIcons.clipboard,
      "title": "Operational Tasks",
      "name": "operational_tasks",
      "children": [
        {
          "title": "Scheduling",
          "name": const SchedulingRoute(),
        },
        {
          "title": "Timesheet",
          "name": const TimesheetListRoute(),
        },
        {
          "title": "Approval",
          "name": const ApprovalTemplateRoute(),
        },
        {
          "title": "Checklist",
          "name": const ChecklistListRoute(),
        },
      ]
    },
    {
      "icon": HeroIcons.users,
      "title": "Administrations",
      "name": "administrations",
      "children": [
        if (kDebugMode)
          {
            "title": "Test Page",
            "name": const TestRoute(),
          },
        {
          "title": "Users Management",
          "name": const UsersListRoute(),
        },
        {
          "title": "Departments/ Groups",
          "name": const DepartmentsListRoute(),
        },
        {
          "title": "Qualifications and Skills",
          "name": const QualificationsRoute(),
        },
        {
          "title": "Quotes",
          "name": const QuotesListRoute(),
        },
        {
          "title": "Locations",
          "name": const LocationsListRoute(),
        },
        {
          "title": propertyName.toPlural.capitalize,
          "name": const PropertiesRoute(),
        },
        {
          "title": "Warehouses",
          "name": const WarehousesListRoute(),
        },
        {
          "title": "Stock Items",
          "name": const StockItemsListRoute(),
        },
        {
          "title": "Checklist Templates",
          "name": const ChecklistTemplatesRoute(),
        },
        {
          "title": "Inventory",
          "name": const InventoryListRoute(),
        },
        {
          "title": "Handover Types",
          "name": const HandoverTypesRoute(),
        },
        {
          "title": "Settings",
          "name": const SettingsRoute(),
        },
      ]
    },
  ];

  // Etc
  static const List<int> tablePageSizes = [10, 50, 100];

  static const Map<String, String> userTitleTypes = {
    "mr": "Mr",
    "mrs": "Mrs",
    "miss": "Miss",
    "dr": "Dr",
    "prof": "Prof.",
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

  static const Map<int, String> daysOfTheWeek = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
    8: "Monday",
    9: "Tuesday",
    10: "Wednesday",
    11: "Thursday",
    12: "Friday",
    13: "Saturday",
    14: "Sunday",
  };

  // static Map<String, dynamic> getDayAndWeekOfTheWeek(int day) {
  //   //day must be larger than 7, meaning that 1 is Monday and 8 is also Monday and 13 also Monday
  //   //return Map of day and week of the month {"week": 1, "day": "Monday", "dayNumber": 1}
  //   return {
  //     "week": weeksOfTheMonth[(day / 7).ceil() - 1],
  //     "day": daysOfTheWeek[day % 7 == 0 ? 7 : day % 7],
  //     "dayNumber": day % 7 == 0 ? 7 : day % 7,
  //   };
  // }

  static const List<int> weeksOfTheMonth = [1, 2, 3, 4];

  static const Map<String, String> settingsSection = {
    "company": "Company",
    "account": "Account",
    "change_password": "Change Password",
    "login_and_status": "Login and Status",
    "holidays_and_sick": "Holidays and Sick",
    "shift": "Shift",
    "color_theme": "Color Theme"
  };

  static String get isoDateFormat {
    const String format = "yyyy-MM-dd";
    return format;
  }

  static DateTime isoDateTime(String date) {
    try {
      return DateFormat(isoDateFormat).parse(date);
    } on Exception catch (e) {
      logger(e, hint: "isoDateTime");
      rethrow;
    }
  }

  static TimeOfDay isoTimeOfDay(String time) {
    try {
      return TimeOfDay.fromDateTime(DateTime.parse("2022-05-12 $time"));
    } on Exception catch (e) {
      logger(e, hint: "isoTimeOfDay");
      rethrow;
    }
  }

  static const Map<int, String> daysMap = {
    0: "Sunday",
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
  };

  static Map<int, String> parseDays(days) {
    final bool isList = days is List;
    //if list [1,1,1,1,1,1,1]
    //if Map {"0":1, "1":1, "2":1, "3":1, "4":1, "5":1, "6":1}

    try {
      if (isList) {
        return {for (int i = 0; i < days.length; i++) i: daysMap[i]!};
      }
      return {
        for (int i = 0; i < days.length; i++)
          int.parse(days.keys.toList()[i]):
              daysMap[(int.parse(days.keys.toList()[i]))]!
      };
    } on Exception catch (e) {
      logger(e, hint: "parseDays");
      rethrow;
    }
  }
}
