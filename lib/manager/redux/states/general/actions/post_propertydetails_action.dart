final class PostPropertyDetailsAction {
  final int shiftId;
  final int bedrooms;
  final int bathrooms;
  final int minSleeps;
  final int maxSleeps;
  final String notes;

  const PostPropertyDetailsAction({
    required this.shiftId,
    required this.bedrooms,
    required this.bathrooms,
    required this.minSleeps,
    required this.maxSleeps,
    required this.notes,
  });
}
