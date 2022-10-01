import '../theme/theme.dart';

class PagesTitleWidget extends StatelessWidget {
  final String title;
  final String? btnText;
  final VoidCallback? onRightBtnClick;
  const PagesTitleWidget(
      {Key? key, required this.title, this.btnText, this.onRightBtnClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KText(
          text: title,
          fontSize: 24,
          fontWeight: FWeight.bold,
          isSelectable: false,
          textColor: ThemeColors.gray1,
        ),
        if (onRightBtnClick != null)
          ButtonMedium(
            text: btnText ?? "New User",
            icon: const HeroIcon(
              HeroIcons.plusCircle,
              size: 20,
            ),
            onPressed: onRightBtnClick,
          ),
      ],
    );
  }
}
