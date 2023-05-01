import 'package:get/get.dart';

import '../pages/scheduling/scheduling_page.dart';
import '../theme/theme.dart';

class TitleContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onEdit;
  const TitleContainer(
      {Key? key, required this.title, required this.child, this.onEdit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return titleWithDivider(
      titleIcon: onEdit != null
          ? addIcon(
              tooltip: "Edit $title",
              onPressed: onEdit,
              icon: HeroIcons.edit,
            )
          : null,
      title,
      Container(
          width: 410,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.withOpacity(.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child),
    );
  }

  Widget titleWithDivider(String? title, Widget? child, {Widget? titleIcon}) {
    return SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            SpacedRow(
              crossAxisAlignment: CrossAxisAlignment.center,
              horizontalSpace: 6,
              children: [
                KText(
                  text: title,
                  fontSize: 24,
                  textColor: ThemeColors.gray2,
                  fontWeight: FWeight.bold,
                ),
                if (titleIcon != null) titleIcon,
              ],
            ),
          if (title != null)
            Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                width: MediaQuery.of(Get.context!).size.width * .22,
                height: 1,
                color: ThemeColors.gray2),
          if (child != null) child,
        ]);
  }
}
