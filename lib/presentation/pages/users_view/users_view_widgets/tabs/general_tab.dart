import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/users_view/data/user_data_source.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';

class UserGeneralTab extends StatelessWidget {
  final UserDataSource data;
  final ValueChanged<UserDataSource> onChanged;

  const UserGeneralTab(
      {super.key, required this.data, required this.onChanged});

  set data(UserDataSource value) {
    onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ListMd>(
      converter: (store) => store.state.generalState.lists,
      builder: (context, vm) {
        final titles = [...vm.userTitles];
        final maritalStatuses = [...vm.maritalStatuses];
        final countries = [...vm.countries];
        final loginMethods = [...vm.loginMethods];

        final myRole = appStore.state.generalState.detailsMd.role;

        final indexOfMyRole =
            vm.roles.indexWhere((element) => element.code == myRole);

        //Show roles where index is after indexOfMyRole
        final roles = [...vm.roles].whereIndexed((index, element) {
          if (index >= indexOfMyRole) {
            return true;
          }
          return false;
        }).toList();
        final departments =
            [...vm.groups].where((element) => element.active).toList();
        final locations =
            [...vm.locations].where((element) => element.active).toList();
        final languages = [...vm.languages];
        final ethnics = [...vm.ethnics];
        final religions = [...vm.religions];
        return SingleChildScrollView(
          padding: const EdgeInsets.only(top: 16),
          child: FocusTraversalGroup(
            policy: OrderedTraversalPolicy(),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                // Personal Details
                UserCard(
                  title: "Personal Details",
                  items: [
                    UserCardItem(
                      title: "Title",
                      dropdown: UserCardDropdown(
                          additionalValueId: data.personal.userTitle?.code,
                          items: [
                            for (int i = 0; i < titles.length; i++)
                              DefaultMenuItem(
                                id: i,
                                title: titles[i].name,
                                additionalId: titles[i].code,
                              ),
                          ],
                          onChanged: (value) {
                            data = data.copyWith(
                                personal: data.personal.copyWith(
                                    userTitle: titles.firstWhereOrNull(
                                        (element) =>
                                            element.code ==
                                            value.additionalId)));
                          }),
                    ),
                    UserCardItem(
                      isRequired: true,
                      title: "First Name",
                      controller: data.personal.firstName,
                    ),
                    UserCardItem(
                        isRequired: true,
                        title: "Last Name",
                        controller: data.personal.lastName),
                    UserCardItem(
                        title: "Email", controller: data.personal.email),
                    UserCardItem(
                        title: "Phone Number",
                        controller: data.personal.phoneNumber),
                    UserCardItem(
                        title: "Phone Landline Number",
                        controller: data.personal.phoneLandline),
                    UserCardItem(
                      title: "Nationality",
                      dropdown: UserCardDropdown(
                          additionalValueId: data.personal.nationality?.code,
                          items: [
                            for (int i = 0; i < countries.length; i++)
                              DefaultMenuItem(
                                id: i,
                                title: countries[i].name,
                                additionalId: countries[i].code,
                              ),
                          ],
                          onChanged: (value) {
                            data = data.copyWith(
                                personal: data.personal.copyWith(
                                    nationality: countries.firstWhereOrNull(
                                        (element) =>
                                            element.code ==
                                            value.additionalId)));
                          }),
                    ),
                    UserCardItem(
                        title: "Password",
                        isObscured: true,
                        isRequired: true,
                        controller: data.personal.password),
                    UserCardItem(
                        title: "Confirm Password",
                        isRequired: true,
                        isObscured: true,
                        controller: data.personal.confirmPassword),
                    UserCardItem(
                        title: "Payroll Code",
                        controller: data.personal.payrollCode),
                    UserCardItem(
                        title: "Username",
                        simpleText: data.personal.username.text),
                    UserCardItem(
                      title: "Date of Birth",
                      simpleText:
                          data.personal.dateOfBirth?.toApiDateWithDash ??
                              "Select Date",
                      onSimpleTextTapped: () {
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate:
                              data.personal.dateOfBirth ?? DateTime.now(),
                          lastDate: DateTime.now()
                            ..subtract(const Duration(days: 1)),
                        ).then((value) {
                          if (value != null) {
                            data = data.copyWith(
                                personal:
                                    data.personal.copyWith(dateOfBirth: value));
                          }
                        });
                      },
                    ),
                    UserCardItem(
                      title: "Marital Status",
                      dropdown: UserCardDropdown(
                          additionalValueId: data.personal.maritalStatus?.code,
                          items: [
                            for (int i = 0; i < maritalStatuses.length; i++)
                              DefaultMenuItem(
                                id: i,
                                title: maritalStatuses[i].name,
                                additionalId: maritalStatuses[i].code,
                              ),
                          ],
                          onChanged: (value) {
                            data = data.copyWith(
                                personal: data.personal.copyWith(
                                    maritalStatus: maritalStatuses
                                        .firstWhereOrNull((element) =>
                                            element.code ==
                                            value.additionalId)));
                          }),
                    ),
                    UserCardItem(
                      title: "Account Status (Active/Inactive)",
                      checked: data.personal.isActive,
                      onChecked: (value) {
                        debugPrint(data.toString());
                        data = data.copyWith(
                            personal: data.personal.copyWith(isActive: value));
                      },
                    ),
                  ],
                ),

                //Roles Deps and Login options and Ethnicity
                SpacedColumn(
                  verticalSpace: 16,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Roles Deps and Login options
                    UserCard(
                      title: "Roles, Departments and Login Options",
                      items: [
                        UserCardItem(
                          title: "Role",
                          isRequired: true,
                          dropdown: UserCardDropdown(
                              additionalValueId:
                                  data.roleDepartmentLoginOptions.role?.code,
                              items: [
                                for (int i = 0; i < roles.length; i++)
                                  DefaultMenuItem(
                                    id: i,
                                    title: roles[i].name,
                                    additionalId: roles[i].code,
                                  ),
                              ],
                              onChanged: (value) {
                                data = data.copyWith(
                                    roleDepartmentLoginOptions: data
                                        .roleDepartmentLoginOptions
                                        .copyWith(
                                            role: roles.firstWhereOrNull(
                                                (element) =>
                                                    element.code ==
                                                    value.additionalId)));
                              }),
                        ),
                        UserCardItem(
                          title: "Department",
                          dropdown: UserCardDropdown(
                              valueId: data
                                  .roleDepartmentLoginOptions.department?.id,
                              items: [
                                for (int i = 0; i < departments.length; i++)
                                  DefaultMenuItem(
                                    id: departments[i].id,
                                    title: departments[i].name,
                                  ),
                              ],
                              onChanged: (value) {
                                data = data.copyWith(
                                    roleDepartmentLoginOptions: data
                                        .roleDepartmentLoginOptions
                                        .copyWith(
                                            department: departments
                                                .firstWhereOrNull((element) =>
                                                    element.id == value.id)));
                              }),
                        ),
                        UserCardItem(
                          title: "Location",
                          dropdown: UserCardDropdown(
                              valueId:
                                  data.roleDepartmentLoginOptions.location?.id,
                              items: [
                                for (int i = 0; i < locations.length; i++)
                                  DefaultMenuItem(
                                    id: locations[i].id,
                                    title: locations[i].name,
                                    additionalId: locations[i].id.toString(),
                                  ),
                              ],
                              onChanged: (value) {
                                data = data.copyWith(
                                    roleDepartmentLoginOptions: data
                                        .roleDepartmentLoginOptions
                                        .copyWith(
                                            location: locations
                                                .firstWhereOrNull((element) =>
                                                    element.id == value.id)));
                              }),
                        ),
                        UserCardItem(
                          title: "Display Language",
                          dropdown: UserCardDropdown(
                              additionalValueId: data
                                  .roleDepartmentLoginOptions.language?.code,
                              items: [
                                for (int i = 0; i < languages.length; i++)
                                  DefaultMenuItem(
                                    id: i,
                                    title: languages[i].name,
                                    additionalId: languages[i].code,
                                  ),
                              ],
                              onChanged: (value) {
                                data = data.copyWith(
                                    roleDepartmentLoginOptions: data
                                        .roleDepartmentLoginOptions
                                        .copyWith(
                                            language: languages
                                                .firstWhereOrNull((element) =>
                                                    element.code ==
                                                    value.additionalId)));
                              }),
                        ),
                        UserCardItem(
                            title: "Notes",
                            maxLines: 3,
                            controller: data.roleDepartmentLoginOptions.notes),
                        UserCardItem(
                            title: "National Insurance Number",
                            controller: data.roleDepartmentLoginOptions
                                .nationalInsuranceNumber),
                        if (data.roleDepartmentLoginOptions.role?.code ==
                            "ROLE_MANAGER")
                          UserCardItem(
                            title: "Is Department Manager",
                            checked: data
                                .roleDepartmentLoginOptions.isDepartmentManager,
                            onChecked: (value) {
                              data = data.copyWith(
                                  roleDepartmentLoginOptions: data
                                      .roleDepartmentLoginOptions
                                      .copyWith(isDepartmentManager: value));
                            },
                          ),
                        if (data.roleDepartmentLoginOptions.role?.code ==
                            "ROLE_MANAGER")
                          UserCardItem(
                            title: "Is Location Manager",
                            checked: data
                                .roleDepartmentLoginOptions.isLocationManager,
                            onChecked: (value) {
                              data = data.copyWith(
                                  roleDepartmentLoginOptions: data
                                      .roleDepartmentLoginOptions
                                      .copyWith(isLocationManager: value));
                            },
                          ),
                        UserCardItem(
                          customWidget: Row(
                            children: [
                              Text("Login Options:",
                                  style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 320,
                                child: Wrap(
                                  spacing: 16,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    for (final loginMethod in loginMethods)
                                      DefaultCheckbox(
                                          value: data.roleDepartmentLoginOptions
                                              .loginMethods
                                              .any((element) =>
                                                  element.id == loginMethod.id),
                                          onChanged: (value) {
                                            if (value) {
                                              data = data.copyWith(
                                                  roleDepartmentLoginOptions: data
                                                      .roleDepartmentLoginOptions
                                                      .copyWith(loginMethods: [
                                                ...data
                                                    .roleDepartmentLoginOptions
                                                    .loginMethods,
                                                loginMethod
                                              ]));
                                            } else {
                                              data = data.copyWith(
                                                  roleDepartmentLoginOptions: data
                                                      .roleDepartmentLoginOptions
                                                      .copyWith(loginMethods: [
                                                ...data
                                                    .roleDepartmentLoginOptions
                                                    .loginMethods
                                                    .where((element) =>
                                                        element.id !=
                                                        loginMethod.id)
                                              ]));
                                            }
                                          },
                                          label: loginMethod.name)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),

                    //Next of Kin
                    UserCard(title: "Next of Kin", items: [
                      UserCardItem(
                        title: "Name",
                        controller: data.nextOfKin.name,
                      ),
                      UserCardItem(
                        title: "Relationship",
                        controller: data.nextOfKin.relationship,
                      ),
                      UserCardItem(
                        title: "Phone Number",
                        controller: data.nextOfKin.phoneNumber,
                      ),
                    ]),
                  ],
                ),

                //Address and Next of Kin
                SpacedColumn(
                  verticalSpace: 16,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Address
                    UserCard(
                      title: "Address",
                      items: [
                        UserCardItem(
                          customWidget: AddressAutocompleteWidget(
                            width: 500 - 32,
                            onSelected: (value) {
                              data.address.line1.text = value.line1;
                              data.address.city.text = value.city;
                              data.address.postcode.text = value.postcode;
                              data = data.copyWith(
                                  address: data.address.copyWith(
                                latitude: value.latitude,
                                longitude: value.longitude,
                                country: value.country,
                              ));
                            },
                          ),
                        ),
                        UserCardItem(
                          title: "Address Line 1",
                          isRequired: true,
                          controller: data.address.line1,
                        ),
                        UserCardItem(
                          title: "City",
                          isRequired: true,
                          controller: data.address.city,
                        ),
                        UserCardItem(
                          title: "County",
                          controller: data.address.county,
                        ),
                        UserCardItem(
                          isRequired: true,
                          title: "Postcode",
                          controller: data.address.postcode,
                        ),
                        UserCardItem(
                          isRequired: true,
                          title: "Country",
                          dropdown: UserCardDropdown(
                              additionalValueId: data.address.country?.code,
                              items: [
                                for (int i = 0; i < countries.length; i++)
                                  DefaultMenuItem(
                                    id: i,
                                    title: countries[i].name,
                                    additionalId: countries[i].code,
                                  ),
                              ],
                              onChanged: (value) {
                                data = data.copyWith(
                                    address: data.address.copyWith(
                                        country: countries.firstWhereOrNull(
                                            (element) =>
                                                element.code ==
                                                value.additionalId)));
                              }),
                        )
                      ],
                    ),

                    //Ethnicity and Religion
                    UserCard(title: "Ethnicity and Religion", items: [
                      UserCardItem(
                        title: "Ethnicity",
                        dropdown: UserCardDropdown(
                            valueId: data.religion.ethnicMd?.id,
                            items: [
                              for (int i = 0; i < ethnics.length; i++)
                                DefaultMenuItem(
                                  id: ethnics[i].id,
                                  title: ethnics[i].name,
                                ),
                            ],
                            onChanged: (value) {
                              data = data.copyWith(
                                  religion: data.religion.copyWith(
                                      ethnicMd: ethnics.firstWhereOrNull(
                                          (element) =>
                                              element.id == value.id)));
                            }),
                      ),
                      UserCardItem(
                        title: "Religion",
                        dropdown: UserCardDropdown(
                            valueId: data.religion.religionMd?.id,
                            items: [
                              for (int i = 0; i < religions.length; i++)
                                DefaultMenuItem(
                                  id: religions[i].id,
                                  title: religions[i].name,
                                ),
                            ],
                            onChanged: (value) {
                              data = data.copyWith(
                                  religion: data.religion.copyWith(
                                      religionMd: religions.firstWhereOrNull(
                                          (element) =>
                                              element.id == value.id)));
                            }),
                      )
                    ]),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    // return SingleChildScrollView(
    //   child: ExpansionPanelList(
    //     expansionCallback: (panelIndex, isExpanded) {
    //       items[panelIndex].isExpanded = !isExpanded;
    //       updateUI();
    //     },
    //     elevation: 0,
    //     dividerColor: Colors.grey[300],
    //     animationDuration: const Duration(milliseconds: 100),
    //     expandedHeaderPadding: const EdgeInsets.all(0),
    //     children: items.map((e) {
    //       return ExpansionPanel(
    //         canTapOnHeader: true,
    //         isExpanded: e.isExpanded,
    //         headerBuilder: (context, isExpanded) => ListTile(
    //           title: Text(e.title),
    //           textColor: isExpanded ? context.colorScheme.primary : null,
    //         ),
    //         body: e.body,
    //       );
    //     }).toList(),
    //   ),
    // );
  }
}
