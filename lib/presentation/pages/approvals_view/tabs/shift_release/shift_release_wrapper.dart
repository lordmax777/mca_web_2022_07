import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/approvals_action.dart';
import 'package:mca_dashboard/utils/utils.dart';

class ShiftReleaseWrapper extends StatefulWidget {
  const ShiftReleaseWrapper({super.key});

  @override
  State<ShiftReleaseWrapper> createState() => _ShiftReleaseWrapperState();
}

class _ShiftReleaseWrapperState extends State<ShiftReleaseWrapper>
    with SingleTickerProviderStateMixin {
  final tabs = const [
    Tab(text: "Pending"),
    Tab(text: "Published"),
  ];

  late final TabController _tabController;

  void updateUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      updateUI();
    });
    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) async {
        if (mounted) {
          //fetch data
          initFetch();
        }
      },
    );
  }

  void initFetch() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        bottom: TabBar(
          dividerColor: Colors.grey[400],
          controller: _tabController,
          tabs: tabs,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          // isScrollable: true,
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          Text("Pending Request"),
          Text("Published Request"),
        ],
      ),
    );
  }
}
