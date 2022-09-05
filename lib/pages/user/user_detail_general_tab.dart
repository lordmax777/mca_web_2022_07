import 'dart:convert';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';

class GeneralWidget extends StatefulWidget {
  const GeneralWidget({Key? key}) : super(key: key);

  @override
  State<GeneralWidget> createState() => _GeneralWidgetState();
}

class _GeneralWidgetState extends State<GeneralWidget> {
  final List<Widget> _generalItems = [];

  @override
  void initState() {
    super.initState();
    _addGeneralTabItems();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) =>
          const Divider(color: ThemeColors.gray11, height: 1.0, thickness: 1.0),
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

class PersonalDetailsWidget extends StatelessWidget {
  static const String title = "Personal Details";

  const PersonalDetailsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final countries = state.generalState.paramList.data!.countries;
          final savedUser = state.usersState.saveableUserDetails!;
          final String? userAvatar = savedUser.photo;
          return SpacedRow(horizontalSpace: 64.0, children: [
            SpacedColumn(verticalSpace: 16.0, children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24.0),
                child: Container(
                  width: 100,
                  height: 100,
                  color: ThemeColors.blue7,
                  child: Center(
                    child: userAvatar != null
                        ? Image.memory(base64Decode(userAvatar))
                        : const HeroIcon(HeroIcons.userCircle,
                            size: 48.0, color: ThemeColors.white),
                  ),
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
                  if (userAvatar != null)
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
                    dropdownBtnWidth: dpWidth,
                    dropdownOptionsWidth: dpWidth,
                    value: savedUser.title.name,
                    onChanged: (cName) {
                      savedUser.title = CodeMap(
                          name: cName,
                          code: Constants.userTitleTypes.entries
                              .firstWhere((element) => element.value == cName)
                              .key);
                      appStore.dispatch(UpdateUsersStateAction());
                    },
                    items: Constants.userTitleTypes.values.toList(),
                  ),
                  TextInputWidget(
                    width: dpWidth,
                    labelText: "First Name",
                    isRequired: true,
                    controller: savedUser.firstName,
                  ),
                  TextInputWidget(
                    width: dpWidth,
                    labelText: "Last Name",
                    isRequired: true,
                    controller: savedUser.lastName,
                  ),
                  DropdownWidget(
                    hintText: "Nationality",
                    dropdownBtnWidth: dpWidth,
                    dropdownMaxHeight: 500.0,
                    dropdownOptionsWidth: dpWidth,
                    value: savedUser.nationalityCountryCode?.name,
                    hasSearchBox: true,
                    onChanged: (cName) {
                      savedUser.nationalityCountryCode = CodeMap(
                          name: cName,
                          code: countries
                              .firstWhere((element) => element.name == cName)
                              .code);
                      appStore.dispatch(UpdateUsersStateAction());
                    },
                    items: countries.map((e) => e.name).toList(),
                  ),
                  TextInputWidget(
                    width: dpWidth,
                    enabled: false,
                    labelText: "Date of Birth",
                    leftIcon: HeroIcons.calendar,
                    controller: TextEditingController(
                        text: savedUser.birthdate != null
                            ? getDateFormat(savedUser.birthdate!)
                            : ""),
                    onTap: () async {
                      final d = await showDatePicker(
                        context: context,
                        initialDate: savedUser.birthdate ?? DateTime.now(),
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2035),
                      );
                      if (d != null) {
                        savedUser.birthdate = d;
                        appStore.dispatch(UpdateUsersStateAction());
                      }
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
                    value: savedUser.maritalStatusCode?.name,
                    onChanged: (cName) {
                      savedUser.maritalStatusCode =
                          CodeMap(name: cName, code: "TODO: get code from api");
                      appStore.dispatch(UpdateUsersStateAction());
                    },
                    items: Constants.userMartialStatusTypes.values.toList(),
                  ),
                  TextInputWidget(
                    width: dpWidth,
                    labelText: "Email Address",
                    controller: savedUser.exEmail,
                  ),
                  TextInputWidget(
                    width: dpWidth,
                    labelText: "Phone Number",
                    controller: savedUser.phoneMobile,
                  ),
                  TextInputWidget(
                    width: dpWidth,
                    labelText: "Phone Landline",
                    controller: savedUser.phoneLandline,
                  ),
                  DropdownWidget(
                    hintText: "Account Status",
                    dropdownBtnWidth: dpWidth,
                    dropdownOptionsWidth: dpWidth,
                    value: savedUser.isActivate?.name,
                    onChanged: (cName) {
                      savedUser.isActivate = CodeMap(
                          name: cName,
                          code: Constants.userAccountStatusTypes.entries
                                  .firstWhere(
                                      (element) => element.value == cName)
                                  .key
                              ? 1.toString()
                              : 0.toString());

                      appStore.dispatch(UpdateUsersStateAction());
                    },
                    items: Constants.userAccountStatusTypes.values.toList(),
                  ),
                ]),
          ]);
        });
  }
}

class UsernameAndPayrollInfoWidget extends StatelessWidget {
  static const String title = "Username and Payroll Information";

  const UsernameAndPayrollInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final savedUser = state.usersState.saveableUserDetails!;

        return SpacedColumn(
            verticalSpace: 32.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextInputWidget(
                width: dpWidth,
                labelText: "Username",
                controller: savedUser.username,
                disableAll: true,
              ),
              TextInputWidget(
                width: dpWidth,
                labelText: "Payroll Code",
                controller: savedUser.payrollCode,
              ),
              TextInputWidget(
                width: dpWidth,
                controller: savedUser.upass,
                labelText: "Password",
                isPassword: true,
                isRequired: true,
              ),
              TextInputWidget(
                width: dpWidth,
                controller: savedUser.upassRepeat,
                labelText: "Repeat Password",
                isPassword: true,
                isRequired: true,
              ),
            ]);
      },
    );
  }
}

class RolesDepsAndLoginOptionsWidget extends StatelessWidget {
  static const String title = "Roles, Department and Login Options";

  const RolesDepsAndLoginOptionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final roles = state.generalState.paramList.data!.roles;
          return SpacedRow(horizontalSpace: 64.0, children: [
            _buildLeftPart(dpWidth, state),
            _buildRightPart(dpWidth, state),
          ]);
        });
  }

  Widget _buildRightPart(double dpWidth, AppState state) {
    final savedUser = state.usersState.saveableUserDetails!;
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWidget(
            width: dpWidth,
            controller: savedUser.nationalInsuranceNo,
            labelText: "National Insurance",
          ),
          DropdownWidget(
            hintText: "Department Manager",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            disableAll: true,
            onChanged: (_) {},
            items: [],
          ),
          DropdownWidget(
            hintText: "Location Manager",
            dropdownBtnWidth: dpWidth,
            disableAll: true,
            dropdownOptionsWidth: dpWidth,
            onChanged: (_) {},
            items: [],
          ),
        ]);
  }

  Widget _buildLeftPart(double dpWidth, AppState state) {
    final savedUser = state.usersState.saveableUserDetails!;
    final roles = state.generalState.paramList.data!.roles;
    final deps = state.generalState.paramList.data!.groups;
    final locs = state.generalState.paramList.data!.locations;

    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownWidget(
            isRequired: true,
            hintText: "Role",
            hasSearchBox: true,
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            value: savedUser.roleCode?.name,
            onChanged: (cName) {
              savedUser.roleCode = CodeMap(
                  name: cName,
                  code: roles
                      .firstWhere((element) => element.name == cName)
                      .code);
              appStore.dispatch(UpdateUsersStateAction());
            },
            items: roles.map((e) => e.name).toList(),
          ),
          DropdownWidget(
            isRequired: true,
            hintText: "Department",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            hasSearchBox: true,
            value: savedUser.groupId?.name,
            onChanged: (cName) {
              savedUser.groupId = CodeMap(
                  name: cName,
                  code: deps
                      .firstWhere((element) => element.name == cName)
                      .id
                      .toString());
              appStore.dispatch(UpdateUsersStateAction());
            },
            items: deps.map((e) => e.name).toList(),
          ),
          DropdownWidget(
            isRequired: true,
            hintText: "Location",
            hasSearchBox: true,
            dropdownBtnWidth: dpWidth,
            dropdownMaxHeight: 500.0,
            dropdownOptionsWidth: dpWidth,
            value: savedUser.locationId?.name,
            onChanged: (cName) {
              savedUser.locationId = CodeMap(
                  name: cName,
                  code: locs
                      .firstWhere((element) => element.name == cName)
                      .id
                      .toString());
              appStore.dispatch(UpdateUsersStateAction());
            },
            items: locs.map((e) => e.name).toList(),
          ),
          const SizedBox(height: 0.0),
          DropdownWidget(
            isRequired: true,
            hintText: "Display Language",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            value: savedUser.languageCode?.name,
            onChanged: (cName) {
              savedUser.languageCode = CodeMap(
                  name: cName,
                  code: Constants.userDisplayLangs.entries
                      .firstWhere((element) => element.value == cName)
                      .key);
              appStore.dispatch(UpdateUsersStateAction());
            },
            items: Constants.userDisplayLangs.values.toList(),
          ),
          TextInputWidget(
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            width: dpWidth,
            controller: savedUser.notes,
            labelText: "Notes",
          ),
          const SizedBox(height: 0.0),
          _buildCheckboxes(state),
        ]);
  }

  Widget _buildCheckboxes(AppState state) {
    final savedUser = state.usersState.saveableUserDetails!;
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
                _chbx(savedUser.loginMethods.web, (val) {
                  savedUser.loginMethods.web = val;
                  appStore.dispatch(UpdateUsersStateAction());
                }, 'Web'),
                _chbx(savedUser.loginMethods.mobile, (val) {
                  savedUser.loginMethods.mobile = val;
                  appStore.dispatch(UpdateUsersStateAction());
                }, 'Mobile'),
                _chbx(savedUser.loginMethods.tablet, (val) {
                  savedUser.loginMethods.tablet = val;
                  appStore.dispatch(UpdateUsersStateAction());
                }, 'Tablet'),
                _chbx(savedUser.loginMethods.mobileAdmin, (val) {
                  savedUser.loginMethods.mobileAdmin = val;
                  appStore.dispatch(UpdateUsersStateAction());
                }, 'Mobile Admin'),
                _chbx(savedUser.loginMethods.api, (val) {
                  savedUser.loginMethods.api = val;
                  appStore.dispatch(UpdateUsersStateAction());
                }, 'API'),
              ]),
          SpacedRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            horizontalSpace: 8.0,
            children: [
              CheckboxWidget(
                  value: savedUser.loginRequired,
                  onChanged: (val) {
                    savedUser.loginRequired = val!;
                    appStore.dispatch(UpdateUsersStateAction());
                  }),
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

class AddressWidget extends StatelessWidget {
  static const String title = "Address";

  const AddressWidget({Key? key}) : super(key: key);

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
          width: dpWidth / 1.5,
          labelText: "Post Code",
        ),
      ],
    );
  }
}

class EthnicAndReligionWidget extends StatelessWidget {
  static const String title = "Ethnic and Religion";

  const EthnicAndReligionWidget({Key? key}) : super(key: key);

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

class NextOfKinInfoWidget extends StatelessWidget {
  static const String title = "Next of Kin Information";

  const NextOfKinInfoWidget({Key? key}) : super(key: key);

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

class SaveAndCancelButtonsWidget extends StatelessWidget {
  const SaveAndCancelButtonsWidget({Key? key}) : super(key: key);

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
