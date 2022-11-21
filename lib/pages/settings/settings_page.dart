import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../comps/custom_get_builder.dart';
import '../../comps/show_overlay_popup.dart';
import '../../manager/models/list_all_md.dart';
import '../../manager/redux/sets/app_state.dart';
import '../../theme/theme.dart';
import '../handover_types/controllers/handover_controller.dart';
import 'controllers/settings_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (_, state) => PageWrapper(
              child: SpacedColumn(verticalSpace: 16.0, children: [
                const PagesTitleWidget(title: 'Settings'),
                ErrorWrapper(
                    errors: [state.generalState.paramList.error],
                    child: const _Body())
              ]),
            ));
  }
}

class _Body extends GetView<SettingsController> {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fullScreen = MediaQuery.of(context).size.width;

    return Obx(() => TableWrapperWidget(
          child: SpacedRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 240,
                  child: SpacedRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _sideBar(context),
                        Container(
                            width: 1, height: 800, color: ThemeColors.gray11)
                      ]),
                ),
                SizedBox(
                    width: fullScreen - 350,
                    child: SpacedColumn(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        verticalSpace: 16.0,
                        children: [
                          _body(context),
                          const Divider(
                              color: ThemeColors.gray11,
                              height: 1.0,
                              thickness: 1.0),
                          Align(
                              alignment: Alignment.centerRight,
                              child: ButtonLarge(
                                icon: const HeroIcon(HeroIcons.check),
                                text: controller.settingState
                                        .toLowerCase()
                                        .contains("password")
                                    ? "Update Password"
                                    : 'Save Changes',
                                onPressed: () {},
                              ))
                        ])),
              ]),
        ));
  }

  Widget _sideBar(
    BuildContext context,
  ) {
    List<Widget> settingsMenuWidgets = [];

    for (int i = 0; i < controller.settingsMenus.length; i++) {
      settingsMenuWidgets.add(Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // update in controller
            controller.updateSettingsState(i);
          },
          child: Container(
              width: 200,
              height: 48,
              color: controller.settingState == controller.settingsMenus[i]
                  ? ThemeColors.blue12
                  : Colors.transparent,
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: KText(
                      isSelectable: false,
                      text: controller.settingsMenus[i],
                      fontSize: 16.0,
                      textColor:
                          controller.settingState == controller.settingsMenus[i]
                              ? ThemeColors.blue3
                              : ThemeColors.black))),
        ),
      ));
    }

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            SpacedColumn(verticalSpace: 16.0, children: settingsMenuWidgets));
  }

  Widget _body(BuildContext context) {
    String settingState =
        controller.settingState.removeAllWhitespace.toLowerCase();

    if (settingState.contains("account")) {
      return _accountBody(context);
    } else if (settingState.contains("password")) {
      return _changePassBody(context);
    } else if (settingState.contains("login")) {
      return _loginAndStatusBody(context);
    } else if (settingState.contains("holidays")) {
      return _holidaysAndSickBody(context);
    } else if (settingState.contains("shift")) {
      return _shiftBody(context);
    } else if (settingState.contains("color")) {
      return _colorThemeBody(context);
    } else {
      return _companyBody(context);
    }
  }

  Widget _companyBody(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width / 3.5;

    return SizedBox(
      height: 700,
      child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalSpace: 32.0,
          children: [
            TextInputWidget(
                isRequired: true,
                disableAll: true,
                width: dpWidth,
                labelText: "Your Domain *",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                }),
            TextInputWidget(
                isRequired: true,
                width: dpWidth,
                labelText: "Company Name *",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                }),
            uploadCompanyLogo(context),
            TextInputWidget(
                isRequired: true,
                width: dpWidth,
                labelText: "Time Zone",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                }),
            TextInputWidget(
                isRequired: true,
                width: dpWidth,
                labelText: "Language",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                }),
            TextInputWidget(
                isRequired: true,
                width: dpWidth,
                labelText: "Currency",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                })
          ]),
    );
  }

  Widget _accountBody(BuildContext context) {
    return SizedBox();
  }

  Widget _changePassBody(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width / 3.5;

    return SizedBox(
        height: 700,
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalSpace: 32.0,
          children: [
            TextInputWidget(
                isRequired: true,
                labelText: "Current Password *",
                isPassword: true,
                width: dpWidth,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                }),
            TextInputWidget(
                isRequired: true,
                labelText: "New Password *",
                isPassword: true,
                width: dpWidth,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                }),
            TextInputWidget(
                isRequired: true,
                labelText: "Repeat Password *",
                isPassword: true,
                width: dpWidth,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                }),
          ],
        ));
  }

  Widget _loginAndStatusBody(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width / 3.5;

    return SizedBox(
        height: 700,
        child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            verticalSpace: 32.0,
            children: [
              inputWithTextHelper(
                  labelText: "Login Attempts Allowed *",
                  bottomText: "Default: 3",
                  dpWidth: dpWidth),
              inputWithTextHelper(
                  labelText: "Lock Time After Failed Login (Minutes) *",
                  bottomText: "Default: 5 minutes",
                  dpWidth: dpWidth),
              inputWithTextHelper(
                labelText: "Auto Logout (Minutes) *",
                bottomText: "Default: 5 minutes",
                dpWidth: dpWidth,
                checkText: "Photo Required with Мobile",
                checkValue: false,
                onChanged: (value) {
                  print(value);
                },
              ),
              inputWithTextHelper(
                labelText: "Undo TIme After Status Change (Seconds) *",
                bottomText: "",
                dpWidth: dpWidth,
                checkText: "Strict Location at Status Change",
                checkValue: false,
                onChanged: (value) {
                  print(value);
                },
              ),
            ]));
  }

  Widget _holidaysAndSickBody(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width / 3.5;

    return SizedBox(
        height: 700,
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalSpace: 32.0,
          children: [
            TextInputWidget(
              isRequired: true,
              width: dpWidth,
              disableAll: false,
              labelText: "Year Start",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter a value";
                }
              },
              leftIcon: HeroIcons.calendar,
              onTap: () async {
                DateTime? val = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015),
                  lastDate: DateTime(2035),
                );
              },
            ),
            DropdownWidget(
              hintText: "Holiday Calculation Type *",
              isRequired: true,
              dropdownBtnWidth: dpWidth,
              onChanged: (val) {},
              items: const [
                "Basic",
                "Premium",
                "Enterprise",
              ],
            ),
            inputWithTextHelper(
              dpWidth: dpWidth,
              bottomText: "Default: 5.6 Weeks",
              labelText: "Annual Holiday Entitlement (Weeks) *",
            ),
            inputWithTextHelper(
              dpWidth: dpWidth,
              bottomText: "Default: 3 Days",
              labelText: "SSP Waiting Days *",
            ),
            inputWithTextHelper(
              dpWidth: dpWidth,
              bottomText: "Default: 8 Weeks",
              labelText: "SSP Link Period of Incapacity for Work (Weeks) *",
            ),
          ],
        ));
  }

  Widget _shiftBody(BuildContext context) {
    return SizedBox();
  }

  Widget _colorThemeBody(BuildContext context) {
    final dpWidth = MediaQuery.of(context).size.width / 3.5;

    return SizedBox(
        height: 700,
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalSpace: 32.0,
          children: [
            const SizedBox(height: 32),
            Image.asset(
              "assets/images/widget_temp_mca.jpg",
              width: dpWidth,
            ),
            DropdownWidget(
              hintText: "Color Theme",
              dropdownBtnWidth: dpWidth,
              onChanged: (val) {},
              items: const [
                "Blue (High Contrast)",
                "Blue (High Contrast)",
                "Blue (High Contrast)",
              ],
            ),
          ],
        ));
  }

  Widget uploadCompanyLogo(BuildContext context) {
    return DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        dashPattern: const [5, 5],
        color: ThemeColors.gray11,
        padding: const EdgeInsets.all(6),
        child: SizedBox(
            width: MediaQuery.of(context).size.width / 3.5,
            child: SpacedColumn(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalSpace: 16.0,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const HeroIcon(HeroIcons.upload, size: 30)),
                  KText(
                      isSelectable: false,
                      text: "Drop your files or click to upload",
                      fontWeight: FWeight.bold,
                      textColor: ThemeColors.black,
                      fontSize: 16.0),
                  KText(
                      isSelectable: false,
                      text: "Supported file types: PNG, JPEG, GIF",
                      fontWeight: FWeight.regular,
                      textColor: ThemeColors.gray5,
                      fontSize: 14.0),
                  ButtonLargeSecondary(text: "Browse", onPressed: () {}),
                  const SizedBox()
                ])));
  }

  Widget inputWithTextHelper({
    required String labelText,
    required double dpWidth,
    required String bottomText,
    String? checkText,
    bool? checkValue,
    ValueChanged<bool?>? onChanged,
  }) {
    return SizedBox(
      width: dpWidth,
      child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextInputWidget(
                isRequired: true,
                labelText: labelText,
                width: dpWidth,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a name";
                  }
                  return null;
                }),
            KText(
                text: bottomText,
                textColor: ThemeColors.gray8,
                textAlign: TextAlign.left,
                fontWeight: FWeight.medium),
            if (checkValue != null && onChanged != null && checkText != null)
              const SizedBox(height: 32),
            if (checkValue != null && onChanged != null && checkText != null)
              SpacedRow(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  horizontalSpace: 8.0,
                  children: [
                    CheckboxWidget(
                      value: checkValue,
                      onChanged: onChanged,
                    ),
                    KText(
                        text: checkText,
                        isSelectable: false,
                        fontSize: 14.0,
                        fontWeight: FWeight.bold,
                        textColor: ThemeColors.gray2)
                  ]),
          ]),
    );
  }
}
