import '../../theme/theme.dart';

Future<DateTime?> showCustomDatePicker(
  BuildContext context, {
  DateTime? initialTime,
}) {
  return showDatePicker(
    context: context,
    initialDate: initialTime ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2030),
    cancelText: "Close".toUpperCase(),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.light(primary: ThemeColors.MAIN_COLOR)),
        child: child!,
      );
    },
  );
}
