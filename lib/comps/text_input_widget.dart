import '../theme/theme.dart';

class TextInputWidget extends StatefulWidget {
  Color? defaultBorderColor;
  HeroIcons? rightIcon;
  HeroIcons? leftIcon;
  String? hintText;
  final TextEditingController? controller;
  double? width;
  double? heigth;
  final bool isRequired;
  final String? labelText;
  final VoidCallback? onTap;
  final bool enabled;
  final bool disableAll;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLines;
  TextInputWidget(
      {Key? key,
      this.defaultBorderColor,
      this.maxLines = 1,
      this.enabled = true,
      this.disableAll = false,
      this.controller,
      this.rightIcon,
      this.isRequired = false,
      this.isPassword = false,
      this.labelText,
      this.leftIcon,
      this.keyboardType = TextInputType.text,
      this.heigth,
      this.onTap,
      this.width,
      this.hintText})
      : super(key: key) {
    defaultBorderColor ??= ThemeColors.gray11;
    hintText ??= 'Enter your text';
    width ??= 300;
    heigth ??= 80;
  }

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: TextField(
        obscureText: widget.isPassword ? _obscureText : false,
        onTap: widget.onTap,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        mouseCursor: widget.disableAll
            ? SystemMouseCursors.forbidden
            : SystemMouseCursors.text,
        controller: widget.controller,
        readOnly: widget.disableAll || !widget.enabled,
        style: widget.disableAll
            ? ThemeText.md.copyWith(color: ThemeColors.gray8)
            : ThemeText.md.copyWith(color: ThemeColors.gray2),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide:
                  BorderSide(width: 1.0, color: widget.defaultBorderColor!)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(
                  width: 1.0,
                  color: widget.disableAll
                      ? ThemeColors.gray8
                      : ThemeColors.blue6)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: widget.labelText != null
              ? SpacedRow(
                  horizontalSpace: 4.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.labelText!,
                        style: ThemeText.regular.copyWith(
                            color: ThemeColors.gray8, fontSize: 16.0)),
                    if (widget.isRequired)
                      Text("*",
                          style: ThemeText.regular.copyWith(
                              color: ThemeColors.red3, fontSize: 16.0)),
                  ],
                )
              : null,
          suffixIcon: _getRightIcon(),
          suffixIconConstraints: const BoxConstraints(minWidth: 30.0),
          prefixIconConstraints: const BoxConstraints(minWidth: 40.0),
          suffixIconColor: ThemeColors.gray11,
          prefixIconColor: ThemeColors.gray11,
          prefixIcon: _getLeftIcon(),
          hintText: widget.hintText,
          filled: widget.disableAll,
          fillColor: ThemeColors.gray12,
          hintStyle: ThemeText.regular
              .apply(color: ThemeColors.gray8)
              .copyWith(fontSize: 16.0),
        ),
      ),
    );
  }

  Widget? _getRightIcon() {
    if (widget.isPassword) {
      return IconButton(
        icon: HeroIcon(
          !_obscureText ? HeroIcons.eye : HeroIcons.eyeClosed,
          color: ThemeColors.gray2,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    if (widget.rightIcon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: HeroIcon(
          widget.rightIcon!,
          size: 15,
          color: ThemeColors.gray8,
        ),
      );
    }
    return null;
  }

  Widget? _getLeftIcon() {
    if (widget.isPassword) {
      return const HeroIcon(
        HeroIcons.lock,
        size: 15,
        color: ThemeColors.gray2,
      );
    }
    if (widget.leftIcon != null) {
      return HeroIcon(
        widget.leftIcon!,
        size: 15,
        color: ThemeColors.gray8,
      );
    }
    return null;
  }
}
