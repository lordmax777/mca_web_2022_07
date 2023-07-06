import 'package:collection/collection.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

extension TimeExtenstion on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);

  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  DateTime get startOfWeek => subtract(Duration(days: weekday - 1));

  DateTime get endOfWeek => add(Duration(days: 7 - weekday));

  DateTime get startOfMonth => DateTime(year, month, 1);

  DateTime get endOfMonth =>
      DateTime(year, month + 1).subtract(const Duration(days: 1));

  operator -(Duration other) {
    return subtract(other);
  }

  operator +(Duration other) {
    return add(other);
  }
}

extension ResourceExt on CalendarResource {
  bool get isUser => id.toString().startsWith("US");
  bool get isPr => id.toString().startsWith("PR");
  bool get isOpen => id.toString().contains("OPEN");

  int? get findId => int.tryParse(id.toString().replaceRange(0, 3, ""));

  Object? findType(List<UserMd> users, List<PropertyMd> properties) {
    if (isUser) {
      return users.firstWhereOrNull((user) => user.id == findId);
    }
    if (isPr) {
      return properties.firstWhereOrNull((pr) => pr.id == findId);
    }
    return null;
  }
}

enum CalendarTapMenus {
  add,
  edit,
  delete,
  quickAdd,
  copy;
}
