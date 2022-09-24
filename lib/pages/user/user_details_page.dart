import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/auth_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';

import '../../theme/theme.dart';

class UserDetailsPage extends StatelessWidget {
  final int? tabIndex;
  const UserDetailsPage({Key? key, this.tabIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) async {
          if (!store.state.usersState.isNewUser) {
            await Future.wait([
              fetch(GetUserDetailsDetailAction()),
              fetch(GetUserDetailsPhotosAction()),
              fetch(GetUserDetailsContractsAction()),
              fetch(GetUserDetailsReviewsAction()),
              fetch(GetUserDetailsVisasAction()),
              fetch(GetUserDetailsPreferredShiftsAction()),
              fetch(GetUserDetailsQualifsAction()),
              fetch(GetUserDetailsStatusAction()),
              fetch(GetUserDetailsMobileAction()),
            ]);
          }
        },
        builder: (context, state) {
          final bool isNewUser = state.usersState.isNewUser;
          final e1 = state.generalState.paramList.error;
          final e2 = state.usersState.userDetailContracts.error;
          final e3 = state.usersState.userDetailReviews.error;
          final e4 = state.usersState.userDetailVisas.error;
          final e5 = state.usersState.userDetailQualifs.error;
          final e6 = state.usersState.userDetailStatus.error;
          final e7 = state.usersState.userDetailMobileIsRegistered.error;
          final e8 = state.usersState.userDetailPreferredShift.error;
          final e9 = state.usersState.userDetailPhotos.error;
          final List<ErrorModel> errors = [e2, e3, e4, e5, e6, e7, e8, e9];
          if (isNewUser) {
            errors.clear();
          }

          return ErrorWrapper(
            errors: [e1],
            child: PageWrapper(
                child: SpacedColumn(
              verticalSpace: 16.0,
              children: [
                const PageGobackWidget(),
                if (!isNewUser) const _UserDetailsQuickViewWidget(),
                _Body(tabIndex: tabIndex),
              ],
            )),
          );
        });
  }
}

class _UserDetailsQuickViewWidget extends StatelessWidget {
  const _UserDetailsQuickViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final user = state.usersState.selectedUser;
          final userDetail = state.usersState.userDetails.data;
          return TableWrapperWidget(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SpacedRow(horizontalSpace: 64.0, children: [
                    _buildIconItem(
                      icon: HeroIcons.user,
                      title: "Name",
                      subtitle: user != null
                          ? "${user.firstName} ${user.lastName}"
                          : "-",
                    ),
                    _buildIconItem(
                      icon: HeroIcons.phone,
                      title: "Phone Number",
                      subtitle: (userDetail?.phones.mobile) ?? "-",
                    ),
                    _buildIconItem(
                      icon: HeroIcons.envelope,
                      title: "Email",
                      subtitle: userDetail != null
                          ? (userDetail.email != null ? userDetail.email! : "-")
                          : "-",
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
        });
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

  final List<Tab> tabs = [
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
    if (appStore.state.usersState.isNewUser) {
      tabs.removeRange(1, tabs.length);
    }
    _tabController = TabController(length: tabs.length, vsync: this);
    if (widget.tabIndex != null) {
      _tabController.animateTo(widget.tabIndex!);
    }
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
        return PayrollWidget();
      case 2:
        return ReviewsWidget();
      case 3:
        return VisaWidget();
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
