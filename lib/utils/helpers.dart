import 'package:mca_web_2022_07/theme/theme.dart';

extension DateTimeExtensions on DateTime {
  String get formattedDate => "$day/$month/$year";
}

int? toIntOrNull(String? value) {
  if (value == null) return null;
  return int.tryParse(value);
}

extension TextEditingControllerExtensions on TextEditingController {
  int? toInt() {
    return toIntOrNull(text);
  }
}
