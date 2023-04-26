import 'package:flutter_redux/flutter_redux.dart';import 'package:mca_web_2022_07/pages/approvals/request_body.dart';import 'package:mca_web_2022_07/pages/approvals/shift_release_body.dart';import 'package:mca_web_2022_07/pages/approvals/user_qualification_body.dart';import '../../manager/redux/sets/app_state.dart';import '../../theme/theme.dart';class ApprovalTemplatePage extends StatefulWidget {  const ApprovalTemplatePage({Key? key}) : super(key: key);  @override  State<ApprovalTemplatePage> createState() => _ApprovalTemplatePageState();}class _ApprovalTemplatePageState extends State<ApprovalTemplatePage> {  List<String> approvalMenus = [    "Requests",    "User Qualifications",    "Shift Release"  ];  String? settingState;  List<int> notificationCounts = [0, 0, 0];  @override  void initState() {    super.initState();    settingState = approvalMenus[0];  }  @override  Widget build(BuildContext context) {    return StoreConnector<AppState, AppState>(        converter: (store) => store.state,        builder: (_, state) => PageWrapper(              child: SpacedColumn(verticalSpace: 16.0, children: [                const PagesTitleWidget(title: 'Approvals'),                ErrorWrapper(                    errors: [state.generalState.paramList.error],                    child: bodyWidget(context))              ]),            ));  }  Widget bodyWidget(BuildContext context) {    double fullScreen = MediaQuery.of(context).size.width;    return TableWrapperWidget(        child: SpacedRow(            crossAxisAlignment: CrossAxisAlignment.center,            mainAxisAlignment: MainAxisAlignment.center,            children: [          SizedBox(            width: 240,            child: SpacedRow(                mainAxisAlignment: MainAxisAlignment.spaceBetween,                children: [                  sideBarWidget(context),                  Container(width: 1, height: 850, color: ThemeColors.gray11)                ]),          ),          SizedBox(              width: fullScreen - 350,              child: SpacedColumn(                  crossAxisAlignment: CrossAxisAlignment.center,                  mainAxisAlignment: MainAxisAlignment.center,                  verticalSpace: 16.0,                  children: [                    _body(context),                  ]))        ]));  }  Widget sideBarWidget(BuildContext context) {    List<Widget> settingsMenuWidgets = [];    settingsMenuWidgets.add(Padding(        padding: const EdgeInsets.only(top: 16.0),        child: ButtonLarge(            text: "New Request",            bgColor: ThemeColors.blue3,            icon: const HeroIcon(HeroIcons.add, size: 20),            onPressed: () {})));    for (int i = 0; i < approvalMenus.length; i++) {      settingsMenuWidgets.add(Material(          color: Colors.transparent,          child: InkWell(              onTap: () {                setState(() {                  settingState = approvalMenus[i];                  logger("settingState: $settingState");                });              },              child: Container(                  width: 200,                  height: 48,                  color: settingState == approvalMenus[i]                      ? ThemeColors.blue12                      : Colors.transparent,                  alignment: Alignment.centerLeft,                  child: Padding(                      padding: const EdgeInsets.only(left: 16.0),                      child: KText(                          isSelectable: false,                          text:                              "${approvalMenus[i]} (${notificationCounts[i]})",                          fontSize: 16.0,                          textColor: settingState == approvalMenus[i]                              ? ThemeColors.blue3                              : ThemeColors.black))))));    }    return SpacedColumn(        crossAxisAlignment: CrossAxisAlignment.start,        mainAxisAlignment: MainAxisAlignment.start,        verticalSpace: 16.0,        children: settingsMenuWidgets);  }  Widget _body(BuildContext context) {    String settingState = this.settingState ?? "";    if (settingState.toLowerCase().contains("requests")) {      return _requestBody(context);    } else if (settingState.toLowerCase().contains("user")) {      return _userQualificationBody(context);    } else {      return _shiftReleaseBody(context);    }  }  Widget _requestBody(BuildContext context) {    return SpacedColumn(        verticalSpace: 16.0, children: [RequestBodyWithTab(tabIndex: 0)]);  }  Widget _userQualificationBody(BuildContext context) {    return SpacedColumn(        verticalSpace: 16.0, children: const [UserQualificationBody()]);  }  Widget _shiftReleaseBody(BuildContext context) {    return SpacedColumn(        verticalSpace: 16.0, children: [ShiftReleaseBodyWithTab(tabIndex: 0)]);  }}