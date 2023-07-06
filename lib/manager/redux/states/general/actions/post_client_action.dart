import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';

final class PostClientAction {
  final PersonalData data;
  final AddressData addressData;

  const PostClientAction(this.data, {required this.addressData});
}
