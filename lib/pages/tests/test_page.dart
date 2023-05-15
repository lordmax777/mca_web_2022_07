import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';

import '../../manager/models/property_md.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/redux/sets/state_value.dart';
import '../../manager/rest/rest_client.dart';
import '../../theme/theme.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  void _testProperties() async {
    final allShifts = appStore.state.generalState.shifts;

    // for (int i = 0; i < allShifts.length; i++) {
    final ApiResponse res =
        await restClient().getProperties(0.toString()).nocodeErrorHandler();
    if (res.success) {
      final List<PropertiesMd> list = [];
      list.addAll(res.data['shifts']
          .map<PropertiesMd>((e) => PropertiesMd.fromJson(e))
          .toList());
      for (var e in list) {
        print(e.title);
        print(e.parsedDays);
      }
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: TableWrapperWidget(
        child: Center(
          child: Column(
            children: [
              _button(_testProperties, title: 'Test Properties'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(VoidCallback onTap, {String? title}) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(title ?? 'Test Button'),
    );
  }
}
