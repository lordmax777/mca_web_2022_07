import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/utils/utils.dart';

void setupDomain() {
  logger("SETUP DOMAIN - IO - setting to default: $domainRealStr");
  DependencyManager.instance.db.setDomain(domainRealStr);
}
