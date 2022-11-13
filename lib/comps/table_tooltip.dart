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
        if (message.isNotEmpty)
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
          ))
        else
          WidgetSpan(
              child: TableWrapperWidget(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              // height: 200.0,
              width: 300.0,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ThemeColors.gray11,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: ThemeColors.gray11),
              ),
              child: const Text("NO COMMENT"),
            ),
          ))
      ]),
      child: KText(
        onTap: () {},
        text: title,
        textColor: ThemeColors.MAIN_COLOR,
        fontWeight: FWeight.regular,
        fontSize: 14,
        isSelectable: false,
        icon:  HeroIcon(
          HeroIcons.eye,
          color: ThemeColors.MAIN_COLOR,
        ),
      ),
    );
  }
}

class TableTooltipWidget1 extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const TableTooltipWidget1(
      {Key? key, required this.title, required this.children})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      decoration: const BoxDecoration(color: ThemeColors.transparent),
      richMessage: TextSpan(children: [
        if (children.isNotEmpty)
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
                child: SpacedColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  verticalSpace: 1.0,
                  children: children,
                )),
          ))
        else
          WidgetSpan(
              child: TableWrapperWidget(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              // height: 200.0,
              width: 300.0,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: ThemeColors.gray11,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: ThemeColors.gray11),
              ),
              child: const Text("NO COMMENT"),
            ),
          ))
      ]),
      child: KText(
        onTap: () {},
        text: title,
        textColor: ThemeColors.MAIN_COLOR,
        fontWeight: FWeight.regular,
        fontSize: 14,
        isSelectable: false,
        icon:  HeroIcon(
          HeroIcons.eye,
          color: ThemeColors.MAIN_COLOR,
        ),
      ),
    );
  }
}
