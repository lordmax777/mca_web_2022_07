import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/pages/approvals_view/tabs/request/req_pending_table.dart';
import 'package:mca_dashboard/utils/global_functions.dart';
import 'package:mca_dashboard/utils/table_helpers.dart';
import 'package:pluto_grid/pluto_grid.dart';

class RequestWrapper extends StatefulWidget {
  const RequestWrapper({super.key});

  @override
  State<RequestWrapper> createState() => _RequestWrapperState();
}

class _RequestWrapperState extends State<RequestWrapper>
    with
        SingleTickerProviderStateMixin,
        TableFocusNodeMixin<RequestWrapper, RequestMd, RequestMd> {
  final tabs = const [
    Tab(text: "Pending"),
    Tab(text: "Completed"),
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
          //init
        }
      },
    );
  }

  @override
  Future<List<RequestMd>?> fetch() async {
    return appStore.state.generalState.approvals.requests;
  }

  @override
  Future<List<RequestMd>?> fetch1() async {
    return appStore.state.generalState.approvals.requests;
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
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          StoreConnector<AppState, List<RequestMd>>(
            converter: (store) => store.state.generalState.approvals.requests,
            onDidChange: onDidChange,
            builder: (context, vm) {
              logger("RequestWrapper");
              return ReqPendingTable(
                onLoaded: onLoaded,
                focusNode: focusNode,
                rows: stateManager == null ? [] : stateManager!.rows,
              );
            },
          ),
          const Text("Completed Request"),
        ],
      ),
    );
  }
}
