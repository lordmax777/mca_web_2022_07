import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/auth_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
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
  UserDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) async {
          await fetch(GetUserDetailsDetailAction());
          await fetch(GetUserDetailsContractsAction());
          await fetch(GetUserDetailsReviewsAction());
        },
        builder: (context, state) {
          final e1 = state.usersState.userDetails.error;
          final e2 = state.usersState.userDetailContracts.error;
          final e3 = state.usersState.userDetailReviews.error;
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
            errors: [e1, e2, e3],
            child: PageWrapper(
                child: SpacedColumn(
              verticalSpace: 16.0,
              children: [
                PageGobackWidget(text: userDetails.nameWithUsername),
                _UserDetailsQuickViewWidget(userDetails: userDetails),
                const _Body(),
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

  void _onSendMsg() {
    print('Send Message');
  }
}

class _Body extends StatefulWidget {
  const _Body({Key? key}) : super(key: key);

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

  final List<Widget> _generalItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _addGeneralTabItems();
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
          _getTabChild(),
        ],
      ),
    );
  }

  void _addGeneralTabItems() {
    _generalItems.add(_buildExpanableItem(
        const PersonalDetailsWidget(), PersonalDetailsWidget.title));
    _generalItems.add(_buildExpanableItem(const UsernameAndPayrollInfoWidget(),
        UsernameAndPayrollInfoWidget.title));
    _generalItems.add(_buildExpanableItem(
        const RolesDepsAndLoginOptionsWidget(),
        RolesDepsAndLoginOptionsWidget.title));
    _generalItems
        .add(_buildExpanableItem(const AddressWidget(), AddressWidget.title));
    _generalItems.add(_buildExpanableItem(
        const EthnicAndReligionWidget(), EthnicAndReligionWidget.title));
    _generalItems.add(_buildExpanableItem(
        const NextOfKinInfoWidget(), NextOfKinInfoWidget.title));
  }

  Widget _getTabChild() {
    switch (_tabController.index) {
      case 0:
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(
              color: ThemeColors.gray11, height: 1.0, thickness: 1.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _generalItems.length + 1,
          itemBuilder: (context, index) {
            if (index == _generalItems.length) {
              return const SaveAndCancelButtonsWidget();
            }
            return _generalItems[index];
          },
        );
      case 1:
        return PayrollWidget(state: appStore.state);
      case 2:
        return ReviewsWidget(state: appStore.state);
      default:
        return const SizedBox();
    }
  }

  Widget _buildExpanableItem(Widget child, String title) {
    bool a = true;
    return StatefulBuilder(
      builder: (context, ss) {
        return ExpansionTile(
          childrenPadding:
              const EdgeInsets.only(left: 48.0, bottom: 48.0, top: 24.0),
          tilePadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 18.0),
          trailing: const SizedBox(),
          onExpansionChanged: (value) {
            ss(() {
              a = !value;
            });
          },
          // childrenPadding: EdgeInsets.symmetric(vertical: 16.0),
          leading: HeroIcon(!a ? HeroIcons.up : HeroIcons.down, size: 18.0),
          title: KText(
            text: title,
            isSelectable: false,
            fontWeight: FWeight.bold,
            fontSize: 16.0,
            textColor: !a ? ThemeColors.blue6 : ThemeColors.gray2,
          ),
          expandedAlignment: Alignment.topLeft,
          children: [child],
        );
      },
    );
  }
}
