import 'package:json_annotation/json_annotation.dart';
part 'reviews_md.g.dart';

@JsonSerializable(anyMap: true)
class ReviewMd {
  String date;
  String conducted_by;
  String title;
  String notes;

  @override
  ReviewMd({
    required this.date,
    required this.title,
    required this.notes,
    required this.conducted_by,
  });

  factory ReviewMd.fromJson(Map<String, dynamic> json) =>
      _$ReviewMdFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewMdToJson(this);
}
