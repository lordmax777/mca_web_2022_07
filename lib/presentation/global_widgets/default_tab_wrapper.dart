import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';

//write a typedef for the callback that returns int
typedef OnTabChange = void Function(int newIndex);

final class TabChild {
  final String tabName;
  final Widget child;

  const TabChild({required this.tabName, required this.child});
}

class DefaultTabWrapper extends StatefulWidget {
  final OnTabChange? onTabChange;
  final List<TabChild> children;
  const DefaultTabWrapper(
      {super.key, this.onTabChange, required this.children});

  @override
  State<DefaultTabWrapper> createState() => _DefaultTabWrapperState();
}

class _DefaultTabWrapperState extends State<DefaultTabWrapper>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;

  List<TabChild> get children => widget.children;
  OnTabChange? get onTabChange => widget.onTabChange;

  List<Tab> get _tabs => children.map((e) => Tab(text: e.tabName)).toList();

  @override
  void initState() {
    tabController = TabController(length: children.length, vsync: this);
    tabController.addListener(() {
      if (onTabChange != null) {
        onTabChange!(tabController.index);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _tabs.length == 1
            ? null
            : AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                titleSpacing: 0.0,
                title: TabBar(
                  unselectedLabelColor: Colors.black,
                  controller: tabController,
                  tabs: _tabs,
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.grey[500],
                )),
        body: TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: children.map((e) => e.child).toList(),
        ));
  }
}
