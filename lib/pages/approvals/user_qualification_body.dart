import 'package:flutter_redux/flutter_redux.dart';import '../../manager/models/approval_md.dart';import '../../manager/redux/sets/app_state.dart';import '../../manager/redux/states/general_state.dart';import '../../theme/theme.dart';import '../properties/property_drawer.dart';class UserQualificationBody extends StatefulWidget {  const UserQualificationBody({Key? key}) : super(key: key);  @override  State<UserQualificationBody> createState() => _UserQualificationBodyState();}class _UserQualificationBodyState extends State<UserQualificationBody> {  //Header  final TextEditingController _searchController = TextEditingController();  PlutoGridStateManager? stateManager;  bool get isStateManagerInitialized => stateManager != null;  void _onPageSizeChange(String pageS) {    int pageSize = int.tryParse(pageS) ?? 10;    stateManager!.setPageSize(pageSize);    stateManager!.setPage(1);  }  void _onPageChange(int page) {    stateManager!.setPage(page);  }  void _setFilter() {    _searchController.addListener(() {      //TODO: NOT WORKING      if (_searchController.text.isNotEmpty) {        if (stateManager!.page > 1) {          stateManager!.setPage(1);        }        stateManager!.setFilter(          (element) {            final String search = _searchController.text.toLowerCase();            bool searched =                element.cells['name']?.value.toLowerCase().contains(search);            if (!searched) {              searched = element.cells['contact']?.value                  .toLowerCase()                  .contains(search);              if (!searched) {                searched = element.cells['value']!.value                    .toString()                    .toLowerCase()                    .contains(search);                if (!searched) {                  searched = element.cells['last_sent']?.value                      .toLowerCase()                      .contains(search);                  if (!searched) {                    searched = element.cells['created_on']?.value                        .toLowerCase()                        .contains(search);                    if (!searched) {                      searched = element.cells['valid_until']?.value                          .toLowerCase()                          .contains(search);                      if (!searched) {                        searched = element.cells['contact']?.value                            .toLowerCase()                            .contains(search);                      }                    }                  }                }              }            }            return searched;          },        );        _onPageChange(stateManager!.page);        _onPageSizeChange(Constants.tablePageSizes[0].toString());        return;      }      stateManager!.setFilter((element) => true);      _onPageChange(stateManager!.page);      _onPageSizeChange(Constants.tablePageSizes[0].toString());    });  }  List<PlutoColumn> get columns => [        PlutoColumn(          title: "User",          field: "user",          type: PlutoColumnType.text(),        ),        PlutoColumn(          title: "Qualification",          field: "qualification",          type: PlutoColumnType.text(),        ),        PlutoColumn(            title: "Document No",            field: "documentNo",            type: PlutoColumnType.text()),        PlutoColumn(            title: "Data Acquired",            field: "dataAcquired",            type: PlutoColumnType.date(              format: 'dd/MM/yyyy',            )),        PlutoColumn(            title: "Expiry Date",            field: "expiryDate",            type: PlutoColumnType.date(              format: 'dd/MM/yyyy',            )),        PlutoColumn(          title: "Comments",          field: "comments",          enableSorting: false,          type: PlutoColumnType.text(),          renderer: (rendererContext) =>              GridTableHelpers.getMainColoredRenderer(rendererContext,                  title: rendererContext.cell.value.toString(),                  onTap: (PlutoColumnRendererContext ctx) =>                      _onColumnItemNavigate(ctx)),        ),        PlutoColumn(          title: "Action",          field: "action",          width: 240,          enableSorting: false,          type: PlutoColumnType.text(),          renderer: (rendererContext) =>              GridTableHelpers.getActionRendererForApproval(rendererContext,                  approveBtnTap: (_) {}, declineBtnTap: (_) {}),        ),      ].map((e) {        final e1 = e;        e1.textAlign = PlutoColumnTextAlign.center;        return e1;      }).toList();  @override  Widget build(BuildContext context) {    return StoreConnector<AppState, AppState>(        converter: (store) => store.state,        builder: (_, state) => SpacedColumn(                mainAxisAlignment: MainAxisAlignment.spaceBetween,                crossAxisAlignment: CrossAxisAlignment.start,                children: [                  _buildTopSec(),                  tableBodyPending(context, state),                ]));  }  Widget _buildTopSec() {    double dpWidth = 150;    double inputWidth = 344;    return SizedBox(        height: 80,        child: SpacedColumn(            crossAxisAlignment: CrossAxisAlignment.center,            mainAxisAlignment: MainAxisAlignment.center,            verticalSpace: 8.0,            children: [              Padding(                  padding: const EdgeInsets.symmetric(                    horizontal: 16.0,                    vertical: 8.0,                  ),                  child: SpacedRow(                      crossAxisAlignment: CrossAxisAlignment.center,                      mainAxisAlignment: MainAxisAlignment.spaceBetween,                      children: [                        TextInputWidget(                          width: inputWidth,                          heigth: 48,                          leftIcon: HeroIcons.search,                          hintText: 'Search ...',                          controller: TextEditingController(),                        ),                        SizedBox(                          height: 48,                          child: DropdownWidget(                              hintText: "Action",                              dropdownBtnWidth: dpWidth,                              dropdownOptionsWidth: dpWidth,                              onChanged: (val) {},                              value: "Approve Selected",                              items: const [                                "Approve Selected",                                "Decline Selected",                              ]),                        )                      ])),              const Divider(height: 0, color: ThemeColors.gray11),            ]));  }  Widget tableBodyPending(BuildContext context, AppState state) {    return TableWrapperWidget(        enableShadow: false,        padding: const EdgeInsets.all(0),        child: SizedBox(          width: double.infinity,          child: SpacedColumn(            mainAxisAlignment: MainAxisAlignment.spaceBetween,            crossAxisAlignment: CrossAxisAlignment.start,            children: [              _body(state),              const Divider(                color: ThemeColors.gray11,                thickness: 1.0,              ),              if (isStateManagerInitialized) _footer(state),            ],          ),        ));  }  Widget _body(AppState state) {    return ApprovalReqBodyTable(        gridBorderColor: Colors.grey[300]!,        rows: [],        noRowsText: 'No User Qualifications found',        onSmReady: (p0) {          if (!isStateManagerInitialized) {            stateManager = p0;            stateManager!.addListener(() {              setState(() {});            });            final List<ApprovalPendingUserQlf> allApprovalUserQualifications =                state.generalState.approvalPendingUserQlf;            logger(                "allApprovalUserQualifications: ${allApprovalUserQualifications[0].toJson()}.");            stateManager!.removeAllRows();            stateManager!.appendRows(allApprovalUserQualifications                .map((e) => _buildRow(e))                .toList());            _setFilter();          }          stateManager!.setPage(1);          stateManager!.setPageSize(10);        },        cols: columns);  }  Widget _footer(AppState state) {    return Padding(      padding:          const EdgeInsets.only(left: 16.0, right: 32.0, top: 4.0, bottom: 4.0),      child: SpacedRow(          mainAxisAlignment: MainAxisAlignment.spaceBetween,          children: [            SpacedRow(                horizontalSpace: 8.0,                crossAxisAlignment: CrossAxisAlignment.center,                children: [                  KText(                      text: "Showing",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                  KText(                      text: "of ${stateManager!.rows.length} entries",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                ]),            TablePaginationWidget(                currentPage: stateManager!.page,                totalPages: stateManager!                    .totalPage, //(widget._itemCount / _pageSize).ceil(),                onPageChanged: (int i) => _onPageChange(i)),          ]),    );  }  PlutoRow _buildRow(ApprovalPendingUserQlf approvalReq,      {bool checked = false}) {    String? user = approvalReq.title;    String? qualification = approvalReq.qualComment;    String? documentNo = approvalReq.certificateNumber;    String? dataAcquired =        "${approvalReq.achievementDate?.date.substring(0, 10).replaceAll("-", "/")}";    String? expiryDate =        "${approvalReq.expiryDate?.date.substring(0, 10).replaceAll("-", "/")}";    String? comments = approvalReq.comments;    String? action = "";    return PlutoRow(      checked: checked,      cells: {        'user': PlutoCell(value: user),        'qualification': PlutoCell(value: qualification),        'documentNo': PlutoCell(value: documentNo),        'dataAcquired': PlutoCell(value: dataAcquired),        'expiryDate': PlutoCell(value: expiryDate),        'comments': PlutoCell(value: comments),        'action': PlutoCell(value: ""),      },    );  }  Future<void> _onColumnItemNavigate(PlutoColumnRendererContext ctx) async {    appStore.dispatch(UpdateUIStateAction(        endDrawer: PropertyDrawer(      property: ctx.row.cells['action']?.value,    )));    await Future.delayed(const Duration(milliseconds: 100));    if (Constants.scaffoldKey.currentState != null) {      if (!Constants.scaffoldKey.currentState!.isDrawerOpen) {        Constants.scaffoldKey.currentState!.openEndDrawer();      }    }  }}