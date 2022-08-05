import '../theme/theme.dart';

class TextInputWidget extends StatelessWidget {
  Color? defaultBorderColor;
  HeroIcons? rightIcon;
  HeroIcons? leftIcon;
  String? hintText;
  final TextEditingController? controller;
  double? width;
  double? heigth;
  TextInputWidget(
      {Key? key,
      this.defaultBorderColor,
      this.controller,
      this.rightIcon,
      this.leftIcon,
      this.heigth,
      this.width,
      this.hintText})
      : super(key: key) {
    defaultBorderColor ??= const Color(0xFFF1F1F1);
    hintText ??= 'Enter your text';
    width ??= 300;
    heigth ??= 80;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      // height: heigth,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(width: 1.0, color: defaultBorderColor!)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide:
                  const BorderSide(width: 1.0, color: ThemeColors.blue6)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: rightIcon != null
              ? HeroIcon(
                  rightIcon!,
                  size: 15,
                )
              : null,
          suffixIconConstraints: const BoxConstraints(minWidth: 30.0),
          prefixIconConstraints: const BoxConstraints(minWidth: 40.0),
          suffixIconColor: ThemeColors.gray11,
          prefixIconColor: ThemeColors.gray11,
          prefixIcon: leftIcon != null
              ? HeroIcon(
                  leftIcon!,
                  size: 15,
                )
              : null,
          hintText: hintText,
        ),
      ),
    );
  }
}
