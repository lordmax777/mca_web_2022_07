final class PostJobTitleAction {
  final int? id;
  final String title;
  final bool isActive;

  const PostJobTitleAction(
      {this.id, required this.title, this.isActive = true});
}

final class DeleteJobTitleAction {
  final int id;

  const DeleteJobTitleAction(this.id);
}
