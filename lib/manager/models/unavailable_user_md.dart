class UnavailableUserMd {
  final int userId;
  final List<String> unavailable;

  //from json
  UnavailableUserMd.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        unavailable = List<String>.from(json['unavailable']);

  //to json
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'unavailable': unavailable,
      };
}
