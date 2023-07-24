// ignore_for_file: depend_on_referenced_packages

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Map<String, tz.Location> getTimezones() {
  tz.initializeTimeZones();
  var locations = tz.timeZoneDatabase.locations;
  return locations;
}
