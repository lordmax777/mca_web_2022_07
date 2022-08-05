import '../theme/theme.dart';

class TableWrapperWidget extends StatelessWidget {
  final Widget child;
  const TableWrapperWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: ThemeColors.white,
          boxShadow: [
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
          ]),
      child: child,
    );
    return PhysicalModel(
      color: ThemeColors.white,
      elevation: 0.8,
      borderRadius: BorderRadius.circular(16.0),
      shadowColor: ThemeColors.black,
      child: child,
    );
  }
}
