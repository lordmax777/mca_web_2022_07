import 'package:get/get.dart';import 'package:get/get_core/src/get_main.dart';import '../../theme/theme.dart';import '../properties/controllers/properties_controller.dart';class ShiftReleaseBodyWithTab extends StatefulWidget {  final int? tabIndex;  ShiftReleaseBodyWithTab({Key? key, this.tabIndex}) : super(key: key) {    tabIndex ?? 0;  }  @override  State<ShiftReleaseBodyWithTab> createState() =>      _ShiftReleaseBodyWithTabState();}class _ShiftReleaseBodyWithTabState extends State<ShiftReleaseBodyWithTab>    with SingleTickerProviderStateMixin {  late final TabController _tabController;  final List<Tab> tabs = const [    Tab(text: 'Pending'),    Tab(text: 'Published'),  ];  PropertiesController get _controller => Get.find();  int pendingCount = 5;  int publishedCount = 3;  @override  void initState() {    super.initState();    _tabController = TabController(length: tabs.length, vsync: this);    if (widget.tabIndex != null) {      _tabController.animateTo(widget.tabIndex!);    }    _tabController.addListener(() {      setState(() {});    });  }  @override  Widget build(BuildContext context) {    return Column(      crossAxisAlignment: CrossAxisAlignment.start,      children: [        SizedBox(          width: double.infinity,          child: TabBar(            overlayColor: MaterialStateProperty.all(Colors.transparent),            controller: _tabController,            splashFactory: NoSplash.splashFactory,            isScrollable: true,            indicatorWeight: 3.0,            indicatorColor: ThemeColors.MAIN_COLOR,            labelColor: ThemeColors.MAIN_COLOR,            unselectedLabelColor: ThemeColors.black,            labelStyle:                ThemeText.tabTextStyle.copyWith(color: ThemeColors.MAIN_COLOR),            unselectedLabelStyle: ThemeText.tabTextStyle,            tabs: tabs,          ),        ),        const Divider(height: 0, color: ThemeColors.gray11),        _getTabChild(),      ],    );  }  Widget _getTabChild() {    switch (_tabController.index) {      case 0:        return pending();      case 1:        return published();      default:        return const SizedBox();    }  } ///////////////////////////////////////////////////// //////////////////////// Pending   ////////////////// /////////////////////////////////////////////////////  Widget pending() {    double dpWidth = 150;    double inputWidth = 344;    return SpacedColumn(children: [      SizedBox(          height: 720,          width: double.infinity,          child: SpacedColumn(              crossAxisAlignment: CrossAxisAlignment.center,              mainAxisAlignment: MainAxisAlignment.center,              verticalSpace: 8.0,              children: [                Padding(                    padding: const EdgeInsets.symmetric(                        horizontal: 16.0, vertical: 8.0),                    child: SpacedRow(                        crossAxisAlignment: CrossAxisAlignment.center,                        mainAxisAlignment: MainAxisAlignment.spaceBetween,                        children: [                          TextInputWidget(                            width: inputWidth,                            heigth: 48,                            leftIcon: HeroIcons.search,                            hintText: 'Search ...',                            controller: TextEditingController(),                          ),                          SizedBox(                            height: 48,                            child: DropdownWidget(                                hintText: "Action",                                dropdownBtnWidth: dpWidth,                                dropdownOptionsWidth: dpWidth,                                onChanged: (val) {},                                items: const [                                  "Basic",                                  "Premium",                                  "Enterprise"                                ]),                          )                        ])),                const Divider(height: 0, color: ThemeColors.gray11),                _pendingBody(context),              ])),      const Divider(height: 0, color: ThemeColors.gray11),      _footerPending(_controller)    ]);  }  Widget _pendingBody(BuildContext context) {    List<Widget> list = [];    for (int i = 0; i < pendingCount; i++) {      list.add(singleReqDetail(        requestBy: "John Doe",        requestDateTime: "12/12/2021 12:00 PM",        shiftLoc: "Shift 1",        dateTime: "12/12/2021 12:00 PM",        onPublish: () {},        onRelease: () {},        onDecline: () {},      ));      list.add(const Divider(height: 0, color: ThemeColors.gray11));    }    return SizedBox(        height: 630,        child: SingleChildScrollView(            child: Column(          children: list,        )));  }  Widget _footerPending(PropertiesController c) {    return Padding(      padding: const EdgeInsets.only(          left: 16.0, right: 32.0, top: 4.0, bottom: 14.0),      child: SpacedRow(          mainAxisAlignment: MainAxisAlignment.spaceBetween,          children: [            SpacedRow(                horizontalSpace: 8.0,                crossAxisAlignment: CrossAxisAlignment.center,                children: [                  KText(                      text: "Showing",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                  DropdownWidget(                    hintText: "Entries",                    items: Constants.tablePageSizes                        .map<String>((e) => e.toString())                        .toList(),                    dropdownBtnWidth: 120,                    onChanged: c.onPageSizeChange,                    value: c.gridStateManager.pageSize.toString(),                  ), // MyWidget(),                  KText(                      text: "of ${c.departments.length} entries",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                ]),            TablePaginationWidget(                currentPage: c.gridStateManager.page,                totalPages: c.gridStateManager                    .totalPage, //(widget._itemCount / _pageSize).ceil(),                onPageChanged: c.onPageChange),          ]),    );  } ///////////////////////////////////////////////////// //////////////////////// PUBLISHED ////////////////// /////////////////////////////////////////////////////  Widget published() {    double dpWidth = 150;    double inputWidth = 344;    return SpacedColumn(children: [      SizedBox(          height: 720,          width: double.infinity,          child: SpacedColumn(              crossAxisAlignment: CrossAxisAlignment.center,              mainAxisAlignment: MainAxisAlignment.center,              verticalSpace: 8.0,              children: [                Padding(                    padding: const EdgeInsets.symmetric(                        horizontal: 16.0, vertical: 8.0),                    child: SpacedRow(                        crossAxisAlignment: CrossAxisAlignment.center,                        mainAxisAlignment: MainAxisAlignment.spaceBetween,                        children: [                          TextInputWidget(                            width: inputWidth,                            heigth: 48,                            leftIcon: HeroIcons.search,                            hintText: 'Search ...',                            controller: TextEditingController(),                          ),                          SizedBox(                            height: 48,                            child: DropdownWidget(                                hintText: "Action",                                dropdownBtnWidth: dpWidth,                                dropdownOptionsWidth: dpWidth,                                onChanged: (val) {},                                items: const [                                  "Basic",                                  "Premium",                                  "Enterprise"                                ]),                          )                        ])),                const Divider(height: 0, color: ThemeColors.gray11),                _publishedBody(context),              ])),      const Divider(height: 0, color: ThemeColors.gray11),      _footerPublished(_controller)    ]);  }  Widget _publishedBody(BuildContext context) {    List<Widget> list = [];    for (int i = 0; i < publishedCount; i++) {      list.add(singleReqDetail(        requestBy: "John Doe",        requestDateTime: "12/12/2021 12:00 PM",        shiftLoc: "Shift 1",        dateTime: "12/12/2021 12:00 PM",        onUnpublish: () {},        onViewList: () {},        onRelease: () {},        onDecline: () {},      ));      list.add(const Divider(height: 0, color: ThemeColors.gray11));    }    return SizedBox(        height: 630,        child: SingleChildScrollView(            child: Column(          children: list,        )));  }  Widget _footerPublished(PropertiesController c) {    return Padding(      padding: const EdgeInsets.only(          left: 16.0, right: 32.0, top: 4.0, bottom: 14.0),      child: SpacedRow(          mainAxisAlignment: MainAxisAlignment.spaceBetween,          children: [            SpacedRow(                horizontalSpace: 8.0,                crossAxisAlignment: CrossAxisAlignment.center,                children: [                  KText(                      text: "Showing",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                  DropdownWidget(                    hintText: "Entries",                    items: Constants.tablePageSizes                        .map<String>((e) => e.toString())                        .toList(),                    dropdownBtnWidth: 120,                    onChanged: c.onPageSizeChange,                    value: c.gridStateManager.pageSize.toString(),                  ), // MyWidget(),                  KText(                      text: "of ${c.departments.length} entries",                      textColor: ThemeColors.black,                      fontSize: 14.0,                      isSelectable: false),                ]),            TablePaginationWidget(                currentPage: c.gridStateManager.page,                totalPages: c.gridStateManager                    .totalPage, //(widget._itemCount / _pageSize).ceil(),                onPageChanged: c.onPageChange),          ]),    );  } ///////////////////////////////////////////////////// ///////////////////////////////////////////////////// /////////////////////////////////////////////////////  Widget singleReqDetail({    String? requestBy,    String? requestDateTime,    String? shiftLoc,    String? dateTime,    VoidCallback? onPublish,    VoidCallback? onRelease,    VoidCallback? onDecline,    VoidCallback? onUnpublish,    VoidCallback? onViewList,  }) {    return Padding(        padding: const EdgeInsets.all(24),        child: SpacedRow(children: [          Align(            alignment: Alignment.topLeft,            child: CustomCheckboxWidget(                isChecked: false,                onChanged: (val) {},                labelPosition: CheckboxLabelPosition.left),          ),          const SizedBox(width: 24),          SpacedColumn(verticalSpace: 16, children: [            textHelper("Requested By:", requestBy ?? "-"),            textHelper("Requested On:", requestDateTime ?? "-"),            textHelper("Shift:", shiftLoc ?? "-"),            textHelper("Date and Time", dateTime ?? "-")          ]),          const Spacer(),          TextInputWidget(              width: 344,              heigth: 112,              hintText: 'Comment',              maxLines: 5,              controller: TextEditingController()),          const SizedBox(width: 32),          SpacedColumn(verticalSpace: 8.0, children: [            if (onViewList != null)              ButtonSmall(                  text: "View List",                  bgColor: ThemeColors.blue3,                  textStyle: ThemeText.regular.copyWith(                      color: ThemeColors.white, fontWeight: FontWeight.w700),                  icon: const HeroIcon(HeroIcons.eye),                  onPressed: onViewList),            if (onUnpublish != null)              ButtonSmall(                text: "Unpublish",                bgColor: ThemeColors.white,                icon: const HeroIcon(                  HeroIcons.arrowDown,                  color: ThemeColors.blue3,                ),                onPressed: onUnpublish,                textStyle: ThemeText.regular.copyWith(color: ThemeColors.blue3),              )            else              ButtonSmall(                text: "Publish",                bgColor: ThemeColors.blue3,                icon: const HeroIcon(HeroIcons.arrowUp),                onPressed: onPublish ?? () {},                textStyle: ThemeText.regular.copyWith(color: ThemeColors.white),              ),            ButtonSmall(                text: "Release",                bgColor: ThemeColors.green2,                textStyle: ThemeText.regular.copyWith(                    color: ThemeColors.white, fontWeight: FontWeight.w700),                icon: const HeroIcon(HeroIcons.tickCircle),                onPressed: onRelease ?? () {}),            ButtonSmall(                text: "Decline",                bgColor: ThemeColors.red3,                textStyle: ThemeText.regular.copyWith(                    color: ThemeColors.white, fontWeight: FontWeight.w700),                icon: const HeroIcon(HeroIcons.xCircle),                onPressed: onDecline ?? () {})          ])        ]));  }  Widget textHelper(String leftText, String rightText) {    return SpacedRow(children: [      SizedBox(        width: 150,        child: KText(            text: leftText,            textAlign: TextAlign.start,            fontWeight: FWeight.bold,            textColor: ThemeColors.gray2,            fontSize: 14.0),      ),      SizedBox(        width: 300,        child: KText(            text: rightText,            fontWeight: FWeight.regular,            textAlign: TextAlign.start,            textColor: ThemeColors.gray2,            fontSize: 14.0),      ),    ]);  }}