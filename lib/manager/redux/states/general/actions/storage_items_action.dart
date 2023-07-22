class GetStorageItemsAction {
  const GetStorageItemsAction();
}

final class PostStorageItemAction {
  final String title;

  ///incoming price
  final double price;
  final int taxId;
  final int? id;
  final double? outgoingPrice;

  final bool fetchLists;

  const PostStorageItemAction({
    this.id,
    required this.title,
    required this.price,
    this.outgoingPrice,
    this.fetchLists = true,
    required this.taxId,
  });
}

final class DeleteStorageItemAction {
  final int id;

  const DeleteStorageItemAction(this.id);
}
