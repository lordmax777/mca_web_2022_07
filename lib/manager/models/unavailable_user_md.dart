class UnavailableUserMd {

  //    {
  //         "userId": 869,
  //         "unavailable": [
  //             {
  //                 "date": "2023-04-10",
  //                 "reason": "Holiday"
  //             }
  //         ]
  //     }

  final int userId;
  final List<UnavailableReason> unavailable;


  //from json
  UnavailableUserMd.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        unavailable = (json['unavailable'] as List)
            .map((i) => UnavailableReason.fromJson(i))
            .toList();

  //to json
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'unavailable': unavailable,
      };
}

class UnavailableReason {
  final String date;
  final String reason;

  //from json
  UnavailableReason.fromJson(Map<String, dynamic> json)
      : date = json['date'],
        reason = json['reason'];

  //to json
  Map<String, dynamic> toJson() => {
        'date': date,
        'reason': reason,
      };
}
