import '../theme/theme.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const PageWrapper({Key? key, required this.child, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: Constants.defaultWidth(context),
        child: SingleChildScrollView(
          padding:
              padding ?? const EdgeInsets.all(Constants.pagePaddingHorizontal),
          child: child,
        ),
      ),
    );
  }
}
