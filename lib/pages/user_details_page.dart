import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';

import '../theme/theme.dart';

class _UserDetails {
  final String name;
  final String email;
  final String phone;
  final String id;

  _UserDetails(
      {required this.name,
      required this.email,
      required this.phone,
      required this.id});
}

class UserDetailsPage extends StatelessWidget {
  UserDetailsPage({Key? key}) : super(key: key);

  final _UserDetails _userDetails = _UserDetails(
      name: 'John Doe',
      email: 'dummy@mail.com',
      phone: '+1-555-555-5555',
      id: "no_id_yet");

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          print(state.usersState.selectedUser?.toJson());
          return PageWrapper(
              child: SpacedColumn(
            verticalSpace: 16.0,
            children: [
              PageGobackWidget(text: _userDetails.name),
              _UserDetailsQuickViewWidget(userDetails: _userDetails),
              const _Body(),
            ],
          ));
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
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
          Container(
            width: 100,
            height: 100,
            color: Colors.red,
            child: Text(tabs[_tabController.index].text.toString()),
          )
        ],
      ),
    );
  }
}
