final class GetChecklistTemplatesAction {
  const GetChecklistTemplatesAction();
}

final class PostChecklistTemplateAction {
  final int? id;
  final String title;
  final String name;
  final bool active;
  const PostChecklistTemplateAction(
      {this.id, required this.title, required this.name, required this.active});
}

final class PostChecklistTemplateRoomAction {
  final int checklistTemplateId;
  final String name;
  final bool damage;
  final List<String> items;
  const PostChecklistTemplateRoomAction(
      {required this.checklistTemplateId,
      required this.name,
      required this.damage,
      required this.items});
}

final class DeleteChecklistTemplateRoomAction {
  final int checklistTemplateId;
  final String checklistTemplateRoomName;

  const DeleteChecklistTemplateRoomAction(
      this.checklistTemplateId, this.checklistTemplateRoomName);
}
