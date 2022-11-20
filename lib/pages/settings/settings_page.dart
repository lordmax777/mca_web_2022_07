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

    return TableWrapperWidget(
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
                    Container(width: 1, height: 800, color: ThemeColors.gray11)
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
                            text: 'Save Changes',
                            onPressed: () {},
                          ))
                    ])),
          ]),
    );
  }

  Widget _sideBar(
    BuildContext context,
  ) {
    List<String> settingsMenus = Constants.settingsSection.values.toList();

    List<Widget> settingsMenuWidgets = [];

    for (int i = 0; i < settingsMenus.length; i++) {
      settingsMenuWidgets.add(Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // c.selectedMenu.value = i;
          },
          child: Container(
              width: 200,
              height: 48,
              // color: ThemeColors.blue12,
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: KText(
                      isSelectable: false,
                      text: settingsMenus[i],
                      fontSize: 16.0,
                      textColor: ThemeColors.black))),
        ),
      ));
    }

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            SpacedColumn(verticalSpace: 16.0, children: settingsMenuWidgets));
  }

  Widget _body(BuildContext context) {
    return SpacedColumn(children: [_buildAccountSec(context)]);
  }

  Widget _buildAccountSec(BuildContext context) {
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
}
