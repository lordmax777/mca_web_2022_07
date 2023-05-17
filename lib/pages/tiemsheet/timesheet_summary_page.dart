import 'package:flutter_redux/flutter_redux.dart';import 'package:mca_web_2022_07/comps/dropdown_widget1.dart';import 'package:mca_web_2022_07/pages/tiemsheet/timesheet_drawer.dart';import '../../comps/show_overlay_popup.dart';import '../../manager/models/timesheet_dep_md.dart';import '../../manager/redux/sets/app_state.dart';import '../../manager/redux/states/general_state.dart';import '../../theme/theme.dart';class TimesheetSummaryPage extends StatefulWidget {  TimesheetSummaryPage({Key? key}) : super(key: key);  @override  State<TimesheetSummaryPage> createState() => _TimesheetSummaryPageState();}class _TimesheetSummaryPageState extends State<TimesheetSummaryPage> {  TextEditingController clockInCntr = TextEditingController();  TextEditingController clockOutCntr = TextEditingController();  PlutoGridStateManager? stateManager;  bool get isStateManagerInitialized => stateManager != null;  @override  Widget build(BuildContext context) {    return StoreConnector<AppState, AppState>(        converter: (store) => store.state,        builder: (_, state) => PageWrapper(              child: SpacedColumn(verticalSpace: 16.0, children: [                SpacedRow(                    crossAxisAlignment: CrossAxisAlignment.center,                    horizontalSpace: 16.0,                    children: [                      InkWell(                        onTap: () {                          Navigator.pop(context);                        },                        child: const HeroIcon(                          HeroIcons.arrowLeft,                          size: 26,                        ),                      ),                      KText(                        text: "Summary",                        fontSize: 24,                        fontWeight: FWeight.bold,                        isSelectable: false,                        textColor: ThemeColors.gray1,                      ),                    ]),                ErrorWrapper(                    errors: [],                    child: TableWrapperWidget(                        child: SpacedColumn(children: [                      _buildTopSec(),                      _buildMainBody(context, state),                    ])))              ]),            ));  }  List<PlutoColumn> get columns => [        PlutoColumn(          title: "Date",          field: "date",          type: PlutoColumnType.text(),        ),        PlutoColumn(            title: "Shift", field: "shift", type: PlutoColumnType.text()),        PlutoColumn(          title: "Actual Time",          field: "actualTime",          type: PlutoColumnType.text(),          renderer: (rendererContext) => GridTableHelpers.getActionRenderer(            title: rendererContext                .row.cells[rendererContext.column.field]!.value                .toString(),            disableIcon: true,            rendererContext,            onTap: (PlutoColumnRendererContext ctx) =>                _onColumnItemTap(ctx, context),          ),        ),        PlutoColumn(          title: "Agreed Time",          field: "agreedTime",          enableSorting: false,          type: PlutoColumnType.text(),        ),        PlutoColumn(            title: "Paid Hours",            field: "paidHours",            enableSorting: false,            type: PlutoColumnType.text()),        PlutoColumn(          title: "Agreed Hours",          field: "agreedHours",          enableSorting: false,          type: PlutoColumnType.text(),        ),        PlutoColumn(          title: "Actual Hours",          field: "actualHours",          enableSorting: false,          type: PlutoColumnType.text(),        ),        PlutoColumn(          title: "Requests",          field: "requests",          enableSorting: false,          type: PlutoColumnType.text(),        ),        PlutoColumn(          title: "Comments",          field: "comments",          enableSorting: false,          type: PlutoColumnType.text(),        ),        PlutoColumn(          title: "Check",          field: "check",          enableSorting: false,          type: PlutoColumnType.text(),        ),      ].map((e) {        final e1 = e;        e1.textAlign = PlutoColumnTextAlign.center;        return e1;      }).toList();  Widget _buildTopSec() {    return SizedBox(        height: 80,        child: SpacedColumn(            crossAxisAlignment: CrossAxisAlignment.center,            mainAxisAlignment: MainAxisAlignment.center,            verticalSpace: 8.0,            children: [              Padding(                  padding: const EdgeInsets.symmetric(                    horizontal: 16.0,                    vertical: 8.0,                  ),                  child: SpacedRow(                    crossAxisAlignment: CrossAxisAlignment.center,                    mainAxisAlignment: MainAxisAlignment.spaceBetween,                    children: [                      SpacedRow(                          crossAxisAlignment: CrossAxisAlignment.start,                          horizontalSpace: 16.0,                          children: [                            ButtonMediumSecondary(                                leftIcon: const HeroIcon(HeroIcons.users),                                text: "Department",                                onPressed: () {}),                            ButtonMediumSecondary(                                leftIcon: const HeroIcon(HeroIcons.loop),                                text: "Switch",                                onPressed: () {}),                          ]),                      SizedBox(                          height: 48,                          child: PopupMenuButton(                            shape: RoundedRectangleBorder(                                borderRadius: BorderRadius.circular(8.0)),                            constraints: const BoxConstraints(                                minWidth: 48, minHeight: 48),                            child: _buildDownloadReportBtn(),                            itemBuilder: (BuildContext context) {                              return [                                PopupMenuItem(                                    onTap: null,                                    enabled: false,                                    child: singleMenu(                                        text: "Summary",                                        onPressCsv: () {},                                        onPressPdf: () {})),                                PopupMenuItem(                                    onTap: null,                                    enabled: false,                                    child: singleMenu(                                        text: "Sickness and Lateness",                                        onPressCsv: () {},                                        onPressPdf: () {})),                                PopupMenuItem(                                    onTap: null,                                    enabled: false,                                    child: singleMenu(                                        text: "Holidays, Sickness and Lateness",                                        onPressCsv: () {},                                        onPressPdf: () {})),                                PopupMenuItem(                                    onTap: null,                                    enabled: false,                                    child: singleMenu(                                        text: "User, Location Summary",                                        onPressCsv: () {},                                        onPressPdf: () {})),                              ];                            },                          ))                    ],                  )),              const Divider(height: 0, color: ThemeColors.gray11),            ]));  }  Widget _buildMainBody(BuildContext context, AppState state) {    return TableWrapperWidget(        padding: const EdgeInsets.all(0),        child: SizedBox(          width: double.infinity,          child: SpacedColumn(            mainAxisAlignment: MainAxisAlignment.spaceBetween,            crossAxisAlignment: CrossAxisAlignment.start,            children: [              _body(state),              if (isStateManagerInitialized) _footer(state),            ],          ),        ));  }  Widget _body(AppState state) {    return TimesheetListDepTable(        rows: [],        onSmReady: (p0) {          if (!isStateManagerInitialized) {            stateManager = p0;            stateManager!.addListener(() {              setState(() {});            });            final List<TimesheetDepMd> allTimesheetDepart = [              TimesheetDepMd(                  id: 1,                  staffName: "name",                  scheduledHours: "scheduledHours",                  actualHours: "actualHours",                  overtime: "overtime",                  timeOff: "timeOff",                  lates: "lates",                  cleans: "cleans")            ];            stateManager!.removeAllRows();            stateManager!.appendRows(                allTimesheetDepart.map((e) => _buildRow(e)).toList());          }          stateManager!.setPage(1);          stateManager!.setPageSize(10);        },        cols: columns);  }  Widget _footer(AppState state) {    return Padding(        padding: const EdgeInsets.only(            left: 16.0, right: 32.0, top: 4.0, bottom: 4.0),        child: SpacedRow(            mainAxisAlignment: MainAxisAlignment.spaceBetween,            children: [              SpacedRow(                  horizontalSpace: 8.0,                  crossAxisAlignment: CrossAxisAlignment.center,                  children: [                    KText(                        text: "Showing",                        textColor: ThemeColors.black,                        fontSize: 14.0,                        isSelectable: false),                    ButtonMedium(                      text: "Submit",                      icon: const HeroIcon(HeroIcons.check),                      onPressed: () {},                      bgColor: ThemeColors.blue3,                    ),                  ]),            ]));  }  PlutoRow _buildRow(TimesheetDepMd timesheetDep, {bool checked = false}) {    return PlutoRow(      checked: checked,      cells: {        'date': PlutoCell(value: "Thu, 1st Sep"),        'shift': PlutoCell(value: "Flat 26, 102 Westminster SE1 7XT"),        'actualTime': PlutoCell(value: "08:00 - 16:00"),        'agreedTime': PlutoCell(value: "${timesheetDep.actualHours} Hr"),        'paidHours': PlutoCell(value: "${timesheetDep.actualHours} Hr"),        'agreedHours': PlutoCell(value: "${timesheetDep.actualHours} Hr"),        'actualHours': PlutoCell(value: "${timesheetDep.actualHours} Hr"),        'requests': PlutoCell(value: "Time Off"),        'comments': PlutoCell(value: "View${2}"),        'check': PlutoCell(),      },    );  }  _onColumnItemTap(PlutoColumnRendererContext ctx, BuildContext context) async {    showOverlayPopup(      horizontalPadding: 24.0,      paddingBottom: 24.0,      paddingTop: 24.0,      margin: const EdgeInsets.symmetric(horizontal: 200.0),      body: SpacedColumn(verticalSpace: 16.0, children: [        _header("Actual Time"),        const Divider(height: 1, thickness: 1, color: ThemeColors.gray11),        SizedBox(            width: 448,            child: SpacedColumn(children: [              TextInputWidget(                width: 220,                heigth: 56,                leftIcon: HeroIcons.clock,                hintText: "Clock In",                controller: clockInCntr,                isRequired: true,              ),              TextInputWidget(                width: 220,                heigth: 56,                hintText: "Clock Out",                leftIcon: HeroIcons.clock,                controller: clockOutCntr,                isRequired: true,              )            ])),        const Divider(height: 1, thickness: 1, color: ThemeColors.gray11),        SpacedRow(            crossAxisAlignment: CrossAxisAlignment.center,            mainAxisAlignment: MainAxisAlignment.end,            horizontalSpace: 16.0,            children: [              ButtonMediumSecondary(                  text: "Cancel",                  onPressed: () {                    Navigator.of(context).pop();                  }),              ButtonMedium(                  text: "Submit", bgColor: ThemeColors.blue3, onPressed: () {})            ])      ]),      context: context,    );  }  Widget _header(String title) {    return SpacedRow(      mainAxisAlignment: MainAxisAlignment.spaceBetween,      crossAxisAlignment: CrossAxisAlignment.center,      children: [        KText(          text: title,          fontSize: 18.0,          fontWeight: FWeight.bold,          isSelectable: false,          textColor: ThemeColors.gray2,        ),        IconButton(            onPressed: () {              Navigator.of(context).pop();            },            icon: const HeroIcon(HeroIcons.x,                color: ThemeColors.gray2, size: 20.0)),      ],    );  }  Widget _buildDownloadReportBtn() {    return Container(        padding: const EdgeInsets.symmetric(horizontal: 16.0),        decoration: BoxDecoration(          borderRadius: BorderRadius.circular(12.0),          border: Border.all(color: ThemeColors.blue3, width: 1.0),        ),        child: SpacedRow(            crossAxisAlignment: CrossAxisAlignment.center,            horizontalSpace: 8.0,            children: [              KText(                  text: "Download Reports",                  fontSize: 16,                  isSelectable: false,                  fontWeight: FWeight.bold,                  textColor: ThemeColors.blue3),              const HeroIcon(                HeroIcons.down,                color: ThemeColors.blue3,              )            ]));  }  Widget singleMenu(      {required String text,      required VoidCallback onPressCsv,      required VoidCallback onPressPdf}) {    return SizedBox(        width: 480,        child: SpacedRow(            mainAxisAlignment: MainAxisAlignment.spaceBetween,            crossAxisAlignment: CrossAxisAlignment.center,            children: [              KText(                  text: text,                  fontSize: 14.0,                  textColor: ThemeColors.gray2,                  fontWeight: FWeight.bold,                  isSelectable: false),              SpacedRow(horizontalSpace: 24, children: [                optBtn(text: "CSV", onPressed: onPressCsv),                optBtn(text: "PDF", onPressed: onPressPdf),              ])            ]));  }  Widget optBtn({required String text, required VoidCallback onPressed}) {    return InkWell(        onTap: onPressed,        child: Padding(            padding: const EdgeInsets.symmetric(horizontal: 8.0),            child: SpacedRow(horizontalSpace: 8, children: [              const HeroIcon(HeroIcons.download, color: ThemeColors.blue5),              KText(                text: text,                isSelectable: false,                fontSize: 14.0,                fontWeight: FWeight.bold,                textColor: ThemeColors.blue5,              )            ])));  }}