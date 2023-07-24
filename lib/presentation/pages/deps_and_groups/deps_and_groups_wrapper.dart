import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_table.dart';
import 'package:mca_dashboard/presentation/pages/deps_and_groups/new_dep_popup.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'new_group_popup.dart';

class DepsAndGroupsWrapper extends StatefulWidget {
  const DepsAndGroupsWrapper({super.key});

  @override
  State<DepsAndGroupsWrapper> createState() => _DepsAndGroupsWrapperState();
}

class _DepsAndGroupsWrapperState extends State<DepsAndGroupsWrapper>
    with
        SingleTickerProviderStateMixin,
        TableFocusNodeMixin<DepsAndGroupsWrapper, JobTitleMd, GroupMd> {
  ListMd lists = ListMd.init();

  late final TabController tabController;
  final List<Tab> tabs = const [
    Tab(text: "Groups"),
    Tab(text: "Departments"),
  ];

  @override
  void initState() {
    tabController = TabController(length: tabs.length, vsync: this);
    lists = appStore.state.generalState.lists;
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: TabBar(
          unselectedLabelColor: Colors.black,
          controller: tabController,
          tabs: tabs,
          indicatorSize: TabBarIndicatorSize.tab,
          // isScrollable: true,
          dividerColor: Colors.grey[500],
        ),
      ),
      body: StoreConnector<AppState, ListMd>(
        onDidChange: (previousViewModel, viewModel) =>
            onDidChange(previousViewModel?.jobTitles, viewModel.jobTitles),
        converter: (store) => store.state.generalState.lists,
        builder: (context, vm) => TabBarView(
          controller: tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DefaultTable(
                hasFooter: false,
                headerEnd: ElevatedButton(
                    onPressed: () =>
                        onEdit((p0) => NewDepPopup(jobTitle: p0), null),
                    child: const Text("Add Group")),
                onLoaded: onLoaded,
                columns: columns,
                focusNode: focusNode,
                rows: stateManager == null ? [] : stateManager!.rows),
            DefaultTable(
                hasFooter: false,
                headerEnd: ElevatedButton(
                    onPressed: () =>
                        onEdit1((p0) => NewGroupPopup(model: p0), null),
                    child: const Text("Add Department")),
                onLoaded: onLoaded1,
                columns: columns1,
                focusNode: focusNode1,
                rows: stateManager1 == null
                    ? []
                    : stateManager1!.rows), // const GroupsView(),
          ],
        ),
      ),
    );
  }

  // @override
  // bool get enableLoading => false;

  @override
  PlutoRow buildRow(JobTitleMd model) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: model.name),
      "status": PlutoCell(value: model.active ? "Active" : "Inactive"),
      "action": PlutoCell(value: model),
    });
  }

  @override
  PlutoRow buildRow1(GroupMd model) {
    return PlutoRow(cells: {
      "name": PlutoCell(value: model.name),
      "status": PlutoCell(value: model.active ? "Active" : "Inactive"),
      "action": PlutoCell(value: model),
    });
  }

  @override
  Future<List<JobTitleMd>?> fetch() async {
    final res = await dispatch<ListMd>(const GetListsAction());
    if (res.isLeft) {
      return res.left.jobTitles;
    }
    return null;
  }

  @override
  Future<List<GroupMd>?> fetch1() async {
    final res = await dispatch<ListMd>(const GetListsAction());
    if (res.isLeft) {
      return res.left.groups;
    }
    return null;
  }

  @override
  List<PlutoColumn> get columns => [
        PlutoColumn(
          title: "Group Name",
          field: "name",
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
            title: "Status",
            field: "status",
            width: 60,
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 20,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onEdit: () {
                onEdit((p0) => NewDepPopup(jobTitle: p0),
                    rendererContext.row.cells["action"]!.value);
              },
              onDelete: () {
                final id = rendererContext.row.cells["action"]!.value.id;
                onDelete(() async {
                  final success =
                      await dispatch<bool>(DeleteJobTitleAction(id));
                  return success.isLeft && success.left;
                });
              },
            );
          },
        ),
      ];

  @override
  List<PlutoColumn> get columns1 => [
        PlutoColumn(
          title: "Department Name",
          field: "name",
          type: PlutoColumnType.text(),
        ),
        PlutoColumn(
            title: "Status",
            field: "status",
            width: 60,
            type: PlutoColumnType.text()),
        PlutoColumn(
          title: "Action",
          field: "action",
          width: 20,
          type: PlutoColumnType.text(),
          renderer: (rendererContext) {
            return rendererContext.actionMenuWidget(
              onEdit: () {
                onEdit1((p0) => NewGroupPopup(model: p0),
                    rendererContext.row.cells["action"]!.value);
              },
              onDelete: () {
                final id = rendererContext.row.cells["action"]!.value.id;
                onDelete1(() async {
                  final success = await dispatch<bool>(DeleteGroupAction(id));
                  return success.isLeft && success.left;
                });
              },
            );
          },
        ),
      ];
}
