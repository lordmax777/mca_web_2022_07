import 'package:mca_dashboard/presentation/pages/users_view/data/data_source.dart';

final class PostUserContractAction {
  final int userId;
  final PayrollDataSource dataSource;

  const PostUserContractAction(this.userId, this.dataSource);
}
