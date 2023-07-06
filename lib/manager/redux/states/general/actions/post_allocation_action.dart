final class PostAllocationAction {
  //    @Path() int locationId,
  //     @Path() int userId,
  //     @Path() int shiftId,
  //     @Path() String date,
  //
  //     ///Action. Available: add,remove,publish,unpublish,more,less, copy
  //     @Field() String action, {
  //     @Field() String? date_until,
  //     @Field() String? target_date,
  //     @Field() int? target_location,
  //     @Field() int? target_user,
  //     @Field() int? target_shift,

  final int? locationId;
  final int? userId;
  final int? shiftId;
  final DateTime date;
  final AllocationPostType action;
  final DateTime? date_until;
  final DateTime? target_date;
  final int? target_location;
  final int? target_user;
  final int? target_shift;

  const PostAllocationAction({
    this.locationId,
    this.userId,
    this.shiftId,
    required this.date,
    required this.action,
    this.date_until,
    this.target_date,
    this.target_location,
    this.target_user,
    this.target_shift,
  });
}

enum AllocationPostType {
  add,
  remove,
  publish,
  unpublish,
  more,
  less,
  copy;

  String get name {
    return toString().split('.').last;
  }
}
