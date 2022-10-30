import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/pages/departments_groups/controllers/deps_list_controller.dart';

import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

import 'package:get/get.dart';

class DepartmentsListPage extends GetView<DepartmentsController> {
  const DepartmentsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) async {},
        builder: (_, state) => PageWrapper(
                child: SpacedColumn(verticalSpace: 16.0, children: [
              PagesTitleWidget(
                title: 'Departments and Groups',
              ),
              const ErrorWrapper(errors: [], child: _Body())
            ])));
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    final DepartmentsController departmentsController = Get.find();
    _tabController = TabController(
        length: departmentsController.reactive.value!.tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final DepartmentsController departmentsController = Get.find();

    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) => TableWrapperWidget(
        child: ErrorWrapper(
          errors: [state.generalState.paramList.error],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: TabBar(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  controller: _tabController,
                  splashFactory: NoSplash.splashFactory,
                  isScrollable: true,
                  indicatorWeight: 3.0,
                  indicatorColor: ThemeColors.blue3,
                  labelColor: ThemeColors.blue3,
                  unselectedLabelColor: ThemeColors.black,
                  labelStyle:
                      ThemeText.tabTextStyle.copyWith(color: ThemeColors.blue3),
                  unselectedLabelStyle: ThemeText.tabTextStyle,
                  tabs: departmentsController.reactive.value!.tabs,
                ),
              ),
              const Divider(height: 0, color: ThemeColors.gray11),
              _getTabChild(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTabChild(AppState state) {
    switch (_tabController.index) {
      case 0:
        return DepartmentsTab();
      case 1:
        return GroupsTab(state: state);
      default:
        return const SizedBox();
    }
  }
}
