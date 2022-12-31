import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/pages/properties/tabs/days_tab.dart';
import 'package:mca_web_2022_07/pages/properties/tabs/sp_rates_tab.dart';
import 'package:mca_web_2022_07/pages/properties/tabs/timings_tab.dart';
import '../../manager/models/property_md.dart';
import '../../theme/theme.dart';

class PropertyDrawer extends StatefulWidget {
  final PropertiesMd property;
  const PropertyDrawer({Key? key, required this.property}) : super(key: key);

  @override
  State<PropertyDrawer> createState() => _PropertyDrawerState();
}

class _PropertyDrawerState extends State<PropertyDrawer>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<Tab> tabs = [
    const Tab(text: 'Days'),
    const Tab(text: 'Timings'),
    const Tab(text: 'Rates'),
    const Tab(text: 'Staff Requirements'),
    const Tab(text: 'Qualifications Requirements'),
  ];

  @override
  void initState() {
    super.initState();
    print('PropertyDrawer: initState');
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    print('PropertyDrawer: dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 640,
      backgroundColor: ThemeColors.white,
      elevation: 0.8,
      child: SpacedColumn(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const Divider(height: 1, color: ThemeColors.gray11),
              _tabs(),
            ],
          ),
          _footer(),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SpacedRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 440,
                  child: KText(
                    isSelectable: false,
                    text: widget.property.title ?? "-",
                    fontSize: 18.0,
                    textColor: ThemeColors.gray2,
                    fontWeight: FWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 440,
                  child: KText(
                    isSelectable: false,
                    text: widget.property.locationName ?? "-",
                    fontSize: 14.0,
                    textColor: ThemeColors.gray2,
                    fontWeight: FWeight.regular,
                  ),
                ),
              ],
            ),
            InkWell(
                child: const HeroIcon(
                  HeroIcons.x,
                  size: 16.0,
                  color: ThemeColors.gray1,
                ),
                onTap: () {
                  context.popRoute();
                }),
          ]),
    );
  }

  Widget _footer() {
    return Container(
      decoration: BoxDecoration(color: ThemeColors.white, boxShadow: [
        BoxShadow(
          color: ThemeColors.black.withOpacity(0.08),
          spreadRadius: 0,
          blurRadius: 24,
          offset: const Offset(0, 4), // changes position of shadow
        ),
        BoxShadow(
          color: ThemeColors.black.withOpacity(0.08),
          spreadRadius: 0,
          blurRadius: 4,
          offset: const Offset(0, 4), // changes position of shadow
        ),
      ]),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ButtonMedium(
          icon: const HeroIcon(HeroIcons.edit, size: 20.0),
          text: "Edit Property",
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _tabs() {
    return SpacedColumn(
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
            labelStyle:
                ThemeText.tabTextStyle.copyWith(color: ThemeColors.MAIN_COLOR),
            unselectedLabelStyle: ThemeText.tabTextStyle,
            dragStartBehavior: DragStartBehavior.start,
            tabs: tabs,
          ),
        ),
        const Divider(height: 1, color: ThemeColors.gray11),
        _getTabChild(),
      ],
    );
  }

  Widget _getTabChild() {
    switch (_tabController.index) {
      case 0:
        return PropertyDaysTab(widget.property);
      case 1:
        return PropertyTimingsTab(widget.property);
      case 2:
        return PropertySpRatesTab(widget.property);
      default:
        return const SizedBox();
    }
  }
}
