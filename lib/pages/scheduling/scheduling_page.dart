import 'package:get/get.dart';

import '../../theme/theme.dart';
import 'controllers/page_controller.dart';

class SchedulingPage extends StatelessWidget {
  const SchedulingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SchedulingController());
    return const Placeholder(child: Text('SchedulingPage'));
  }
}
