import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/states/schedule_state.dart';
import 'package:mca_web_2022_07/pages/scheduling/drawer_tabs/location.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class CustomProperty {
  final int userId;
  final int propertyId;

  // toJson
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'propertyId': propertyId,
      };

  CustomProperty({required this.userId, required this.propertyId});
}

class AppointmentDrawer extends StatefulWidget {
  final Appointment appointment;
  final AppState state;
  const AppointmentDrawer(
      {Key? key, required this.appointment, required this.state})
      : super(key: key);

  @override
  State<AppointmentDrawer> createState() => _AppointmentDrawerState();
}

class _AppointmentDrawerState extends State<AppointmentDrawer>
    with SingleTickerProviderStateMixin {
  bool get isAppSelected => appid != null;

  Appointment get appointment => widget.appointment;

  DateTime get startTime => appointment.startTime;

  get resource => appointment.resourceIds;

  AppointmentIdMd? get appid {
    final id = appointment.id;
    if (id is! int) {
      return id as AppointmentIdMd?;
    }
    return null;
  }

  ScheduleState get state => widget.state.scheduleState;

  late final TabController tabController;

  final tabs = [
    Tab(text: "Location and Property"),
    const Tab(text: "Shift Settings"),
    const Tab(text: "Additional Settings"),
  ];

  bool get isUserView => state.sidebarType == SidebarType.user;

  final List<UserRes> allUsers = [];
  final List<PropertiesMd> allProperties = [];

  EdgeInsets get _paddingAll => const EdgeInsets.all(24);

  final List<CustomProperty> selectedProperties = [];

  void selectProperty(int propertyId) {
    final int = selectedProperties
        .indexWhere((element) => element.propertyId == propertyId);
    if (int == -1) {
      selectedProperties.add(CustomProperty(userId: 0, propertyId: propertyId));
    } else {
      selectedProperties.removeAt(int);
    }
  }

  void selectUser(int userId) {
    final int =
        selectedProperties.indexWhere((element) => element.userId == userId);
    if (int == -1) {
      selectedProperties.add(CustomProperty(userId: userId, propertyId: 0));
    } else {
      selectedProperties.removeAt(int);
    }
  }

  @override
  void initState() {
    super.initState();
    allUsers.addAll(widget.state.usersState.usersList.data ?? []);
    allProperties.addAll(widget.state.generalState.properties.data ?? []);
    if (isAppSelected) {
      final shifts = appid!.allocation;
      selectedProperties.add(
          CustomProperty(userId: shifts.userId!, propertyId: shifts.shiftId));
      if (!isUserView) {
        tabs.first = const Tab(text: "Users");
      }
    }
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 540,
        backgroundColor: ThemeColors.white,
        elevation: 0.8,
        child: SpacedColumn(
          children: [
            Column(
              children: [
                _header(),
                if (isAppSelected) const Divider(),
                if (isAppSelected) _body(),
              ],
            ),
            const Divider(),
            if (isAppSelected) _footer(),
          ],
        ));
  }

  Widget _date() {
    final date = DateFormat('EEEE, MMMM d, y').format(startTime);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        KText(
          text: date,
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

  Widget _userOrProperty() {
    if (isUserView) {
      final userRes = (resource.first) as UserRes;
      String text =
          "${userRes.firstName.substring(0, 1)}${userRes.lastName.substring(0, 1)}"
              .toUpperCase();
      return Row(
        children: [
          CircleAvatar(
            backgroundColor: userRes.userRandomBgColor,
            maxRadius: 24.0,
            child: KText(
              fontSize: 16.0,
              isSelectable: false,
              fontWeight: FWeight.bold,
              text: text,
            ),
          ),
          const SizedBox(
            width: 16.0,
          ),
          KText(
            text: userRes.fullname,
            textColor: ThemeColors.black,
            fontWeight: FWeight.bold,
            fontSize: 18,
          )
        ],
      );
    }
    final props = (resource[1]) as PropertiesMd;
    final locName = "${props.title} - ${props.locationName}";

    return Row(
      children: [
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
        SizedBox(
          width: 200,
          child: KText(
            isSelectable: false,
            maxLines: 2,
            text: locName,
            fontSize: 14.0,
            textColor: ThemeColors.gray2,
            fontWeight: FWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Padding(
      padding: _paddingAll,
      child: SpacedColumn(
        verticalSpace: 16,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _date(),
          _userOrProperty(),
        ],
      ),
    );
  }

  Widget _body() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * (0.73),
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
        return ScheduleLocationTab(
          state: widget.state,
          isAppSelected: isAppSelected,
          allProperties: allProperties,
          onPropertySelected: selectProperty,
          allUsers: allUsers,
          onUserSelected: selectUser,
          selectedProperties: selectedProperties,
        );
      // case 1:
      //   return ScheduleShiftSettingsTab(
      //     selectedProperties: selectedProperties,
      //     state: widget.state,
      //   );
      case 2:
        return Text("Additional Settings");
      default:
        return Text("Unknown");
    }
  }

  Widget _footer() {
    return SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 16,
        children: [
          ButtonLarge(text: "Submit", onPressed: () {}),
          if (appid != null)
            if (appid!.allocation.published == true)
              ButtonLarge(text: "Unpublish", onPressed: () {})
            else
              ButtonLarge(text: "Publish", onPressed: () {}),
        ]);
  }
}
