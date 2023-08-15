import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';

final class PostQuoteAction {
  final PersonalData personalData;
  final AddressData addressData;
  final AddressData? workAddressData;
  final TimeData timingData;
  final TeamData teamData;
  final GuestData guestData;
  final QuoteData quoteData;
  final ProductData productData;
  final bool isQuote;

  const PostQuoteAction({
    required this.personalData,
    required this.addressData,
    required this.workAddressData,
    required this.timingData,
    required this.teamData,
    required this.guestData,
    required this.quoteData,
    required this.productData,
    required this.isQuote,
  });
}
