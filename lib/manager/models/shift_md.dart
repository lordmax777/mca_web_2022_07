class ShiftMd {
  //{id: 43984, locationId: 86, userId: 891, shiftId: 207, published: true, special_start_time: null, special_finish_time: null, special_rate: null, user_order: 1}
  //NEW: {
  //             "id": 43979,
  //             "date": "2023-02-04",
  //             "locationId": 86,
  //             "userId": 805,
  //             "shiftId": 207,
  //             "published": true,
  //             "special_start_time": null,
  //             "special_finish_time": null,
  //             "special_rate": null,
  //             "user_order": 1
  //         }
  final int id;
  final String date;
  final int locationId;
  final int? userId;
  //Property id
  final int shiftId;
  final bool published;
  final String? special_start_time;
  final String? special_finish_time;
  final num? special_rate;
  final int? user_order;

  DateTime? get dateTimeDate => DateTime.tryParse(date);

  ShiftMd({
    required this.id,
    required this.locationId,
    required this.date,
    this.userId,
    required this.shiftId,
    required this.published,
    this.special_start_time,
    this.special_finish_time,
    this.special_rate,
    this.user_order,
  });

  factory ShiftMd.fromJson(Map<String, dynamic> json) {
    return ShiftMd(
      id: json['id'],
      locationId: json['locationId'],
      userId: json['userId'],
      shiftId: json['shiftId'],
      published: json['published'],
      special_start_time: json['special_start_time'],
      special_finish_time: json['special_finish_time'],
      special_rate: json['special_rate'],
      user_order: json['user_order'],
      date: json['date'],
    );
  }

  factory ShiftMd.empty({
    int? locId,
    int? uId,
  }) {
    return ShiftMd(
      id: -1,
      locationId: locId ?? 0,
      userId: uId ?? 0,
      shiftId: 0,
      published: false,
      special_start_time: null,
      special_finish_time: null,
      special_rate: null,
      user_order: null,
      date: '',
    );
  }

  bool get isEmpty => id == -1;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'locationId': locationId,
      'userId': userId,
      'shiftId': shiftId,
      'published': published,
      'special_start_time': special_start_time,
      'special_finish_time': special_finish_time,
      'special_rate': special_rate,
      'user_order': user_order,
      'date': date,
    };
  }
}
