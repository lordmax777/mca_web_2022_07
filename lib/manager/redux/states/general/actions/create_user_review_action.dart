import 'package:mca_dashboard/manager/data/models.dart';

class GetCreateUserReviewAction {
  final int? userId;
  final String title;
  final DateTime date;
  final int conductedBy;
  final int? reviewid;
  final String? notes;

  const GetCreateUserReviewAction(
      {required this.title,
      required this.date,
      required this.conductedBy,
      this.reviewid,
      this.notes,
      this.userId});
}
