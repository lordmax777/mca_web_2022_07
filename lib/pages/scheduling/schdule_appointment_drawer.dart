import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../manager/models/shift_md.dart';
import '../../manager/redux/sets/app_state.dart';

import '../../theme/theme.dart';

class AppointmentDrawer extends StatefulWidget {
  final Appointment appointment;
  const AppointmentDrawer({Key? key, required this.appointment})
      : super(key: key);

  @override
  State<AppointmentDrawer> createState() => _AppointmentDrawerState();
}

class _AppointmentDrawerState extends State<AppointmentDrawer>
    with SingleTickerProviderStateMixin {
  AppointmentIdMd get appid => widget.appointment.id as AppointmentIdMd;

  PropertiesMd get props => appid.property;

  UserRes get userRes => appid.user;

  ShiftMd get shift => appid.allocation;

  late final TabController tabController;

  final tabs = const [
    Tab(text: "Location and Property"),
    Tab(text: "Shift Settings"),
    Tab(text: "Additional Settings"),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 640,
        backgroundColor: ThemeColors.white,
        elevation: 0.8,
        child: StoreConnector<AppState, ScheduleState>(
          converter: (store) => store.state.scheduleState,
          builder: (context, state) {
            final isUserView = state.sidebarType == SidebarType.user;
            return SpacedColumn(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    _header(isUserView: isUserView),
                    const Divider(),
                    _body(),
                  ],
                ),
                const Divider(),
                _footer(),
              ],
            );
          },
        ));
  }

  EdgeInsets get _paddingX => const EdgeInsets.symmetric(horizontal: 16);

  EdgeInsets get _paddingH => const EdgeInsets.symmetric(vertical: 16);

  EdgeInsets get _paddingAll => const EdgeInsets.all(24);

  Widget _date() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        KText(
          text: DateFormat('EEEE, MMMM d, y')
              .format(widget.appointment.startTime),
          textColor: ThemeColors.black,
          fontWeight: FWeight.bold,
          fontSize: 18,
        ),
        IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const HeroIcon(
              HeroIcons.x,
              size: 24,
            ))
      ],
    );
  }

  Widget _user({required bool isUserView}) {
    final user = appid.user;
    final location = appid.property;
    return Row(
      children: [
        if (isUserView)
          CircleAvatar(
            backgroundColor: user.userRandomBgColor,
            maxRadius: 24.0,
            child: KText(
              fontSize: 16.0,
              isSelectable: false,
              fontWeight: FWeight.bold,
              text:
                  "${user.firstName.substring(0, 1)}${user.lastName.substring(0, 1)}"
                      .toUpperCase(),
            ),
          )
        else
          const CircleAvatar(
            backgroundColor: ThemeColors.blue7,
            maxRadius: 24.0,
            child: HeroIcon(
              HeroIcons.pin,
              size: 24.0,
              color: ThemeColors.white,
            ),
          ),
        const SizedBox(
          width: 16.0,
        ),
        if (isUserView)
          KText(
            text: user.fullname,
            textColor: ThemeColors.black,
            fontWeight: FWeight.bold,
            fontSize: 18,
          )
        else
          SizedBox(
            width: 200,
            child: KText(
              isSelectable: false,
              maxLines: 2,
              text: "${location.title} - ${location.locationName}",
              fontSize: 14.0,
              textColor: ThemeColors.gray2,
              fontWeight: FWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _header({required bool isUserView}) {
    return Padding(
      padding: _paddingAll,
      child: SpacedColumn(
        verticalSpace: 16,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _date(),
          _user(isUserView: isUserView),
        ],
      ),
    );
  }

  Widget _body() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.73,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TabBar(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory,
                isScrollable: true,
                indicatorWeight: 3.0,
                indicatorColor: ThemeColors.MAIN_COLOR,
                labelColor: ThemeColors.MAIN_COLOR,
                unselectedLabelColor: ThemeColors.black,
                labelStyle: ThemeText.tabTextStyle
                    .copyWith(color: ThemeColors.MAIN_COLOR),
                unselectedLabelStyle: ThemeText.tabTextStyle,
                controller: tabController,
                tabs: tabs),
          ),
          const Divider(
            height: 0.0,
            thickness: 1.0,
          ),
          const SizedBox(
            height: 16.0,
          ),
          _getTabView(),
        ],
      ),
    );
  }

  Widget _getTabView() {
    switch (tabController.index) {
      case 0:
        return Text("Location and Property");
      case 1:
        return Text("Shift Settings");
      case 2:
        return Text("Additional Settings");
      default:
        return Text("Unknown");
    }
  }

  Widget _footer() {
    return Padding(
      padding: _paddingAll,
      child: SpacedRow(horizontalSpace: 16, children: [
        ButtonLarge(text: "Submit", onPressed: () {}),
        if (appid.allocation.published == true)
          ButtonLarge(text: "Unpublish", onPressed: () {})
        else
          ButtonLarge(text: "Publish", onPressed: () {}),
      ]),
    );
  }
}
