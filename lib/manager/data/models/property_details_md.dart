import 'package:equatable/equatable.dart';

final class PropertyDetailMd extends Equatable {
  final int bedrooms;
  final int bathrooms;
  final int minSleeps;
  final int maxSleeps;
  final String notes;

  const PropertyDetailMd({
    required this.bedrooms,
    required this.bathrooms,
    required this.minSleeps,
    required this.maxSleeps,
    required this.notes,
  });

  @override
  List<Object?> get props => [bedrooms, bathrooms, minSleeps, maxSleeps, notes];

  factory PropertyDetailMd.fromJson(Map<String, dynamic> json) {
    return PropertyDetailMd(
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      minSleeps: json['min_sleeps'] ?? 0,
      maxSleeps: json['max_sleeps'] ?? 0,
      notes: json['notes'] ?? '',
    );
  }
}

final class PropertyStaffMd extends Equatable {
//{
//             "min": 3,
//             "max": 5,
//             "groupId": 44,
//             "group": "Cleaners"
//         }

  final int min;
  final int? max;
  final int groupId;
  final String group;

  int get id => groupId;

  const PropertyStaffMd({
    required this.min,
    required this.max,
    required this.groupId,
    required this.group,
  });

  @override
  List<Object?> get props => [min, max, groupId, group];

  //from json
  factory PropertyStaffMd.fromJson(Map<String, dynamic> json) {
    return PropertyStaffMd(
      min: json['min'] ?? 0,
      max: json['max'],
      groupId: json['groupId'] ?? -1,
      group: json['group'] ?? '',
    );
  }
}

final class PropertyQualificationMd extends Equatable {
  //{
//             "numberOfStaff": 1,
//             "qualificationId": 28,
//             "qualification": "Cleaning NVQ1",
//             "levelId": 1,
//             "level": "EL3",
//             "alternative": null
//         }

  final int numberOfStaff;
  final int qualificationId;
  final String qualification;
  final int? levelId;
  final String? level;
  final String? alternative;

  int get id => qualificationId;

  const PropertyQualificationMd({
    required this.numberOfStaff,
    required this.qualificationId,
    required this.qualification,
    required this.levelId,
    required this.level,
    required this.alternative,
  });

  @override
  List<Object?> get props => [
        numberOfStaff,
        qualificationId,
        qualification,
        levelId,
        level,
        alternative
      ];

  //from json
  factory PropertyQualificationMd.fromJson(Map<String, dynamic> json) {
    return PropertyQualificationMd(
      numberOfStaff: json['numberOfStaff'] ?? 0,
      qualificationId: json['qualificationId'] ?? -1,
      qualification: json['qualification'] ?? '',
      levelId: json['levelId'] ?? -1,
      level: json['level'] ?? '',
      alternative: json['alternative'],
    );
  }
}
