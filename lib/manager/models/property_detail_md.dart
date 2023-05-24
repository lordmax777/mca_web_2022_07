class PropertyDetailsMd {
  //"details": {
  //         "bedrooms": 2,
  //         "bathrooms": 2,
  //         "min_sleeps": 3,
  //         "max_sleeps": 7,
  //         "notes": "keys delivery shop--(Best one, 87 Camden High street London--NW1 7JL---New code—771360 \r\n\r\n \r\n\r\nLock box code--2014"
  //     }
  int _id = 0;
  int bedrooms;
  int bathrooms;
  int minSleeps;
  int maxSleeps;
  String notes;

  bool get isInit => _id == -1;

  PropertyDetailsMd({
    required this.bedrooms,
    required this.bathrooms,
    required this.minSleeps,
    required this.maxSleeps,
    required this.notes,
  });

  factory PropertyDetailsMd.fromJson(Map<String, dynamic> json) {
    return PropertyDetailsMd(
      bedrooms: json['bedrooms'],
      bathrooms: json['bathrooms'],
      minSleeps: json['min_sleeps'],
      maxSleeps: json['max_sleeps'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'min_sleeps': minSleeps,
      'max_sleeps': maxSleeps,
      'notes': notes,
    };
  }

  factory PropertyDetailsMd.init() {
    final md = PropertyDetailsMd(
      bedrooms: 0,
      bathrooms: 0,
      minSleeps: 0,
      maxSleeps: 0,
      notes: '',
    );
    md._id = -1;
    return md;
  }

  @override
  String toString() {
    return 'PropertyDetailsMd{bedrooms: $bedrooms, bathrooms: $bathrooms, minSleeps: $minSleeps, maxSleeps: $maxSleeps, notes: $notes}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PropertyDetailsMd &&
          runtimeType == other.runtimeType &&
          bedrooms == other.bedrooms &&
          bathrooms == other.bathrooms &&
          minSleeps == other.minSleeps &&
          maxSleeps == other.maxSleeps &&
          notes == other.notes;

  @override
  int get hashCode =>
      bedrooms.hashCode ^
      bathrooms.hashCode ^
      minSleeps.hashCode ^
      maxSleeps.hashCode ^
      notes.hashCode;
}
