final class PostQualificationAction {
  final int? id;
  final String comments;
  final String title;
  final bool isLevel;
  final bool isExpire;
  const PostQualificationAction(
      {this.id,
      required this.title,
      this.isLevel = false,
      this.isExpire = false,
      this.comments = ""});
}

final class DeleteQualificationAction {
  final int id;

  const DeleteQualificationAction(this.id);
}
