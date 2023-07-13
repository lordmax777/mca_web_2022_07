import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/approvals_action.dart';
import 'package:mca_dashboard/presentation/pages/approvals_view/tabs/request/request_wrapper.dart';
import 'package:mca_dashboard/presentation/pages/approvals_view/tabs/shift_release/shift_release_wrapper.dart';
import 'package:mca_dashboard/presentation/pages/approvals_view/tabs/user_qualif/user_qualif_wrapper.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ApprovalsView extends StatefulWidget {
  const ApprovalsView({super.key});

  @override
  State<ApprovalsView> createState() => _ApprovalsViewState();
}

class _ApprovalsViewState extends State<ApprovalsView>
    with SingleTickerProviderStateMixin {
  final tabs = const [
    Tab(text: "Requests"),
    Tab(text: "User Qualifications"),
    Tab(text: "Shift Releases"),
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

  void initFetch() {
    context.futureLoading(() async {
      final result = await dispatch<ApprovalMd>(const GetApprovalsAction());
    });
  }

  PlutoGridStateManager? shiftReleasePendingSm;
  PlutoGridStateManager? shiftReleaseCompletedSm;

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
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          // isScrollable: true,
        ),
      ),
      body: _getChild(),
    );
  }

  Widget _getChild() {
    switch (_tabController.index) {
      case 0:
        return const RequestWrapper();
      case 1:
        return const UserQualificationWrapper();
      case 2:
        return const ShiftReleaseWrapper();
      default:
        return const SizedBox();
    }
  }
}
