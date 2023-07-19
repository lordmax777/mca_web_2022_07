import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/redux/states/general/actions/post_shift_release_action.dart';
import 'package:mca_dashboard/presentation/pages/approvals_view/tabs/shift_release/shift_release_pending_table.dart';
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
      body: _getChild(),
    );
  }

  @override
  PlutoRow buildRow(ApprovalModelMd model) {
    return PlutoRow(cells: {
      "requestedBy": PlutoCell(
          value: model
              .releaseCreatedByMd(appStore.state.generalState.users)
              ?.fullname),
      "requestedOn": PlutoCell(value: model.createdOn),
      "name": PlutoCell(value: model.title),
      "dateTime": PlutoCell(value: model.fromToDate), //start - end
      "comment": PlutoCell(value: ""),
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
            return ShiftReleasePendingTable(
              onLoaded: onLoaded,
              onApprove: onApprove,
              focusNode: focusNode,
              rows: stateManager == null ? [] : stateManager!.rows,
            );
          },
        );
      case 1:
        return StoreConnector<AppState, List<ApprovalModelMd>>(
          converter: (store) => store.state.generalState.approvals.releaseables,
          onDidChange: onDidChange1,
          builder: (context, vm) {
            return const SizedBox();
            // return ShiftReleasePublishedTable();
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void onApprove(PlutoRow? singleRow, String action) {
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
        String? comment = row.cells['comment']?.value;
        if (comment?.isEmpty ?? true) {
          comment = null;
        }
        final success = await dispatch<bool>(PostShiftReleaseAction(
          allocationId: id,
          action: action,
          comment: comment,
        ));
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
