import '../theme/theme.dart';

class ButtonMedium extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Color? bgColor;
  HeroIcon? icon;
  TextStyle? textStyle;

  ButtonMedium(
      {Key? key,
      this.onPressed,
      required this.text,
      this.icon,
      this.bgColor,
      this.textStyle})
      : super(key: key) {
    bgColor ??= ThemeColors.MAIN_COLOR;
    if (icon != null) {
      icon = HeroIcon(icon!.icon,
          size: icon!.size, color: icon!.color ?? ThemeColors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      mouseCursor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return SystemMouseCursors.forbidden;
        } else {
          return SystemMouseCursors.click;
        }
      }),
      padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return bgColor!.withOpacity(0.6);
        } else if (states.contains(MaterialState.hovered)) {
          return bgColor!.withOpacity(0.8);
        } else {
          return bgColor;
        }
      }),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return BorderSide(color: bgColor!, width: 4.0);
        } else {
          return const BorderSide(color: ThemeColors.gray11, width: 0.0);
        }
      }),
      elevation: MaterialStateProperty.all(0.0),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
    );
    if (icon != null) {
      return ElevatedButton.icon(
          style: style,
          onPressed: onPressed,
          icon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: icon!,
          ),
          label: KText(
            text: text,
            rowCenter: true,
            isSelectable: false,
            fontSize: 14,
            style: textStyle,
            fontWeight: FWeight.medium,
          ));
    }
    return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: KText(
          text: text,
          isSelectable: false,
          fontSize: 14,
          style: textStyle,
          fontWeight: FWeight.bold,
        ));
  }
}

class ButtonLarge extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Color? bgColor;
  HeroIcon? icon;
  final bool paddingWithoutIcon;

  ButtonLarge(
      {Key? key,
      this.onPressed,
      this.paddingWithoutIcon = false,
      required this.text,
      this.icon,
      this.bgColor})
      : super(key: key) {
    bgColor ??= ThemeColors.MAIN_COLOR;
    if (icon != null) {
      icon = HeroIcon(icon!.icon, size: icon!.size, color: ThemeColors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      mouseCursor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return SystemMouseCursors.forbidden;
        } else {
          return SystemMouseCursors.click;
        }
      }),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return bgColor!.withOpacity(0.6);
        } else if (states.contains(MaterialState.hovered)) {
          return bgColor!.withOpacity(0.9);
        } else {
          return bgColor;
        }
      }),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return BorderSide(color: bgColor!, width: 4.0);
        } else {
          return const BorderSide(color: ThemeColors.gray11, width: 0.0);
        }
      }),
      elevation: MaterialStateProperty.all(0.0),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
    );
    if (icon != null) {
      return ElevatedButton.icon(
          style: style,
          onPressed: onPressed,
          icon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: icon!,
          ),
          label: KText(
            text: text,
            rowCenter: true,
            isSelectable: false,
            fontSize: 16,
            fontWeight: FWeight.medium,
          ));
    }
    return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: Padding(
          padding:
              paddingWithoutIcon ? const EdgeInsets.all(6.0) : EdgeInsets.zero,
          child: KText(
            text: text,
            isSelectable: false,
            fontSize: 16,
            fontWeight: FWeight.bold,
          ),
        ));
  }
}

class ButtonSmall extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Color? bgColor;
  HeroIcon? icon;
  TextStyle? textStyle;

  ButtonSmall(
      {Key? key,
      this.onPressed,
      required this.text,
      this.icon,
      this.bgColor,
      this.textStyle})
      : super(key: key) {
    bgColor ??= ThemeColors.MAIN_COLOR;
    if (icon != null) {
      icon = HeroIcon(icon!.icon,
          size: icon!.size, color: icon!.color ?? ThemeColors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      mouseCursor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return SystemMouseCursors.forbidden;
        } else {
          return SystemMouseCursors.click;
        }
      }),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return ThemeColors.MAIN_COLOR.withOpacity(0.4);
        } else if (states.contains(MaterialState.pressed)) {
          return ThemeColors.MAIN_COLOR;
        } else if (states.contains(MaterialState.hovered)) {
          return ThemeColors.MAIN_COLOR;
        } else {
          return bgColor;
        }
      }),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return BorderSide(color: ThemeColors.MAIN_COLOR, width: 2.0);
        } else {
          return const BorderSide(color: ThemeColors.gray11, width: 0.0);
        }
      }),
      elevation: MaterialStateProperty.all(0.0),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
    );
    if (icon != null) {
      return ElevatedButton.icon(
          style: style,
          onPressed: onPressed,
          icon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: icon!,
          ),
          label: KText(
            text: text,
            isSelectable: false,
            fontSize: 12,
            style: textStyle,
            fontWeight: FWeight.medium,
          ));
    }
    return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: KText(
          text: text,
          isSelectable: false,
          fontSize: 12,
          style: textStyle,
          fontWeight: FWeight.medium,
        ));
  }
}

class ButtonMediumSecondary extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Color? bgColor;
  HeroIcon? leftIcon;

  ButtonMediumSecondary(
      {Key? key,
      this.onPressed,
      required this.text,
      this.leftIcon,
      this.bgColor})
      : super(key: key) {
    bgColor ??= ThemeColors.transparent;
    if (leftIcon != null) {
      leftIcon = HeroIcon(leftIcon!.icon,
          size: leftIcon!.size, color: ThemeColors.MAIN_COLOR.withOpacity(0.9));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      mouseCursor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return SystemMouseCursors.forbidden;
        } else {
          return SystemMouseCursors.click;
        }
      }),
      padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return ThemeColors.transparent;
        } else {
          return bgColor;
        }
      }),
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return BorderSide(color: ThemeColors.MAIN_COLOR, width: 2.0);
        } else if (states.contains(MaterialState.hovered)) {
          return BorderSide(color: ThemeColors.MAIN_COLOR, width: 1.0);
        } else {
          return const BorderSide(color: ThemeColors.gray11, width: 1.0);
        }
      }),
      elevation: MaterialStateProperty.all(0.0),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
    );
    if (leftIcon != null) {
      return ElevatedButton.icon(
          style: style,
          onPressed: onPressed,
          icon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: leftIcon!,
          ),
          label: KText(
            text: text,
            isSelectable: false,
            textColor: onPressed == null
                ? ThemeColors.MAIN_COLOR.withOpacity(0.4)
                : ThemeColors.MAIN_COLOR,
            fontSize: 14,
            fontWeight: FWeight.bold,
          ));
    }
    return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: KText(
          text: text,
          isSelectable: false,
          fontSize: 14,
          textColor: onPressed == null
              ? ThemeColors.MAIN_COLOR.withOpacity(0.4)
              : ThemeColors.MAIN_COLOR,
          fontWeight: FWeight.bold,
        ));
  }
}

class ButtonLargeSecondary extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Color? bgColor;
  HeroIcon? leftIcon;
  final bool paddingWithoutIcon;

  ButtonLargeSecondary(
      {Key? key,
      this.onPressed,
      this.paddingWithoutIcon = false,
      required this.text,
      this.leftIcon,
      this.bgColor})
      : super(key: key) {
    bgColor ??= ThemeColors.transparent;
    if (leftIcon != null) {
      leftIcon = HeroIcon(leftIcon!.icon,
          size: leftIcon!.size, color: ThemeColors.MAIN_COLOR.withOpacity(0.9));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      mouseCursor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return SystemMouseCursors.forbidden;
        } else {
          return SystemMouseCursors.click;
        }
      }),
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return ThemeColors.transparent;
        } else {
          return bgColor;
        }
      }),
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return BorderSide(color: ThemeColors.MAIN_COLOR, width: 2.0);
        } else if (states.contains(MaterialState.hovered)) {
          return BorderSide(color: ThemeColors.MAIN_COLOR, width: 1.0);
        } else {
          return const BorderSide(color: ThemeColors.gray11, width: 1.0);
        }
      }),
      elevation: MaterialStateProperty.all(0.0),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
    );
    if (leftIcon != null) {
      return ElevatedButton.icon(
          style: style,
          onPressed: onPressed,
          icon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: leftIcon!,
          ),
          label: KText(
            text: text,
            isSelectable: false,
            textColor: onPressed == null
                ? ThemeColors.MAIN_COLOR.withOpacity(0.4)
                : ThemeColors.MAIN_COLOR,
            fontSize: 16,
            fontWeight: FWeight.bold,
          ));
    }
    return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: Padding(
          padding:
              paddingWithoutIcon ? const EdgeInsets.all(6.0) : EdgeInsets.zero,
          child: KText(
            text: text,
            isSelectable: false,
            fontSize: 16,
            textColor: onPressed == null
                ? ThemeColors.MAIN_COLOR.withOpacity(0.4)
                : ThemeColors.MAIN_COLOR,
            fontWeight: FWeight.bold,
          ),
        ));
  }
}

class ButtonSmallSecondary extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Color? bgColor;
  HeroIcon? leftIcon;

  ButtonSmallSecondary(
      {Key? key,
      this.onPressed,
      required this.text,
      this.leftIcon,
      this.bgColor})
      : super(key: key) {
    bgColor ??= ThemeColors.transparent;
    if (leftIcon != null) {
      leftIcon = HeroIcon(leftIcon!.icon,
          size: leftIcon!.size, color: ThemeColors.MAIN_COLOR.withOpacity(0.9));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      mouseCursor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return SystemMouseCursors.forbidden;
        } else {
          return SystemMouseCursors.click;
        }
      }),
      padding: MaterialStateProperty.all(const EdgeInsets.all(8.0)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return ThemeColors.transparent;
        } else {
          return bgColor;
        }
      }),
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return BorderSide(color: ThemeColors.MAIN_COLOR, width: 2.0);
        } else if (states.contains(MaterialState.hovered)) {
          return BorderSide(color: ThemeColors.MAIN_COLOR, width: 1.0);
        } else {
          return const BorderSide(color: ThemeColors.gray11, width: 1.0);
        }
      }),
      elevation: MaterialStateProperty.all(0.0),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
    );
    if (leftIcon != null) {
      return ElevatedButton.icon(
          style: style,
          onPressed: onPressed,
          icon: Padding(
            padding: const EdgeInsets.all(6.0),
            child: leftIcon!,
          ),
          label: KText(
            text: text,
            isSelectable: false,
            textColor: onPressed == null
                ? ThemeColors.MAIN_COLOR.withOpacity(0.4)
                : ThemeColors.MAIN_COLOR,
            fontSize: 14,
            fontWeight: FWeight.bold,
          ));
    }
    return ElevatedButton(
        style: style,
        onPressed: onPressed,
        child: KText(
          text: text,
          isSelectable: false,
          fontSize: 14,
          textColor: onPressed == null
              ? ThemeColors.MAIN_COLOR.withOpacity(0.4)
              : ThemeColors.MAIN_COLOR,
          fontWeight: FWeight.bold,
        ));
  }
}
