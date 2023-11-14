import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/manager/redux/actions/approvals_action.dart';
import 'package:mca_dashboard/presentation/pages/approvals_view/tabs/request/req_completed_table.dart';
import 'package:mca_dashboard/presentation/pages/approvals_view/tabs/request/req_pending_table.dart';
import 'package:pluto_grid/pluto_grid.dart';

class RequestWrapper extends StatefulWidget {
  const RequestWrapper({super.key});

  @override
  State<RequestWrapper> createState() => _RequestWrapperState();
}

class _RequestWrapperState extends State<RequestWrapper>
    with
        SingleTickerProviderStateMixin,
        TableFocusNodeMixin<RequestWrapper, RequestMd, ClosedRequest> {
  final tabs = const [
    Tab(text: "Pending"),
    Tab(text: "Completed"),
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
  Future<List<RequestMd>?> fetch() async {
    return appStore.state.generalState.approvals.requests;
  }

  @override
  Future<List<ClosedRequest>?> fetch1() async {
    return appStore.state.generalState.approvals.closedRequests;
  }

  @override
  PlutoRow buildRow(RequestMd model) {
    return PlutoRow(cells: {
      "requestedOn": PlutoCell(value: model.createdOn),
      "name": PlutoCell(value: model.fullname),
      "type": PlutoCell(
          value: model
              .typeMd(appStore.state.generalState.lists.requestTypes)
              ?.name),
      "dateTime": PlutoCell(value: model.fromToDate), //start - end
      "comment": PlutoCell(value: model.comment),
      "yourComment": PlutoCell(value: ""),
      "action": PlutoCell(value: model),
    });
  }

  @override
  PlutoRow buildRow1(ClosedRequest model) {
    return PlutoRow(cells: {
      "requestedOn": PlutoCell(value: model.createdOn),
      "name": PlutoCell(value: model.fullname),
      "type": PlutoCell(
          value: model
              .typeMd(appStore.state.generalState.lists.requestTypes)
              ?.name),
      "dateTime": PlutoCell(value: model.fromToDate), //start - end
      "managerComment": PlutoCell(value: model.requestcomment),
      "comment": PlutoCell(value: model.comment),
      "yourComment": PlutoCell(value: ""),
      "status": PlutoCell(value: model.accepted == 1 ? "Approved" : "Rejected"),
      "action": PlutoCell(value: model),
    });
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
        body: _getChild());
  }

  Widget _getChild() {
    switch (_tabController.index) {
      case 0:
        return StoreConnector<AppState, List<RequestMd>>(
          converter: (store) => store.state.generalState.approvals.requests,
          onDidChange: onDidChange,
          builder: (context, vm) {
            return ReqPendingTable(
              onLoaded: onLoaded,
              onApprove: onApprove,
              focusNode: focusNode,
              rows: stateManager == null ? [] : stateManager!.rows,
            );
          },
        );
      case 1:
        return StoreConnector<AppState, List<ClosedRequest>>(
          converter: (store) =>
              store.state.generalState.approvals.closedRequests,
          onDidChange: onDidChange1,
          builder: (context, vm) {
            return ReqCompletedTable(
              onLoaded: onLoaded1,
              onApprove: onApprove1,
              focusNode: focusNode1,
              rows: stateManager1 == null ? [] : stateManager1!.rows,
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void onApprove(PlutoRow? singleRow, bool isApprove) {
    context.futureLoading<void>(() async {
      final selected = [...stateManager!.checkedRows];
      if (singleRow != null) {
        selected.clear();
        selected.add(singleRow);
      }
      if (selected.isEmpty) {
        return;
      }
      final List<String> failed = [];
      for (final row in selected) {
        final id = row.cells['action']!.value.id;
        String? comment = row.cells['yourComment']?.value;
        if (comment == "") {
          comment = null;
        }
        final success = await dispatch<bool>(
            ApproveRequestAction(id, isApprove, comment: comment));
        if (success.isRight) {
          failed.add(row.cells['name']!.value);
        }
      }
      if (failed.isNotEmpty) {
        context.showError("Failed ${failed.join(", ")}");
      }
    });
  }

  void onApprove1(PlutoRow? singleRow, bool isApprove) {
    context.futureLoading<void>(() async {
      final selected = [...stateManager1!.checkedRows];
      if (singleRow != null) {
        selected.clear();
        selected.add(singleRow);
      }
      if (selected.isEmpty) {
        return;
      }
      final List<String> failed = [];
      for (final row in selected) {
        final id = row.cells['action']!.value.id;
        String? comment = row.cells['yourComment']?.value;
        if (comment == "") {
          comment = null;
        }
        final success = await dispatch<bool>(
            ApproveRequestAction(id, isApprove, comment: comment));
        if (success.isRight) {
          failed.add(row.cells['name']!.value);
        }
      }
      if (failed.isNotEmpty) {
        context.showError("Failed ${failed.join(", ")}");
      }
    });
  }
}
