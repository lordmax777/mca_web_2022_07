import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/auth_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/state_value.dart';
import 'package:mca_web_2022_07/manager/redux/states/users_state/users_state.dart';
import '../../manager/models/list_all_md.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../manager/redux/states/users_state/saved_user_state.dart';
import '../../theme/theme.dart';
import 'package:image_picker/image_picker.dart';

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
    _addGeneralTabItems(isExpanded: appStore.state.usersState.isNewUser);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final e1 = state.usersState.userDetails.error;
        final errors = [e1];
        if (state.usersState.isNewUser) {
          errors.clear();
        }

        return ErrorWrapper(
          errors: errors,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
                color: ThemeColors.gray11, height: 1.0, thickness: 1.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _generalItems.length + 1,
            itemBuilder: (context, index) {
              if (index == _generalItems.length) {
                return SaveAndCancelButtonsWidget(
                  formKeys: [
                    _PersonalDetailsWidget.formKey,
                    _UsernameAndPayrollInfoWidget.formKey,
                    _RolesDepsAndLoginOptionsWidget.formKey,
                    _AddressWidget.formKey,
                    _NextOfKinInfoWidget.formKey,
                  ],
                );
              }
              return _generalItems[index];
            },
          ),
        );
      },
    );
  }

  void _addGeneralTabItems({bool isExpanded = false}) {
    _generalItems.add(_buildExpanableItem(
        const _PersonalDetailsWidget(), _PersonalDetailsWidget.title,
        isExpanded: isExpanded));
    _generalItems.add(_buildExpanableItem(const _UsernameAndPayrollInfoWidget(),
        _UsernameAndPayrollInfoWidget.title));
    _generalItems.add(_buildExpanableItem(
        const _RolesDepsAndLoginOptionsWidget(),
        _RolesDepsAndLoginOptionsWidget.title));
    _generalItems
        .add(_buildExpanableItem(const _AddressWidget(), _AddressWidget.title));
    _generalItems.add(_buildExpanableItem(
        const _EthnicAndReligionWidget(), _EthnicAndReligionWidget.title));
    _generalItems.add(_buildExpanableItem(
        const _NextOfKinInfoWidget(), _NextOfKinInfoWidget.title));
  }

  Widget _buildExpanableItem(Widget child, String title,
      {bool isExpanded = false}) {
    bool a = true;
    return StatefulBuilder(
      builder: (context, ss) {
        return ExpansionTile(
          maintainState: true,
          initiallyExpanded: isExpanded,
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

class _PersonalDetailsWidget extends StatefulWidget {
  static const String title = "Personal Details";

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  const _PersonalDetailsWidget({Key? key}) : super(key: key);

  @override
  State<_PersonalDetailsWidget> createState() => _PersonalDetailsWidgetState();
}

class _PersonalDetailsWidgetState extends State<_PersonalDetailsWidget> {
  XFile? pickedImage;

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final countries = state.generalState.paramList.data!.countries;
          final maritalStatuses =
              state.generalState.paramList.data!.marital_statuses;
          final savedUser = state.savedUserState;
          final String? userAvatar = savedUser.photo;
          return Form(
            key: _PersonalDetailsWidget.formKey,
            child: SpacedRow(horizontalSpace: 64.0, children: [
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
                          : pickedImage != null
                              ? (Image.network(pickedImage!.path))
                              : (const HeroIcon(HeroIcons.userCircle,
                                  size: 48.0, color: ThemeColors.white)),
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
                      onPressed: () {
                        final ImagePicker _picker = ImagePicker();
                        _picker.pickImage(source: ImageSource.gallery).then(
                          (value) async {
                            setState(() {
                              pickedImage = value;
                            });
                            final bytes = await value?.readAsBytes();
                            if (bytes != null) {
                              appStore.dispatch(UpdateSavedUserStateAction(
                                  photo: base64Encode(bytes)));
                            }
                          },
                        );
                      },
                    ),
                    if (userAvatar != null || pickedImage != null)
                      ButtonSmallSecondary(
                        leftIcon: const HeroIcon(HeroIcons.bin,
                            size: 20.0, color: ThemeColors.red3),
                        text: "",
                        onPressed: () async {
                          if (pickedImage != null) {
                            setState(() {
                              pickedImage = null;
                            });
                          }
                          bool success = await appStore
                              .dispatch(GetDeleteUserPhotoAction());
                          if (success) {
                            appStore.dispatch(
                                UpdateSavedUserStateAction(photo: null));
                          }
                        },
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
                        final t = CodeMap(
                            name: cName,
                            code: Constants.userTitleTypes.entries
                                .firstWhere((element) => element.value == cName)
                                .key);
                        appStore.dispatch(UpdateSavedUserStateAction(title: t));
                      },
                      items: Constants.userTitleTypes.values.toList(),
                    ),
                    TextInputWidget(
                      width: dpWidth,
                      labelText: "First Name",
                      isRequired: true,
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "First Name is required";
                        }
                      },
                      controller: savedUser.firstName,
                    ),
                    TextInputWidget(
                      width: dpWidth,
                      labelText: "Last Name",
                      isRequired: true,
                      controller: savedUser.lastName,
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "Last Name is required";
                        }
                      },
                    ),
                    DropdownWidget(
                      hintText: "Nationality",
                      dropdownBtnWidth: dpWidth,
                      dropdownMaxHeight: 500.0,
                      dropdownOptionsWidth: dpWidth,
                      value: savedUser.nationalityCountryCode.name,
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
                              ? savedUser.birthdate!.formattedDate
                              : ""),
                      onTap: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: savedUser.birthdate ?? DateTime.now(),
                          firstDate: DateTime(1930),
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
                      value: savedUser.maritalStatusCode.name,
                      onChanged: (cName) {
                        savedUser.maritalStatusCode = CodeMap(
                            name: cName,
                            code: maritalStatuses
                                .firstWhere((element) => element.name == cName)
                                .code);
                        appStore.dispatch(UpdateUsersStateAction());
                      },
                      items: maritalStatuses.map((e) => e.name).toList(),
                    ),
                    TextInputWidget(
                      width: dpWidth,
                      labelText: "Email Address",
                      controller: savedUser.exEmail,
                      validator: (p0) {
                        if (p0 != null &&
                            p0.isNotEmpty &&
                            !RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                .hasMatch(p0)) {
                          return "Invalid email address";
                        }
                      },
                    ),
                    TextInputWidget(
                      width: dpWidth,
                      labelText: "Phone Number",
                      controller: savedUser.phoneMobile,
                      validator: (p0) {
                        if (p0 != null &&
                            p0.isNotEmpty &&
                            !RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
                                .hasMatch(p0)) {
                          return "Invalid phone number";
                        }
                      },
                    ),
                    TextInputWidget(
                      width: dpWidth,
                      labelText: "Phone Landline",
                      controller: savedUser.phoneLandline,
                      validator: (p0) {
                        if (p0 != null &&
                            p0.isNotEmpty &&
                            !RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
                                .hasMatch(p0)) {
                          return "Invalid phone number";
                        }
                      },
                    ),
                    DropdownWidget(
                      hintText: "Account Status",
                      dropdownBtnWidth: dpWidth,
                      dropdownOptionsWidth: dpWidth,
                      value: savedUser.isActivate.name,
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
            ]),
          );
        });
  }
}

class _UsernameAndPayrollInfoWidget extends StatelessWidget {
  static const String title = "Username and Payroll Information";

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  const _UsernameAndPayrollInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        final savedUser = state.savedUserState;
        return Form(
          key: formKey,
          child: SpacedColumn(
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
                  validator: state.usersState.isNewUser
                      ? (p0) {
                          if (p0 != null && p0.isEmpty) {
                            //TODO: check if password is valid
                            return "Password cannot be empty";
                          }
                          if (p0 != null && p0.length < 4) {
                            return "Password must be more than 4 characters";
                          }
                        }
                      : (p0) {
                          // if (p0 != null && p0.isEmpty) {
                          //   return "Password is invalid";
                          // }
                        },
                  isPassword: true,
                  isRequired: true,
                ),
                TextInputWidget(
                  width: dpWidth,
                  controller: savedUser.upassRepeat,
                  labelText: "Repeat Password",
                  validator: (p0) {
                    if (state.savedUserState.upass.text.isNotEmpty) {
                      if (state.savedUserState.upassRepeat.text !=
                          state.savedUserState.upass.text) {
                        return "Passwords do not match";
                      }
                    }
                  },
                  isPassword: true,
                  isRequired: true,
                ),
              ]),
        );
      },
    );
  }
}

class _RolesDepsAndLoginOptionsWidget extends StatelessWidget {
  static const String title = "Roles, Department and Login Options";

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  const _RolesDepsAndLoginOptionsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          return Form(
            key: formKey,
            child: SpacedRow(horizontalSpace: 64.0, children: [
              _buildLeftPart(dpWidth, state),
              _buildRightPart(dpWidth, state),
            ]),
          );
        });
  }

  Widget _buildRightPart(double dpWidth, AppState state) {
    final savedUser = state.savedUserState;
    return SpacedColumn(
        verticalSpace: 32.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWidget(
            width: dpWidth,
            controller: savedUser.nationalInsuranceNo,
            labelText: "National Insurance",
          ),
          _chbx(savedUser.isGrouoAdmin, (val) {
            savedUser.isGrouoAdmin = val;
            appStore.dispatch(UpdateUsersStateAction());
          }, 'Deparment Manager'),
          _chbx(savedUser.locationAdmin, (val) {
            savedUser.locationAdmin = val;
            appStore.dispatch(UpdateUsersStateAction());
          }, 'Location Manager'),
        ]);
  }

  Widget _buildLeftPart(double dpWidth, AppState state) {
    final savedUser = state.savedUserState;
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
            value: savedUser.roleCode.name,
            onChanged: (cName) {
              savedUser.roleCode = CodeMap(
                  name: cName,
                  code: roles
                      .firstWhere((element) => element.name == cName)
                      .code);
              appStore.dispatch(UpdateSavedUserStateAction());
            },
            items: roles.map((e) => e.name).toList(),
          ),
          DropdownWidget(
            isRequired: true,
            hintText: "Department",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            hasSearchBox: true,
            value: savedUser.groupId.name,
            onChanged: (cName) {
              savedUser.groupId = CodeMap(
                  name: cName,
                  code: deps
                      .firstWhere((element) => element.name == cName)
                      .id
                      .toString());
              appStore.dispatch(UpdateSavedUserStateAction());
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
            value: savedUser.locationId.name,
            onChanged: (cName) {
              savedUser.locationId = CodeMap(
                  name: cName,
                  code: locs
                      .firstWhere((element) => element.name == cName)
                      .id
                      .toString());
              appStore.dispatch(UpdateSavedUserStateAction());
            },
            items: locs.map((e) => e.name).toList(),
          ),
          const SizedBox(height: 0.0),
          DropdownWidget(
            isRequired: true,
            hintText: "Display Language",
            dropdownBtnWidth: dpWidth,
            dropdownOptionsWidth: dpWidth,
            value: savedUser.languageCode.name,
            onChanged: (cName) {
              savedUser.languageCode = CodeMap(
                  name: cName,
                  code: Constants.userDisplayLangs.entries
                      .firstWhere((element) => element.value == cName)
                      .key);

              appStore.dispatch(UpdateSavedUserStateAction());
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
    final savedUser = state.savedUserState;
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

class _AddressWidget extends StatelessWidget {
  static const String title = "Address";

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  const _AddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * 0.2;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final savedUser = state.savedUserState;
          final general = state.generalState.paramList.data!;

          return Form(
            key: formKey,
            child: SpacedRow(horizontalSpace: 24.0, children: [
              SpacedColumn(
                  verticalSpace: 32.0,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpacedRow(
                      horizontalSpace: dpWidth / 3.8,
                      children: [
                        TextInputWidget(
                          width: (dpWidth * 1.7),
                          labelText: "Street Address",
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Street Address is required";
                            }
                            return null;
                          },
                          isRequired: true,
                          controller: savedUser.addressLine1,
                        ),
                        TextInputWidget(
                          width: dpWidth / 1.5,
                          labelText: "Post Code",
                          isRequired: true,
                          validator: (p0) {
                            if (p0!.isEmpty) {
                              return "Post Code is required";
                            }
                          },
                          controller: savedUser.addressPostcode,
                        ),
                      ],
                    ),
                    SpacedRow(horizontalSpace: dpWidth / 3.8, children: [
                      TextInputWidget(
                        width: dpWidth / 1.4,
                        labelText: "City/Town",
                        isRequired: true,
                        validator: (p0) {
                          if (p0!.isEmpty) {
                            return "City/Town is required";
                          }
                        },
                        controller: savedUser.addressCity,
                      ),
                      TextInputWidget(
                        width: dpWidth / 1.4,
                        labelText: "County",
                        controller: savedUser.county,
                      ),
                    ]),
                    DropdownWidget(
                      hintText: "Country",
                      dropdownMaxHeight: 400.0,
                      dropdownBtnWidth: (dpWidth * 1.7),
                      dropdownOptionsWidth: (dpWidth * 2) + 24.0,
                      value: savedUser.addressCountry.name,
                      onChanged: (cName) {
                        savedUser.addressCountry = CodeMap(
                            name: cName,
                            code: general.countries
                                .firstWhere(
                                  (element) => element.name == cName,
                                  orElse: () => ListCountry(name: '', code: ''),
                                )
                                .code);

                        appStore.dispatch(UpdateUsersStateAction());
                      },
                      hasSearchBox: true,
                      isRequired: true,
                      items: general.countries.map((e) => e.name).toList(),
                    ),
                  ])
            ]),
          );
        });
  }
}

class _EthnicAndReligionWidget extends StatelessWidget {
  static const String title = "Ethnic and Religion";

  const _EthnicAndReligionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * .3;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final savedUser = state.savedUserState;
          final general = state.generalState.paramList.data!;

          return SpacedColumn(
              verticalSpace: 32.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownWidget(
                  hintText: "Ethnic",
                  dropdownBtnWidth: dpWidth,
                  hasSearchBox: true,
                  value: savedUser.ethnicId.name,
                  dropdownOptionsWidth: dpWidth,
                  onChanged: (cName) {
                    savedUser.ethnicId = CodeMap(
                        name: cName,
                        code: general.ethnics
                            .firstWhere(
                              (element) => element.name == cName,
                              orElse: () => ListEthnic(name: '', id: -1),
                            )
                            .id
                            .toString());

                    appStore.dispatch(UpdateUsersStateAction());
                  },
                  items: general.ethnics.map<String>((e) => e.name).toList(),
                ),
                DropdownWidget(
                  hintText: "Religion",
                  dropdownBtnWidth: dpWidth,
                  hasSearchBox: true,
                  value: savedUser.religionId.name,
                  dropdownOptionsWidth: dpWidth,
                  onChanged: (cName) {
                    savedUser.religionId = CodeMap(
                        name: cName,
                        code: general.religions
                            .firstWhere(
                              (element) => element.name == cName,
                              orElse: () => ListReligion(name: '', id: -1),
                            )
                            .id
                            .toString());

                    appStore.dispatch(UpdateUsersStateAction());
                  },
                  items: general.religions.map<String>((e) => e.name).toList(),
                )
              ]);
        });
  }
}

class _NextOfKinInfoWidget extends StatelessWidget {
  static const String title = "Next of Kin Information";

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();

  const _NextOfKinInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width * .3;
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, state) {
          final savedUser = state.savedUserState;

          return Form(
            key: formKey,
            child: SpacedColumn(
                verticalSpace: 32.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInputWidget(
                    width: dpWidth,
                    labelText: "Next of Kin Name",
                    controller: savedUser.nextOfKinName,
                  ),
                  TextInputWidget(
                    width: dpWidth,
                    labelText: "Next of Kin Relation",
                    controller: savedUser.nextOfKinRelation,
                  ),
                  TextInputWidget(
                    width: dpWidth,
                    labelText: "Next of Kin Phone Number",
                    controller: savedUser.nextOfKinPhone,
                    validator: (p0) {
                      if (p0 != null &&
                          p0.isNotEmpty &&
                          !RegExp(r"^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$")
                              .hasMatch(p0)) {
                        return "Invalid phone number";
                      }
                    },
                  ),
                ]),
          );
        });
  }
}

class SaveAndCancelButtonsWidget extends StatelessWidget {
  final List<GlobalKey<FormState>> formKeys;
  SaveAndCancelButtonsWidget({Key? key, required this.formKeys})
      : super(key: key);

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
            onPressed: () {
              context.navigateBack();
            },
            bgColor: ThemeColors.white,
          ),
          ButtonLarge(
            icon: const HeroIcon(HeroIcons.check),
            text: "Save Changes",
            onPressed: () async {
              bool allValid = true;
              if (formKeys
                  .every((element) => element.currentState!.validate())) {
                logger('Valid');
                await fetch(GetSaveGeneralDetailsAction());
              } else {
                logger('Invalid');
              }
            },
          ),
        ],
      ),
    );
  }
}
