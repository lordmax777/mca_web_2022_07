import 'dart:convert';

import '../app.dart';
import '../manager/general_controller.dart';
import '../pages/home_page.dart';
import '../theme/theme.dart';

class NavbarWidget extends StatelessWidget with PreferredSizeWidget {
  NavbarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: double.infinity,
      alignment: Alignment.center,
      color: ThemeColors.MAIN_COLOR,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: Constants.defaultWidth,
        child: Row(
          children: [
            _LeadinBtn(scaffoldKey: scaffoldKey),
            const SizedBox(width: 20),
            const Expanded(
              child: _Title(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 64);
}

class _LeadinBtn extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  _LeadinBtn({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(0),
      onPressed: _onTap,
      icon: const HeroIcon(HeroIcons.menu, size: 24, color: ThemeColors.white),
    );
  }

  void _onTap() {
    if (scaffoldKey.currentState != null) {
      if (!scaffoldKey.currentState!.isDrawerOpen) {
        scaffoldKey.currentState!.openDrawer();
      }
    }
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => appRouter.navigateBack(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _getLogo(),
              const SizedBox(width: 15),
              _getTitle(),
            ],
          ),
          Row(
            children: const [
              //TODO: Add Notification icon, message icon and avatar
            ],
          )
        ],
      ),
    );
  }

  Widget _getLogo() {
    final companyImage = GeneralController.to.companyInfo.logo;
    Widget image = Image.asset('assets/images/mca-logo.png');

    if (companyImage != null) {
      image = Image.memory(base64Decode(companyImage));
    }

    return CircleAvatar(
      backgroundColor: ThemeColors.white,
      child: image,
    );
  }

  Widget _getTitle() {
    final String companyTitle = GeneralController.to.companyInfo.name ?? "MCA";
    return KText(text: companyTitle, fontSize: 18, isSelectable: false);
  }
}
