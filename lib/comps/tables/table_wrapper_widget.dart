import '../../theme/theme.dart';

class TableWrapperWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool? enableShadow;

  const TableWrapperWidget(
      {Key? key, required this.child, this.padding, this.enableShadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: ThemeColors.white,
          boxShadow: enableShadow!
              ? [
                  BoxShadow(
                    color: ThemeColors.black.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: ThemeColors.black.withOpacity(0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  )
                ]
              : []),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: child,
        ),
      ),
    );
  }
}
