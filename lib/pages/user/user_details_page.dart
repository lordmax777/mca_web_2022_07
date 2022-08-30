import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/auth_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state.dart';

import '../../theme/theme.dart';

class _UserDetails {
  String name;
  String email;
  String phone;
  String id;
  String nameWithUsername;

  _UserDetails(
      {required this.name,
      required this.email,
      required this.phone,
      required this.nameWithUsername,
      required this.id});
}

class UserDetailsPage extends StatelessWidget {
  final int? tabIndex;
  const UserDetailsPage({Key? key, this.tabIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) async {
          await Future.wait([
            fetch(GetUserDetailsDetailAction()),
            fetch(GetUserDetailsContractsAction()),
            fetch(GetUserDetailsReviewsAction()),
            fetch(GetUserDetailsVisasAction()),
            fetch(GetUserDetailsPreferredShiftsAction()),
            fetch(GetUserDetailsQualifsAction()),
            fetch(GetUserDetailsStatusAction()),
            fetch(GetUserDetailsMobileAction()),
          ]);
        },
        builder: (context, state) {
          final e1 = state.usersState.userDetails.error;
          final e2 = state.usersState.userDetailContracts.error;
          final e3 = state.usersState.userDetailReviews.error;
          final e4 = state.usersState.userDetailVisas.error;
          final e5 = state.usersState.userDetailQualifs.error;
          final e6 = state.usersState.userDetailStatus.error;
          final e7 = state.usersState.userDetailMobileIsRegistered.error;
          final e8 = state.usersState.userDetailPreferredShift.error;
          final List<ErrorModel> errors = [e1, e2, e3, e4, e5, e6, e7, e8];

          final user = state.usersState.userDetails.data;

          final _UserDetails userDetails = _UserDetails(
              name: '-',
              email: '-',
              phone: '-',
              id: '-',
              nameWithUsername: "-");

          if (user != null) {
            userDetails.nameWithUsername =
                "${user.first_name} ${user.last_name} (${state.usersState.selectedUser?.username ?? "-"})";
            userDetails.name = "${user.first_name} ${user.last_name}";
            userDetails.id = state.usersState.selectedUser!.id.toString();
            userDetails.phone =
                user.phones.mobile.isEmpty ? "-" : user.phones.mobile;
            userDetails.email = "-";
          }
          return ErrorWrapper(
            errors: errors,
            child: PageWrapper(
                child: SpacedColumn(
              verticalSpace: 16.0,
              children: [
                PageGobackWidget(text: userDetails.nameWithUsername),
                _UserDetailsQuickViewWidget(userDetails: userDetails),
                _Body(tabIndex: tabIndex),
              ],
            )),
          );
        });
  }
}

class _UserDetailsQuickViewWidget extends StatelessWidget {
  final _UserDetails userDetails;
  const _UserDetailsQuickViewWidget({Key? key, required this.userDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableWrapperWidget(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SpacedRow(horizontalSpace: 64.0, children: [
              _buildIconItem(
                icon: HeroIcons.user,
                title: "Name",
                subtitle: userDetails.name,
              ),
              _buildIconItem(
                icon: HeroIcons.phone,
                title: "Phone Number",
                subtitle: userDetails.phone,
              ),
              _buildIconItem(
                icon: HeroIcons.envelope,
                title: "Email",
                subtitle: userDetails.email,
              ),
            ]),
            ButtonMediumSecondary(
              leftIcon: const HeroIcon(HeroIcons.send,
                  size: 20.0, color: ThemeColors.blue3),
              text: "Direct Message",
              onPressed: _onSendMsg,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconItem(
      {required HeroIcons icon,
      required String title,
      required String subtitle}) {
    return SpacedRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        horizontalSpace: 16.0,
        children: [
          HeroIcon(icon, size: 32.0, color: ThemeColors.blue3),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              KText(
                text: title,
                isSelectable: false,
                textColor: ThemeColors.black,
                fontWeight: FWeight.bold,
                fontSize: 14.0,
              ),
              KText(
                text: subtitle,
                isSelectable: false,
                textColor: ThemeColors.black,
                fontWeight: FWeight.regular,
                fontSize: 14.0,
              ),
            ],
          )
        ]);
  }

  void _onSendMsg() async {
    print('Send Message');
  }
}

class _Body extends StatefulWidget {
  final int? tabIndex;
  _Body({Key? key, this.tabIndex}) : super(key: key) {
    tabIndex ?? 0;
  }

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  final List<Tab> tabs = const [
    Tab(text: 'General'),
    Tab(text: 'Payroll'),
    Tab(text: 'Reviews'),
    Tab(text: 'Visa, Work Permits'),
    Tab(text: 'Preferred Shifts'),
    Tab(text: 'Qualifications'),
    Tab(text: 'Mobile and Status'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.animateTo(widget.tabIndex!);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TableWrapperWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: TabBar(
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              controller: _tabController,
              splashFactory: NoSplash.splashFactory,
              isScrollable: true,
              indicatorWeight: 3.0,
              indicatorColor: ThemeColors.blue3,
              labelColor: ThemeColors.blue3,
              unselectedLabelColor: ThemeColors.black,
              labelStyle:
                  ThemeText.tabTextStyle.copyWith(color: ThemeColors.blue3),
              unselectedLabelStyle: ThemeText.tabTextStyle,
              tabs: tabs,
            ),
          ),
          const Divider(height: 0, color: ThemeColors.gray11),
          _getTabChild(),
        ],
      ),
    );
  }

  Widget _getTabChild() {
    switch (_tabController.index) {
      case 0:
        return const GeneralWidget();
      case 1:
        return PayrollWidget(state: appStore.state);
      case 2:
        return ReviewsWidget(state: appStore.state);
      case 3:
        return VisaWidget(state: appStore.state);
      case 4:
        return const PrefferedShiftsWidget();
      case 5:
        return QaulifsWidget(state: appStore.state);
      case 6:
        return MobileStatusWidget(state: appStore.state);
      default:
        return const SizedBox();
    }
  }
}
