import '../theme/theme.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  const PageWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: Constants.defaultWidth(context),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Constants.pagePaddingHorizontal),
          child: child,
        ),
      ),
    );
  }
}
