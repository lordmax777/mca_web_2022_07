import 'package:mca_web_2022_07/theme/theme.dart';

extension DateTimeExtensions on DateTime {
  String get formattedDate => "${this.day}/${this.month}/${this.year}";
}

int? toIntOrNull(String? value) {
  if (value == null) return null;
  return int.tryParse(value);
}
