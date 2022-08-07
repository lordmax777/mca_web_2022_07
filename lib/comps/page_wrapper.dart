import '../theme/theme.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  const PageWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
        child: child,
      ),
    );
  }
}
