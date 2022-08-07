import 'package:mca_web_2022_07/app.dart';

import '../theme/theme.dart';

class PageGobackWidget extends StatelessWidget {
  final String text;
  const PageGobackWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpacedRow(
      horizontalSpace: 16.0,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const HeroIcon(
            HeroIcons.arrowLeft,
            size: 32.0,
          ),
          onPressed: () => appRouter.navigateBack(),
        ),
        KText(
            text: text,
            fontWeight: FWeight.bold,
            isSelectable: true,
            fontSize: 24.0,
            textColor: ThemeColors.black),
      ],
    );
  }
}
