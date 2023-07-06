final class GetClientContractItemsAction {
  final int clientId;
  final int shiftId;
  final DateTime date;

  const GetClientContractItemsAction({
    required this.clientId,
    required this.shiftId,
    required this.date,
  });
}
