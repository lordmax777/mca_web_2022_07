import 'package:flutter/services.dart';

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
  final bool disableAll;
  final bool isPassword;
  final TextInputType keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final VoidCallback? onRightIconClick;
  final String? Function(String?)? customValidator;
  final bool? isReadOnly;
  final String? tooltipOnDisabled;
  final List<TextInputFormatter> inputFormatters;
  TextInputWidget({
    Key? key,
    this.defaultBorderColor,
    this.customValidator,
    this.onRightIconClick,
    this.validator,
    this.maxLines = 1,
    this.disableAll = false,
    this.isReadOnly,
    this.tooltipOnDisabled,
    this.onChanged,
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
    this.hintText,
    this.inputFormatters = const [],
  }) : super(key: key) {
    defaultBorderColor ??= ThemeColors.gray10;
    hintText ??= 'Enter your text';
    width ??= 300;
  }

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  bool _obscureText = true;

  String? get tooltip => widget.disableAll ? widget.tooltipOnDisabled : null;

  String? Function(String?)? _getValidator() {
    if (widget.customValidator != null) {
      return widget.customValidator;
    }
    if (widget.disableAll) {
      return null;
    }
    if (widget.isRequired) {
      if (widget.validator != null) {
        return widget.validator;
      }
      return (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      };
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        margin: const EdgeInsets.only(top: 7),
        width: widget.width,
        height: widget.heigth,
        alignment: Alignment.center,
        child: TextFormField(
          onChanged: widget.onChanged,
          validator: _getValidator(),
          obscureText: widget.isPassword ? _obscureText : false,
          onTap: widget.disableAll ? null : widget.onTap,
          keyboardType: widget.keyboardType,
          maxLines: widget.maxLines,
          mouseCursor: widget.disableAll
              ? SystemMouseCursors.forbidden
              : (widget.isReadOnly ?? false)
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.text,
          controller: widget.controller,
          readOnly: widget.isReadOnly ?? widget.disableAll,
          cursorColor: ThemeColors.MAIN_COLOR,
          inputFormatters: widget.inputFormatters,
          style: widget.disableAll
              ? ThemeText.md.copyWith(color: ThemeColors.gray8)
              : ThemeText.bold14.copyWith(color: ThemeColors.gray2),
          decoration: InputDecoration(
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ThemeColors.red3, width: 1.0),
              borderRadius: BorderRadius.circular(16.0),
            ),
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
                        : ThemeColors.MAIN_COLOR)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
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
