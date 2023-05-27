import '../theme/theme.dart';

class CustomLoadingWidget extends StatelessWidget {
  final VoidCallback? onClose;
  const CustomLoadingWidget({Key? key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: SpacedColumn(
        mainAxisSize: MainAxisSize.min,
        verticalSpace: 16,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 6,
            backgroundColor: Colors.white,
          ),
          if (onClose != null)
            TextButton(
                onPressed: onClose!,
                style: TextButton.styleFrom(
                    backgroundColor: ThemeColors.MAIN_COLOR,
                    side: const BorderSide(color: Colors.white),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}
