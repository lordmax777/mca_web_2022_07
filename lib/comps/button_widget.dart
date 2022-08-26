import '../theme/theme.dart';

class ButtonMedium extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Color? bgColor;
  HeroIcon? icon;
  ButtonMedium(
      {Key? key, this.onPressed, required this.text, this.icon, this.bgColor})
      : super(key: key) {
    bgColor ??= ThemeColors.blue3;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return ThemeColors.blue3.withOpacity(0.4);
        } else if (states.contains(MaterialState.pressed)) {
          return ThemeColors.blue3;
        } else if (states.contains(MaterialState.hovered)) {
          return ThemeColors.blue6;
        } else {
          return bgColor;
        }
      }),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return const BorderSide(color: ThemeColors.blue10, width: 4.0);
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
          fontWeight: FWeight.bold,
        ));
  }
}

class ButtonSmall extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  Color? bgColor;
  HeroIcon? icon;
  ButtonSmall(
      {Key? key, this.onPressed, required this.text, this.icon, this.bgColor})
      : super(key: key) {
    bgColor ??= ThemeColors.blue3;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
      padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return ThemeColors.blue3.withOpacity(0.4);
        } else if (states.contains(MaterialState.pressed)) {
          return ThemeColors.blue3;
        } else if (states.contains(MaterialState.hovered)) {
          return ThemeColors.blue6;
        } else {
          return bgColor;
        }
      }),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      splashFactory: NoSplash.splashFactory,
      side: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.pressed)) {
          return const BorderSide(color: ThemeColors.blue10, width: 2.0);
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
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
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
          return const BorderSide(color: ThemeColors.blue3, width: 2.0);
        } else if (states.contains(MaterialState.hovered)) {
          return const BorderSide(color: ThemeColors.blue6, width: 1.0);
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
                ? ThemeColors.blue3.withOpacity(0.4)
                : ThemeColors.blue3,
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
              ? ThemeColors.blue3.withOpacity(0.4)
              : ThemeColors.blue3,
          fontWeight: FWeight.bold,
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
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ButtonStyle(
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
          return const BorderSide(color: ThemeColors.blue3, width: 2.0);
        } else if (states.contains(MaterialState.hovered)) {
          return const BorderSide(color: ThemeColors.blue6, width: 1.0);
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
                ? ThemeColors.blue3.withOpacity(0.4)
                : ThemeColors.blue3,
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
              ? ThemeColors.blue3.withOpacity(0.4)
              : ThemeColors.blue3,
          fontWeight: FWeight.bold,
        ));
  }
}
