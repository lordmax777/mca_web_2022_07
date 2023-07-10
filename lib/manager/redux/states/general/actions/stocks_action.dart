final class GetCurrentStockListAction {
  final int warehouseId;

  const GetCurrentStockListAction(this.warehouseId);
}

final class AddToStockAction {
  final int warehouseId;
  final int itemId;
  final int quantity;
  final String? comment;
  final String? documentNumber;

  const AddToStockAction({
    required this.warehouseId,
    required this.itemId,
    required this.quantity,
    this.comment,
    this.documentNumber,
  });
}
