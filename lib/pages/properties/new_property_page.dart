import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/comps/custom_get_builder.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/pages/properties/new_prop_tabs/shift_details_tab.dart';
import 'package:mca_web_2022_07/pages/properties/new_prop_tabs/staff_req_tab.dart';
import '../../theme/theme.dart';
import 'controllers/new_prop_controller.dart';

class NewPropertyPage extends StatelessWidget {
  final PropertiesMd? property;

  const NewPropertyPage({Key? key, this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => NewPropController(property: property));

    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return ErrorWrapper(
            errors: [],
            child: PageWrapper(
                child: SpacedColumn(
              verticalSpace: 16.0,
              children: [
                property == null
                    ? PageGobackWidget(
                        text: "New ${Constants.propertyName.capitalize}")
                    : PageGobackWidget(text: property!.title),
                _Body(property: property),
              ],
            )),
          );
        });
  }
}

class _Body extends StatefulWidget {
  final PropertiesMd? property;

  const _Body({Key? key, this.property}) : super(key: key);

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> tabs = [];

  @override
  void dispose() {
    logger('dispose');
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tabs.addAll([
      const Tab(text: 'Shift Details'),
      if (!isNew) const Tab(text: 'Staff Requirements'),
      if (!isNew) const Tab(text: 'Qualification Requirements'),
      if (!isNew) const Tab(text: 'Capacity'),
    ]);
    if (appStore.state.usersState.isNewUser) {
      tabs.removeRange(1, tabs.length);
    }
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  bool get isNew => widget.property == null;

  @override
  Widget build(BuildContext context) {
    return GBuilder<NewPropController>(
        tag: "newProp",
        child: (controller) {
          controller.timingStrictBreakTime.value;
          return TableWrapperWidget(
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
                    indicatorColor: ThemeColors.MAIN_COLOR,
                    labelColor: ThemeColors.MAIN_COLOR,
                    unselectedLabelColor: ThemeColors.black,
                    labelStyle: ThemeText.tabTextStyle
                        .copyWith(color: ThemeColors.MAIN_COLOR),
                    unselectedLabelStyle: ThemeText.tabTextStyle,
                    tabs: tabs,
                  ),
                ),
                const Divider(height: 0, color: ThemeColors.gray11),
                _getTabChild(),
              ],
            ),
          );
        });
  }

  Widget _getTabChild() {
    switch (_tabController.index) {
      case 0:
        return const ShiftDetailsTab();
      case 1:
        return StaffReqTab(property: widget.property!);
      // case 2:
      //   return const ReviewsWidget();
      default:
        return const SizedBox();
    }
  }
}
