import 'package:equatable/equatable.dart';

final class UserReviewMd extends Equatable {
  final int id;
  final String date;
  DateTime get dateTime => DateTime.parse(date);
  final String? conducted_by;
  final String title;
  final String notes;

  bool get isNew => id == -1;

  const UserReviewMd({
    required this.date,
    required this.title,
    required this.id,
    required this.notes,
    required this.conducted_by,
  });

  @override
  List<Object?> get props => [date, title, id, notes, conducted_by];

  factory UserReviewMd.fromJson(Map<String, dynamic> json) {
    return UserReviewMd(
      date: json['date'] ?? "",
      title: json['title'] ?? "",
      id: json['id'],
      notes: json['notes'] ?? "",
      conducted_by: json['conducted_by'] ?? "",
    );
  }
}
