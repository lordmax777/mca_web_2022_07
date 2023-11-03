import 'package:equatable/equatable.dart';

class WeekDaysMd extends Equatable {
  bool monday;
  bool tuesday;
  bool wednesday;
  bool thursday;
  bool friday;
  bool saturday;
  bool sunday;

  Map<String, bool> get asMap => {
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
      };

  Map<int, bool> get asMapInt => {
        1: monday,
        2: tuesday,
        3: wednesday,
        4: thursday,
        5: friday,
        6: saturday,
        7: sunday,
      };

  static Map<int, String> get asMapIntString => {
        1: 'monday',
        2: 'tuesday',
        3: 'wednesday',
        4: 'thursday',
        5: 'friday',
        6: 'saturday',
        7: 'sunday',
        0: 'sunday',
      };

  void updateValueByKey(String key) {
    switch (key) {
      case 'monday':
        monday = !monday;
        break;
      case 'tuesday':
        tuesday = !tuesday;
        break;
      case 'wednesday':
        wednesday = !wednesday;
        break;
      case 'thursday':
        thursday = !thursday;
        break;
      case 'friday':
        friday = !friday;
        break;
      case 'saturday':
        saturday = !saturday;
        break;
      case 'sunday':
        sunday = !sunday;
        break;
      default:
    }
  }

  bool get isEveryDay =>
      monday &&
      tuesday &&
      wednesday &&
      thursday &&
      friday &&
      saturday &&
      sunday;

  bool get isWeekend =>
      saturday &&
      sunday &&
      !monday &&
      !tuesday &&
      !wednesday &&
      !thursday &&
      !friday;

  bool get isAnyChecked =>
      monday ||
      tuesday ||
      wednesday ||
      thursday ||
      friday ||
      saturday ||
      sunday;

  WeekDaysMd({
    this.monday = false,
    this.tuesday = false,
    this.wednesday = false,
    this.thursday = false,
    this.friday = false,
    this.saturday = false,
    this.sunday = false,
  });

  @override
  List<Object?> get props => [
        monday,
        tuesday,
        wednesday,
        thursday,
        friday,
        saturday,
        sunday,
      ];

  @override
  String toString() {
    if (isEveryDay) return 'Everyday';
    if (isWeekend) return 'Weekend only';
    final StringBuffer sb = StringBuffer();
    if (monday) sb.write('monday, ');
    if (tuesday) sb.write('tuesday, ');
    if (wednesday) sb.write('wednesday, ');
    if (thursday) sb.write('thursday, ');
    if (friday) sb.write('friday, ');
    if (saturday) sb.write('saturday, ');
    if (sunday) sb.write('sunday, ');
    if (sb.isEmpty) return 'Never';
    return sb.toString().substring(0, sb.length - 2);
  }

  factory WeekDaysMd.fromList(List days) {
    //[1, 1, 1, 1, 1, 1, 1]

    final weekDays = WeekDaysMd();
    weekDays.monday = days[0] == 1;
    weekDays.tuesday = days[1] == 1;
    weekDays.wednesday = days[2] == 1;
    weekDays.thursday = days[3] == 1;
    weekDays.friday = days[4] == 1;
    weekDays.saturday = days[5] == 1;
    weekDays.sunday = days[6] == 1;

    return weekDays;
  }

  factory WeekDaysMd.fromDayNameToList(List<String> names) {
    final weekDays = WeekDaysMd();
    for (String name in names) {
      switch (name) {
        case 'monday':
          weekDays.monday = true;
          break;
        case 'tuesday':
          weekDays.tuesday = true;
          break;
        case 'wednesday':
          weekDays.wednesday = true;
          break;
        case 'thursday':
          weekDays.thursday = true;
          break;
        case 'friday':
          weekDays.friday = true;
          break;
        case 'saturday':
          weekDays.saturday = true;
          break;
        case 'sunday':
          weekDays.sunday = true;
          break;
      }
    }
    return weekDays;
  }

  factory WeekDaysMd.fromQuoteWorkDays(List<int> days,
      {bool isFortnightly = false}) {
    if (days.isEmpty) return WeekDaysMd();

    final weekDays = WeekDaysMd();

    for (int day in days) {
      switch (day) {
        case 1:
          if (isFortnightly) break;
          weekDays.monday = true;
          break;
        case 2:
          if (isFortnightly) break;
          weekDays.tuesday = true;
          break;
        case 3:
          if (isFortnightly) break;
          weekDays.wednesday = true;
          break;
        case 4:
          if (isFortnightly) break;
          weekDays.thursday = true;
          break;
        case 5:
          if (isFortnightly) break;
          weekDays.friday = true;
          break;
        case 6:
          if (isFortnightly) break;
          weekDays.saturday = true;
          break;
        case 7:
          if (isFortnightly) break;
          weekDays.sunday = true;
          break;
        case 8:
          if (!isFortnightly) break;
          weekDays.monday = true;
          break;
        case 9:
          if (!isFortnightly) break;
          weekDays.tuesday = true;
          break;
        case 10:
          if (!isFortnightly) break;
          weekDays.wednesday = true;
          break;
        case 11:
          if (!isFortnightly) break;
          weekDays.thursday = true;
          break;
        case 12:
          if (!isFortnightly) break;
          weekDays.friday = true;
          break;
        case 13:
          if (!isFortnightly) break;
          weekDays.saturday = true;
          break;
        case 14:
          if (!isFortnightly) break;
          weekDays.sunday = true;
          break;
      }
    }

    return weekDays;
  }

  factory WeekDaysMd.fromMap(Map map) {
    //{
    //                 "0": 1,
    //                 "1": 1,
    //                 "6": 1
    //             }
    //Where 0 is sunday, 1 is monday, 6 is saturday, and 1 is true
    final weekDays = WeekDaysMd();

    for (String key in map.keys) {
      switch (int.parse(key)) {
        case 0:
          weekDays.sunday = map[key] == 1;
          break;
        case 1:
          weekDays.monday = map[key] == 1;
          break;
        case 2:
          weekDays.tuesday = map[key] == 1;
          break;
        case 3:
          weekDays.wednesday = map[key] == 1;
          break;
        case 4:
          weekDays.thursday = map[key] == 1;
          break;
        case 5:
          weekDays.friday = map[key] == 1;
          break;
        case 6:
          weekDays.saturday = map[key] == 1;
          break;
      }
    }

    return weekDays;
  }

  List<String> get asListString {
    final List<String> list = [];
    if (monday) list.add('monday');
    if (tuesday) list.add('tuesday');
    if (wednesday) list.add('wednesday');
    if (thursday) list.add('thursday');
    if (friday) list.add('friday');
    if (saturday) list.add('saturday');
    if (sunday) list.add('sunday');
    return list;
  }

  //from list string
  WeekDaysMd fromListString(List<String> list) {
    final weekDays = WeekDaysMd();
    for (String name in list) {
      switch (name) {
        case 'monday':
          weekDays.monday = true;
          break;
        case 'tuesday':
          weekDays.tuesday = true;
          break;
        case 'wednesday':
          weekDays.wednesday = true;
          break;
        case 'thursday':
          weekDays.thursday = true;
          break;
        case 'friday':
          weekDays.friday = true;
          break;
        case 'saturday':
          weekDays.saturday = true;
          break;
        case 'sunday':
          weekDays.sunday = true;
          break;
      }
    }
    return weekDays;
  }
}
