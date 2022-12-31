import '../theme/theme.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  const PageWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: Constants.defaultWidth,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: child,
        ),
      ),
    );
  }
}
