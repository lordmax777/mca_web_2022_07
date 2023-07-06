final class PostGroupAction {
  final int? id;
  final String title;
  final bool isActive;

  const PostGroupAction({this.id, required this.title, this.isActive = true});
}

final class DeleteGroupAction {
  final int id;

  const DeleteGroupAction(this.id);
}
