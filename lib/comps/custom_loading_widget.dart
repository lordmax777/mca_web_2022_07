import '../theme/theme.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 8,
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(
            ThemeColors.MAIN_COLOR.withOpacity(0.8)),
        color: ThemeColors.MAIN_COLOR,
      ),
    );
  }
}
