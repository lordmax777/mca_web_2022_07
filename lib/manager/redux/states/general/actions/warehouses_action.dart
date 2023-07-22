final class GetWarehousesAction {
  const GetWarehousesAction();
}

final class PostWarehouseAction {
  final int? id;
  final String name;
  final String contactName;
  final bool active;
  final bool sendReport;
  final String contactEmail;

  const PostWarehouseAction(
      {this.id,
      required this.name,
      this.contactEmail = '',
      this.active = true,
      this.sendReport = true,
      required this.contactName});
}

final class DeleteWarehouseAction {
  final int id;

  const DeleteWarehouseAction(this.id);
}
