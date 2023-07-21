import 'package:flutter/material.dart';
import 'package:mca_dashboard/presentation/pages/account_view/tabs/availability_tab.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> tabs = [
    const Tab(text: 'Availability Settings'),
  ];

  @override
  void initState() {
    _tabController = TabController(length: tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0.0,
          bottom: TabBar(
            dividerColor: Colors.grey[400],
            controller: _tabController,
            tabs: tabs,
            labelStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            const AvailabilityTab(),
          ],
        ));
  }
}
