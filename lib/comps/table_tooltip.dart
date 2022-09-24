import '../theme/theme.dart';

class TableTooltipWidget extends StatelessWidget {
  final String title;
  final String message;
  const TableTooltipWidget(
      {Key? key, required this.title, required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      decoration: const BoxDecoration(color: ThemeColors.transparent),
      richMessage: TextSpan(children: [
        WidgetSpan(
            child: TableWrapperWidget(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              // height: 200.0,
              width: 300.0,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ThemeColors.gray12,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: ThemeColors.gray11),
              ),
              child: Text(message)),
        )),
      ]),
      child: KText(
        onTap: () {},
        text: title,
        textColor: ThemeColors.blue3,
        fontWeight: FWeight.regular,
        fontSize: 14,
        isSelectable: false,
        icon: const HeroIcon(
          HeroIcons.eye,
          color: ThemeColors.blue3,
        ),
      ),
    );
  }
}
