import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/approvals_action.dart';
import 'package:mca_dashboard/presentation/pages/approvals_view/tabs/shift_release/shift_release_pending_table.dart';
import 'package:mca_dashboard/utils/utils.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../../manager/manager.dart';

class ShiftReleaseWrapper extends StatefulWidget {
  const ShiftReleaseWrapper({super.key});

  @override
  State<ShiftReleaseWrapper> createState() => _ShiftReleaseWrapperState();
}

class _ShiftReleaseWrapperState extends State<ShiftReleaseWrapper>
    with
        SingleTickerProviderStateMixin,
        TableFocusNodeMixin<ShiftReleaseWrapper, ApprovalModelMd,
            ApprovalModelMd> {
  final tabs = const [
    Tab(text: "Pending"),
    Tab(text: "Published"),
  ];

  late final TabController _tabController;

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
  }

  @override
  Future<List<ApprovalModelMd>?> fetch() async {
    return appStore.state.generalState.approvals.releaseables;
  }

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
      body: SizedBox.expand(
        child: _getChild(),
      ),
    );
  }

  @override
  PlutoRow buildRow(ApprovalModelMd model) {
    return PlutoRow(cells: {
      "requestedOn": PlutoCell(value: model.createdOn),
      "name": PlutoCell(value: model.title),
      "type": PlutoCell(value: model.createdOn),
      "dateTime": PlutoCell(value: model.date), //start - end
      "comment": PlutoCell(value: model.active),
      "action": PlutoCell(value: model),
    });
  }

  Widget _getChild() {
    switch (_tabController.index) {
      case 0:
        return StoreConnector<AppState, List<ApprovalModelMd>>(
          converter: (store) => store.state.generalState.approvals.releaseables,
          onDidChange: onDidChange,
          builder: (context, vm) {
            return Text("Pending");
          },
        );
      case 1:
        return StoreConnector<AppState, List<ApprovalModelMd>>(
          converter: (store) => store.state.generalState.approvals.releaseables,
          onDidChange: onDidChange1,
          builder: (context, vm) {
            return ShiftReleasePendingTable(
              onLoaded: onLoaded,
              onApprove: (singleRow, isApprove) {},
              focusNode: focusNode,
              rows: stateManager == null ? [] : stateManager!.rows,
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
