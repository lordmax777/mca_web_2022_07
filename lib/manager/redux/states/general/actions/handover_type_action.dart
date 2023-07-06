final class PostHandoverTypeAction {
  final int? id;
  final String title;
  final bool isActive;

  const PostHandoverTypeAction(
      {this.id, required this.title, this.isActive = true});
}

final class DeleteHandoverTypeAction {
  final int id;

  const DeleteHandoverTypeAction(this.id);
}
