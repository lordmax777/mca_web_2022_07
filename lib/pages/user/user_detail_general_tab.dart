import '../../theme/theme.dart';

class PersonalDetailsWidget extends StatelessWidget {
  static const String title = "Personal Details";

  const PersonalDetailsWidget({Key? key}) : super(key: key);

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

class UsernameAndPayrollInfoWidget extends StatelessWidget {
  static const String title = "Username and Payroll Information";

  const UsernameAndPayrollInfoWidget({Key? key}) : super(key: key);

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

class RolesDepsAndLoginOptionsWidget extends StatelessWidget {
  static const String title = "Roles, Department and Login Options";

  const RolesDepsAndLoginOptionsWidget({Key? key}) : super(key: key);

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
          width: dpWidth / 2,
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
