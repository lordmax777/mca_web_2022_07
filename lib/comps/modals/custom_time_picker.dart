import '../../theme/theme.dart';

Future<TimeOfDay?> showCustomTimePicker(
  BuildContext context, {
  TimeOfDay initialTime = const TimeOfDay(hour: 0, minute: 0),
}) {
  return showTimePicker(
    context: context,
    initialTime: initialTime,
    cancelText: "Clear/Close".toUpperCase(),
    builder: (context, child) {
      return Theme(
        data: ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: ColorScheme.light(primary: ThemeColors.MAIN_COLOR)),
        child: child!,
      );
    },
  );
}
