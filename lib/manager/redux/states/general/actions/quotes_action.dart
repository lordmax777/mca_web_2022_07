final class GetQuotesAction {
  final int? id;
  final DateTime? date;
  final int? shiftId;
  final int? locationId;

  final bool isJobOnly;
  final bool isInvoiceOnly;
  final bool isQuoteOnly;

  ///if all are false then it will get all quotes mixed
  const GetQuotesAction(
      {this.id,
      this.date,
      this.shiftId,
      this.locationId,
      this.isInvoiceOnly = false,
      this.isJobOnly = false,
      this.isQuoteOnly = false});
}
