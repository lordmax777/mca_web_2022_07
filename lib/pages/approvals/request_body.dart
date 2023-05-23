import 'package:flutter_redux/flutter_redux.dart';import '../../manager/models/approval_md.dart';import '../../manager/redux/sets/app_state.dart';import '../../manager/redux/states/general_state.dart';import '../../theme/theme.dart';import '../properties/property_drawer.dart';class RequestBodyWithTab extends StatefulWidget {  final int? tabIndex;  RequestBodyWithTab({Key? key, this.tabIndex}) : super(key: key) {    tabIndex ?? 0;  }  @override  State<RequestBodyWithTab> createState() => _RequestBodyWithTabState();}class _RequestBodyWithTabState extends State<RequestBodyWithTab>    with SingleTickerProviderStateMixin {  late final TabController _tabController;  final List<Tab> tabs = const [    Tab(text: 'Pending'),    Tab(text: 'Complete'),  ];  final TextEditingController _searchController = TextEditingController();  @override  void initState() {    super.initState();    _tabController = TabController(length: tabs.length, vsync: this);    if (widget.tabIndex != null) {      _tabController.animateTo(widget.tabIndex!);    }    _tabController.addListener(() {      setState(() {});    });  }  void _setFilter() {    _searchController.addListener(() {      if (_searchController.text.isNotEmpty) {        if (stateManager!.page > 1) {          stateManager!.setPage(1);        }        stateManager!.setFilter(          (element) {            final String search = _searchController.text.toLowerCase();            bool searched =                element.cells['name']?.value.toLowerCase().contains(search);            if (!searched) {              searched = element.cells['contact']?.value                  .toLowerCase()                  .contains(search);              if (!searched) {                searched = element.cells['value']!.value                    .toString()                    .toLowerCase()                    .contains(search);                if (!searched) {                  searched = element.cells['last_sent']?.value                      .toLowerCase()                      .contains(search);                  if (!searched) {                    searched = element.cells['created_on']?.value                        .toLowerCase()                        .contains(search);                    if (!searched) {                      searched = element.cells['valid_until']?.value                          .toLowerCase()                          .contains(search);                      if (!searched) {                        searched = element.cells['contact']?.value                            .toLowerCase()                            .contains(search);                      }                    }                  }                }              }            }            return searched;          },        );        _onPageChange(stateManager!.page);        _onPageSizeChange(Constants.tablePageSizes[0].toString());        return;      }      stateManager!.setFilter((element) => true);      _onPageChange(stateManager!.page);      _onPageSizeChange(Constants.tablePageSizes[0].toString());    });  }  List<PlutoColumn> get columns => [        PlutoColumn(          title: "Requested On",          field: "requestedOn",          type: PlutoColumnType.text(),        ),        PlutoColumn(          title: "Name",          field: "name",          type: PlutoColumnType.text(),        ),        PlutoColumn(            title: "Type", field: "offdayType", type: PlutoColumnType.text()),        PlutoColumn(            title: "Date / Time",            field: "dateTime",            type: PlutoColumnType.text()),        PlutoColumn(          title: "Comments",          field: "comments",          enableSorting: false,          type: PlutoColumnType.text(),          renderer: (rendererContext) =>              GridTableHelpers.getMainColoredRenderer(rendererContext,                  title: rendererContext.cell.value.toString(),                  onTap: (PlutoColumnRendererContext ctx) =>                      _onColumnItemNavigate(ctx)),        ),        PlutoColumn(          title: "Action",          field: "action",          enableSorting: false,          type: PlutoColumnType.text(),          renderer: (rendererContext) =>              GridTableHelpers.getActionRendererForApproval(rendererContext,                  approveBtnTap: (_) {}, declineBtnTap: (_) {}),        ),      ].map((e) {        final e1 = e;        e1.textAlign = PlutoColumnTextAlign.center;        return e1;      }).toList();  List<PlutoColumn> get columns1 => [        PlutoColumn(          title: "Requested On",          field: "requestedOn",          type: PlutoColumnType.text(),        ),        PlutoColumn(          title: "Name",          field: "name",          type: PlutoColumnType.text(),        ),        PlutoColumn(            title: "Type", field: "offdayType", type: PlutoColumnType.text()),        PlutoColumn(            title: "Date / Time",            field: "dateTime",            type: PlutoColumnType.text()),        PlutoColumn(          title: "Comments",          field: "comments",          enableSorting: false,          type: PlutoColumnType.text(),          renderer: (rendererContext) =>              GridTableHelpers.getMainColoredRenderer(rendererContext,                  title: rendererContext.cell.value.toString(),                  onTap: (PlutoColumnRendererContext ctx) =>                      _onColumnItemNavigate(ctx)),        ),        PlutoColumn(            title: "Action",            field: "action",            enableSorting: false,            type: PlutoColumnType.text(),            renderer: (rendererContext) =>                GridTableHelpers.getActionRendererForApproval(rendererContext,                    approveBtnTap: (_) {}, declineBtnTap: (_) {})),      ].map((e) {        final e1 = e;        e1.textAlign = PlutoColumnTextAlign.center;        return e1;      }).toList();  PlutoGridStateManager? stateManager;  bool get isStateManagerInitialized => stateManager != null;  void _onPageSizeChange(String pageS) {    int pageSize = int.tryParse(pageS) ?? 10;    stateManager!.setPageSize(pageSize);    stateManager!.setPage(1);  }  void _onPageChange(int page) {    stateManager!.setPage(page);  }  PlutoGridStateManager? stateManager1;  bool get isStateManagerInitialized1 => stateManager != null;  void _onPageSizeChange1(String pageS) {    int pageSize = int.tryParse(pageS) ?? 10;    stateManager1!.setPageSize(pageSize);    stateManager1!.setPage(1);  }  void _onPageChange1(int page) {    stateManager1!.setPage(page);  }  @override  Widget build(BuildContext context) {    return StoreConnector<AppState, AppState>(      converter: (store) => store.state,      builder: (_, state) => SizedBox(          height: 850,          child: Column(            crossAxisAlignment: CrossAxisAlignment.start,            children: [              SizedBox(                width: double.infinity,                child: TabBar(                  overlayColor: MaterialStateProperty.all(Colors.transparent),                  controller: _tabController,                  splashFactory: NoSplash.splashFactory,                  isScrollable: true,                  indicatorWeight: 3.0,                  indicatorColor: ThemeColors.MAIN_COLOR,                  labelColor: ThemeColors.MAIN_COLOR,                  unselectedLabelColor: ThemeColors.black,                  labelStyle: ThemeText.tabTextStyle                      .copyWith(color: ThemeColors.MAIN_COLOR),                  unselectedLabelStyle: ThemeText.tabTextStyle,                  tabs: tabs,                ),              ),              const Divider(height: 0, color: ThemeColors.gray11),              _getTabChild(context, state),            ],          )),    );  }  PlutoRow _buildRow(ApprovalRequest approval, {bool checked = false}) {    String? requestedOn =        "${approval.createdOn?.date.substring(0, 10).replaceAll("-", "/")}, ${approval.createdOn?.date.substring(10, 16).replaceAll("-", "/")}";    String? name = "${approval.firstName} ${approval.lastName}";    String? offdayType = approval.typeId.toString();    String? dateTime =        "${approval.start?.date.substring(0, 10).replaceAll("-", "/")} - ${approval.finish?.date.substring(0, 10).replaceAll("-", "/")}";    String? comments = approval.comment;    return PlutoRow(      checked: checked,      cells: {        'requestedOn': PlutoCell(value: requestedOn),        'name': PlutoCell(value: name),        'offdayType': PlutoCell(value: offdayType),        'dateTime': PlutoCell(value: dateTime),        'comments': PlutoCell(value: comments),        'action': PlutoCell(value: ""),      },    );  }  PlutoRow _buildRow1(ApprovalRequest approval, {bool checked = false}) {    String? requestedOn =        "${approval.createdOn?.date.substring(0, 10).replaceAll("-", "/")}, ${approval.createdOn?.date.substring(10, 16).replaceAll("-", "/")}";    String? name = "${approval.firstName} ${approval.lastName}";    String? offdayType = approval.typeId.toString();    String? dateTime =        "${approval.start?.date.substring(0, 10).replaceAll("-", "/")} - ${approval.finish?.date.substring(0, 10).replaceAll("-", "/")}";    String? comments = approval.comment;    return PlutoRow(      checked: checked,      cells: {        'requestedOn': PlutoCell(value: requestedOn),        'name': PlutoCell(value: name),        'offdayType': PlutoCell(value: offdayType),        'dateTime': PlutoCell(value: dateTime),        'comments': PlutoCell(value: comments),        'action': PlutoCell(value: ""),      },    );  }  Widget _getTabChild(BuildContext context, AppState state) {    switch (_tabController.index) {      case 0:        return pending(context, state);      case 1:        return complete(context, state);      default:        return const SizedBox();    }  }  Widget pending(BuildContext context, AppState state) {    return tableBodyPending(context, state);  }  Widget tableBodyPending(BuildContext context, AppState state) {    return TableWrapperWidget(        enableShadow: false,        padding: const EdgeInsets.all(0),        child: SizedBox(          width: double.infinity,          child: SpacedColumn(            mainAxisAlignment: MainAxisAlignment.spaceBetween,            crossAxisAlignment: CrossAxisAlignment.start,            children: [              _headerPending(context),              _bodyPending(state),              const Divider(                color: ThemeColors.gray11,                thickness: 1.0,              ),              if (isStateManagerInitialized) _footerPending(state),            ],          ),        ));  }  Widget _bodyPending(AppState state) {    return ApprovalReqBodyTable(        gridBorderColor: Colors.grey[300]!,        rows: [],        noRowsText: 'No Approval Request found',        onSmReady: (p0) {          //   if (!isStateManagerInitialized) {          //     stateManager = p0;          //     stateManager!.addListener(() {          //       setState(() {});          //     });          //     // final allApprovalReq = state.generalState.allSortedApprovalReq;          //     stateManager!.removeAllRows();          //     // stateManager!          //     //     .appendRows(allApprovalReq.map((e) => _buildRow(e)).toList());          //          //     _setFilter();          //   }          //   stateManager!.setPage(1);          //   stateManager!.setPageSize(10);          // },          if (!isStateManagerInitialized) {            stateManager = p0;            stateManager!.addListener(() {              setState(() {});            });            final List<ApprovalRequest> allApprovalReq =                state.generalState.approvalRequest;            logger("allApprovalReq: ${allApprovalReq[0].toJson()}.");            stateManager!.removeAllRows();            stateManager!                .appendRows(allApprovalReq.map((e) => _buildRow(e)).toList());            _setFilter();          }          stateManager!.setPage(1);          stateManager!.setPageSize(10);        },        cols: columns);  }  Widget _headerPending(BuildContext context) {    double dpWidth = 150;    double inputWidth = 344;    return SpacedColumn(children: [      SizedBox(          width: double.infinity,          child: SingleChildScrollView(              child: SpacedColumn(                  crossAxisAlignment: CrossAxisAlignment.center,                  mainAxisAlignment: MainAxisAlignment.center,                  verticalSpace: 8.0,                  children: [                Padding(                    padding: const EdgeInsets.symmetric(                        horizontal: 16.0, vertical: 8.0),                    child: SpacedRow(                        crossAxisAlignment: CrossAxisAlignment.center,                        mainAxisAlignment: MainAxisAlignment.spaceBetween,                        children: [                          TextInputWidget(                            width: inputWidth,                            heigth: 48,                            leftIcon: HeroIcons.search,                            hintText: 'Search ...',                            controller: TextEditingController(),                          ),                          SizedBox(                            height: 48,                            child: DropdownWidget(                                hintText: "Action",                                dropdownBtnWidth: dpWidth,                                dropdownOptionsWidth: dpWidth,                                onChanged: (val) {},                                items: const [                                  "Approve Selected",                                  "Decline Selected",                                ]),                          )                        ])),                const Divider(height: 0, color: ThemeColors.gray11),              ]))),      const Divider(height: 0, color: ThemeColors.gray11),    ]);  }  Widget _footerPending(AppState state) {    return Padding(      padding:          const EdgeInsets.only(left: 16.0, right: 32.0, top: 4.0, bottom: 4.0),      child: SpacedRow(          mainAxisAlignment: MainAxisAlignment.spaceBetween,          children: [            SpacedRow(                horizontalSpace: 8.0,                crossAxisAlignment: CrossAxisAlignment.center,                children: [                  KText(                      text: "Showing",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                  DropdownWidgetV2(                    hintText: "Entries",                    items: Constants.tablePageSizes                        .map((e) => CustomDropdownValue(name: e.toString()))                        .toList(),                    dropdownBtnWidth: 120,                    onChanged: (index) => _onPageSizeChange(                        Constants.tablePageSizes[index].toString()),                    value: CustomDropdownValue(                        name: stateManager!.pageSize.toString()),                  ),                  KText(                      text: "of ${stateManager!.rows.length} entries",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                ]),            TablePaginationWidget(                currentPage: stateManager!.page,                totalPages: stateManager!.totalPage,                onPageChanged: (int i) => _onPageChange(i)),          ]),    );  }  Widget complete(BuildContext context, AppState state) {    return tableBodyComplete(context, state);  }  Widget tableBodyComplete(BuildContext context, AppState state) {    return TableWrapperWidget(        enableShadow: false,        padding: const EdgeInsets.all(0),        child: SizedBox(          width: double.infinity,          child: SpacedColumn(            mainAxisAlignment: MainAxisAlignment.spaceBetween,            crossAxisAlignment: CrossAxisAlignment.start,            children: [              _headerComplete(context),              _bodyComplete(state),              const Divider(                color: ThemeColors.gray11,                thickness: 1.0,              ),              if (isStateManagerInitialized) _footerComplete(state),            ],          ),        ));  }  Widget _bodyComplete(AppState state) {    return ApprovalReqBodyTable(        gridBorderColor: Colors.grey[300]!,        rows: [],        noRowsText: 'No Approval Request found',        onSmReady: (p0) {          if (!isStateManagerInitialized1!) {            stateManager1 = p0;            stateManager1!.addListener(() {              setState(() {});            });            // final allApprovalReqComplete =            //     state.generalState.allSortedApprovalReq;            stateManager1!.removeAllRows();            // stateManager1!.appendRows(            //     allApprovalReqComplete.map((e) => _buildRow1(e)).toList());            _setFilter();          }          stateManager1!.setPage(1);          stateManager1!.setPageSize(10);        },        cols: columns);  }  Widget _headerComplete(BuildContext context) {    double dpWidth = 150;    double inputWidth = 344;    return SpacedColumn(children: [      SizedBox(          width: double.infinity,          child: SingleChildScrollView(              child: SpacedColumn(                  crossAxisAlignment: CrossAxisAlignment.center,                  mainAxisAlignment: MainAxisAlignment.center,                  verticalSpace: 8.0,                  children: [                Padding(                    padding: const EdgeInsets.symmetric(                        horizontal: 16.0, vertical: 8.0),                    child: SpacedRow(                        crossAxisAlignment: CrossAxisAlignment.center,                        mainAxisAlignment: MainAxisAlignment.spaceBetween,                        children: [                          TextInputWidget(                            width: inputWidth,                            heigth: 48,                            leftIcon: HeroIcons.search,                            hintText: 'Search ...',                            controller: TextEditingController(),                          ),                          SizedBox(                            height: 48,                            child: DropdownWidget(                                hintText: "Action",                                dropdownBtnWidth: dpWidth,                                dropdownOptionsWidth: dpWidth,                                onChanged: (val) {},                                items: const [                                  "Basic",                                  "Premium",                                  "Enterprise"                                ]),                          )                        ])),                const Divider(height: 0, color: ThemeColors.gray11),              ]))),      const Divider(height: 0, color: ThemeColors.gray11),    ]);  }  Widget _footerComplete(AppState state) {    return Padding(      padding:          const EdgeInsets.only(left: 16.0, right: 32.0, top: 4.0, bottom: 4.0),      child: SpacedRow(          mainAxisAlignment: MainAxisAlignment.spaceBetween,          children: [            SpacedRow(                horizontalSpace: 8.0,                crossAxisAlignment: CrossAxisAlignment.center,                children: [                  KText(                      text: "Showing",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                  DropdownWidgetV2(                    hintText: "Entries",                    items: Constants.tablePageSizes                        .map((e) => CustomDropdownValue(name: e.toString()))                        .toList(),                    dropdownBtnWidth: 120,                    onChanged: (index) => _onPageSizeChange1(                        Constants.tablePageSizes[index].toString()),                    value: CustomDropdownValue(                        name: stateManager!.pageSize.toString()),                  ),                  KText(                      text: "of ${stateManager!.rows.length} entries",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                ]),            TablePaginationWidget(                currentPage: stateManager!.page,                totalPages: stateManager!.totalPage,                onPageChanged: (int i) => _onPageChange1(i)),          ]),    );  }  Future<void> _onColumnItemNavigate(PlutoColumnRendererContext ctx) async {    appStore.dispatch(UpdateUIStateAction(        endDrawer: PropertyDrawer(      property: ctx.row.cells['action']?.value,    )));    await Future.delayed(const Duration(milliseconds: 100));    if (Constants.scaffoldKey.currentState != null) {      if (!Constants.scaffoldKey.currentState!.isDrawerOpen) {        Constants.scaffoldKey.currentState!.openEndDrawer();      }    }  }}