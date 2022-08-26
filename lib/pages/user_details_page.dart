import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state.dart';

import '../theme/theme.dart';

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
          await appStore.dispatch(GetUserDetailsAction());
        },
        builder: (context, state) {
          final e1 = state.errorState.userDetailsError;
          final user = state.usersState.userDetails;

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
            errors: [e1],
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
    Tab(text: 'General', key: Key('general_tab')),
    Tab(text: 'Payroll', key: Key('payroll_tab')),
    Tab(text: 'Reviews', key: Key('reviews_tab')),
    Tab(text: 'Visa, Work Permits', key: Key('visa_tab')),
    Tab(text: 'Preferred Shifts', key: Key('preferred_shifts_tab')),
    Tab(text: 'Qualifications', key: Key('qualifications_tab')),
    Tab(text: 'Mobile and Status', key: Key('mobile_status_tab')),
  ];

  final List<Widget> _generalItems = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    _generalItems.add(_buildItem(
        const _PersonalDetailsWidget(), _PersonalDetailsWidget.title));
    _generalItems.add(_buildItem(const _UsernameAndPayrollInfoWidget(),
        _UsernameAndPayrollInfoWidget.title));
    _generalItems.add(_buildItem(const _RolesDepsAndLoginOptionsWidget(),
        _RolesDepsAndLoginOptionsWidget.title));
    _generalItems.add(_buildItem(const _AddressWidget(), _AddressWidget.title));
    _generalItems.add(_buildItem(
        const _EthnicAndReligionWidget(), _EthnicAndReligionWidget.title));
    _generalItems.add(
        _buildItem(const _NextOfKinInfoWidget(), _NextOfKinInfoWidget.title));
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
          const Divider(color: ThemeColors.gray11, thickness: 1.0),
          const _SaveAndCancelButtonsWidget(),
        ],
      ),
    );
  }

  Widget _getTabChild() {
    switch (_tabController.index) {
      case 0:
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(
              color: ThemeColors.gray11, height: 1.0, thickness: 1.0),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _generalItems.length,
          itemBuilder: (context, index) {
            return _generalItems[index];
          },
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildItem(Widget child, String title) {
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

class _PersonalDetailsWidget extends StatelessWidget {
  static const String title = "Personal Details";

  const _PersonalDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return SpacedRow(horizontalSpace: 64.0, children: [
      SpacedColumn(verticalSpace: 16.0, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.deepPurple,
          ),
        ),
        SpacedRow(
          horizontalSpace: 8.0,
          children: [
            ButtonSmallSecondary(
              leftIcon: const HeroIcon(HeroIcons.upload,
                  size: 20.0, color: ThemeColors.blue3),
              text: "Upload Photo",
              onPressed: () {},
            ),
            ButtonSmallSecondary(
              leftIcon: const HeroIcon(HeroIcons.bin,
                  size: 20.0, color: ThemeColors.red3),
              text: "",
              onPressed: () {},
            ),
          ],
        ),
      ]),
      SpacedColumn(
          verticalSpace: 32.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownWidget(
              hintText: "Title",
              value: "Mr",
              dropdownBtnWidth: dpWidth,
              dropdownOptionsWidth: dpWidth,
              onChanged: (_) {},
              items: Constants.userTitleTypes.values.toList(),
            ),
            TextInputWidget(
              width: dpWidth,
              labelText: "First Name",
              isRequired: true,
            ),
            TextInputWidget(
              width: dpWidth,
              labelText: "Last Name",
              isRequired: true,
            ),
            DropdownWidget(
              hintText: "Nationality",
              dropdownBtnWidth: dpWidth,
              dropdownOptionsWidth: dpWidth,
              onChanged: (_) {},
              items: Constants.userTitleTypes.values.toList(),
            ),
            TextInputWidget(
              width: dpWidth,
              enabled: false,
              labelText: "Date of Birth",
              leftIcon: HeroIcons.calendar,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime(2015),
                  firstDate: DateTime(2015),
                  lastDate: DateTime(2035),
                );
              },
            ),
          ]),
      SpacedColumn(
          verticalSpace: 32.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownWidget(
              hintText: "Martial Status",
              dropdownBtnWidth: dpWidth,
              dropdownOptionsWidth: dpWidth,
              onChanged: (_) {},
              items: Constants.userMartialStatusTypes.values.toList(),
            ),
            TextInputWidget(
              width: dpWidth,
              labelText: "Email Address",
            ),
            TextInputWidget(
              width: dpWidth,
              labelText: "Phone Number",
            ),
            TextInputWidget(
              width: dpWidth,
              labelText: "Phone Landline",
            ),
            DropdownWidget(
              hintText: "Account Status",
              dropdownBtnWidth: dpWidth,
              dropdownOptionsWidth: dpWidth,
              onChanged: (_) {},
              items: Constants.userAccountStatusTypes.values.toList(),
            ),
          ]),
    ]);
  }
}

class _UsernameAndPayrollInfoWidget extends StatelessWidget {
  static const String title = "Username and Payroll Information";

  const _UsernameAndPayrollInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWidget(
            width: dpWidth,
            labelText: "Username",
            controller: TextEditingController(text: "12345678"),
            disableAll: true,
          ),
          TextInputWidget(
            width: dpWidth,
            labelText: "Payroll Code",
          ),
          TextInputWidget(
            width: dpWidth,
            labelText: "Password",
            isPassword: true,
            isRequired: true,
          ),
          TextInputWidget(
            width: dpWidth,
            labelText: "Repeat Password",
            isPassword: true,
            isRequired: true,
          ),
        ]);
  }
}

class _RolesDepsAndLoginOptionsWidget extends StatelessWidget {
  static const String title = "Roles, Department and Login Options";

  const _RolesDepsAndLoginOptionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return SpacedRow(horizontalSpace: 64.0, children: [
      _buildLeftPart(dpWidth),
      _buildRightPart(dpWidth),
    ]);
  }

  Widget _buildRightPart(double dpWidth) {
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWidget(
            width: dpWidth,
            labelText: "National Insurance",
          ),
          DropdownWidget(
            hintText: "Department Manager",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Location Manager",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            onChanged: (_) {},
            items: [],
          ),
        ]);
  }

  Widget _buildLeftPart(double dpWidth) {
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownWidget(
            isRequired: true,
            hintText: "Role",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            isRequired: true,
            hintText: "Department",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            isRequired: true,
            hintText: "Location",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            onChanged: (_) {},
            items: [],
          ),
          const SizedBox(height: 0.0),
          DropdownWidget(
            isRequired: true,
            hintText: "Display Language",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            onChanged: (_) {},
            items: [],
          ),
          TextInputWidget(
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            width: dpWidth,
            labelText: "Notes",
          ),
          const SizedBox(height: 0.0),
          _buildCheckboxes(),
        ]);
  }

  Widget _buildCheckboxes() {
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpacedRow(
            horizontalSpace: 4.0,
            children: [
              KText(
                  text: 'Login Methods',
                  fontSize: 14.0,
                  fontWeight: FWeight.bold,
                  isSelectable: false,
                  textColor: ThemeColors.gray2),
              KText(
                  text: '*',
                  fontSize: 14.0,
                  fontWeight: FWeight.bold,
                  isSelectable: false,
                  textColor: ThemeColors.red3),
            ],
          ),
          SpacedColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              verticalSpace: 16.0,
              children: [
                _chbx(true, (_) {}, 'Web'),
                _chbx(true, (_) {}, 'Mobile'),
                _chbx(true, (_) {}, 'Tablet'),
                _chbx(false, (_) {}, 'Mobile Admin'),
                _chbx(true, (_) {}, 'API'),
              ]),
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              CheckboxWidget(value: true, onChanged: (_) {}),
              KText(
                text: "User is required to login",
                fontSize: 14.0,
                textColor: ThemeColors.gray2,
                isSelectable: false,
                fontWeight: FWeight.bold,
              )
            ],
          ),
        ]);
  }

  Widget _chbx(bool value, ValueChanged<bool> onChanged, String text) {
    return SpacedRow(
      horizontalSpace: 8.0,
      children: [
        ToggleCheckboxWidget(
            value: value,
            width: 32.0,
            height: 16.0,
            toggleSize: 14.0,
            padding: 1.0,
            activeColor: ThemeColors.blue3,
            inactiveColor: ThemeColors.gray11,
            onToggle: onChanged),
        KText(
          text: text,
          fontSize: 14.0,
          textColor: ThemeColors.gray2,
          isSelectable: false,
        )
      ],
    );
  }
}

class _AddressWidget extends StatelessWidget {
  static const String title = "Address";

  const _AddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return SpacedRow(
      horizontalSpace: 24.0,
      children: [
        SpacedColumn(
            verticalSpace: 32.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInputWidget(
                width: (dpWidth * 1.7),
                labelText: "Street Address",
                isRequired: true,
              ),
              SpacedRow(
                horizontalSpace: dpWidth / 3.8,
                children: [
                  TextInputWidget(
                    width: dpWidth / 1.4,
                    labelText: "City/Town",
                    isRequired: true,
                  ),
                  TextInputWidget(
                    width: dpWidth / 1.4,
                    labelText: "County",
                  ),
                ],
              ),
              DropdownWidget(
                isRequired: true,
                hintText: "Country",
                dropdownBtnWidth: (dpWidth * 1.7),
                dropdownOptionsWidth: (dpWidth * 2) + 24.0,
                onChanged: (_) {},
                items: [],
              ),
            ]),
        TextInputWidget(
          width: dpWidth / 2,
          labelText: "Post Code",
        ),
      ],
    );
  }
}

class _EthnicAndReligionWidget extends StatelessWidget {
  static const String title = "Ethnic and Religion";

  const _EthnicAndReligionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * .3;
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownWidget(
            hintText: "Ethnic",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Religion",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            onChanged: (_) {},
            items: [],
          )
        ]);
  }
}

class _NextOfKinInfoWidget extends StatelessWidget {
  static const String title = "Next of Kin Information";

  const _NextOfKinInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * .3;
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWidget(
            width: dpWidth,
            labelText: "Next of Kin",
          ),
          TextInputWidget(
            width: dpWidth,
            labelText: "Next of Kin Relation",
          ),
          TextInputWidget(
            width: dpWidth,
            labelText: "Next of Kin Phone Number",
          ),
        ]);
  }
}

class _SaveAndCancelButtonsWidget extends StatelessWidget {
  const _SaveAndCancelButtonsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpacedRow(
        mainAxisAlignment: MainAxisAlignment.end,
        horizontalSpace: 14.0,
        children: [
          ButtonLargeSecondary(
            paddingWithoutIcon: true,
            text: "Cancel",
            onPressed: () {},
            bgColor: ThemeColors.white,
          ),
          ButtonLarge(
            icon: const HeroIcon(HeroIcons.check),
            text: "Save Changes",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
