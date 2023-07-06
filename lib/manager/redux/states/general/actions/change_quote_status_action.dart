final class ChangeQuoteStatusAction {
  final int id;

  ///pending, accept, decline
  final String status;

  const ChangeQuoteStatusAction({
    required this.id,

    ///pending, accept, decline
    required this.status,
  });
}
