import 'dart:convert';

import '../app.dart';
import '../manager/general_controller.dart';
import '../pages/home.dart';
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
        width: Constants.defaultWidth(context),
        child: Row(
          children: [
            _LeadinBtn(scaffoldKey: Constants.scaffoldKey),
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
    Widget image = Image.asset('', errorBuilder: (context, error, stackTrace) {
      return const Center(child: Icon(Icons.error_outline));
    });

    image = Image.memory(base64Decode(companyImage),
        errorBuilder: (context, error, stackTrace) {
      return const Center(child: Icon(Icons.error_outline));
    });

    return CircleAvatar(
      backgroundColor: ThemeColors.white,
      child: image,
    );
  }

  Widget _getTitle() {
    final String companyTitle = GeneralController.to.companyInfo.name ?? "MCA";
    return KText(
        text: "$companyTitle ${Constants.appVersion}",
        fontSize: 18,
        isSelectable: false);
  }
}
