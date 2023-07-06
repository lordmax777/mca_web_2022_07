import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';

class GetLocationsAction {
  const GetLocationsAction();
}

final class PostLocationAction {
  final AddressData addressData;
  final bool active;
  final bool anywhere;
  final bool? sendChecklist;
  const PostLocationAction(
      {required this.addressData,
      this.active = true,
      this.anywhere = false,
      this.sendChecklist});
}

final class DeleteLocationAction {
  final int id;

  const DeleteLocationAction(this.id);
}
