import '../../theme/theme.dart';

class SettingsColorThemeWidget extends StatelessWidget {
  final Color? color;
  const SettingsColorThemeWidget({Key? key, this.color = ThemeColors.blue4})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return customContainer();
  }

  Widget customContainer() {
    return Container(
        width: 400,
        height: 230,
        decoration: BoxDecoration(
          color: ThemeColors.gray12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SpacedColumn(verticalSpace: 16.0, children: [
          headerBox(),
          middleBox(),
        ]));
  }

  Widget headerBox() {
    return Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
            color: color,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: SpacedRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpacedRow(
                  horizontalSpace: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    roundBox(),
                    lineBox(),
                  ]),
              SpacedRow(
                  horizontalSpace: 10,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [roundBox(), roundBox()])
            ]));
  }

  Widget middleBox() {
    return Container(
      width: 370,
      height: 160,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: ThemeColors.black.withOpacity(0.2),
            offset: const Offset(0, 1),
            blurRadius: 4)
      ], color: ThemeColors.white, borderRadius: BorderRadius.circular(10)),
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalSpace: 10,
        children: [
          SpacedRow(
            horizontalSpace: 10,
            children: [
              lineBox(color: ThemeColors.gray11, width: 70),
              lineBox(color: ThemeColors.gray11, width: 70),
            ],
          ),
          SpacedRow(
            horizontalSpace: 10,
            children: [
              lineBox(
                  color: ThemeColors.gray11, width: 70, height: 50, radius: 10),
              lineBox(
                  color: ThemeColors.gray11,
                  width: 250,
                  height: 50,
                  radius: 10),
            ],
          ),
          SpacedRow(
            horizontalSpace: 10,
            children: [
              lineBox(color: ThemeColors.white, width: 70),
              lineBox(
                  color: ThemeColors.gray11,
                  width: 250,
                  height: 30,
                  radius: 10),
            ],
          ),
          SpacedRow(
            horizontalSpace: 10,
            children: [
              lineBox(color: ThemeColors.white, width: 250),
              lineBox(color: color, height: 16, width: 70),
            ],
          ),
        ],
      ),
    );
  }

  Widget roundBox() {
    return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
            color: ThemeColors.white, borderRadius: BorderRadius.circular(20)));
  }

  Widget lineBox(
      {Color? color, double? height, double? width, double? radius}) {
    return Container(
        width: width ?? 50,
        height: height ?? 10,
        decoration: BoxDecoration(
            color: color ?? ThemeColors.white,
            borderRadius: BorderRadius.circular(radius ?? 20)));
  }
}
