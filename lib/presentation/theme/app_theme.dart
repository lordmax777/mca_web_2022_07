import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class AppTheme {
  final defaultTheme = ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        accentColor: Colors.blueAccent,
        errorColor: Colors.redAccent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            }
            return Colors.blueAccent;
          }),
          foregroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.black54;
            }
            return Colors.white;
          }),
        ),
      ),
      textTheme: GoogleFonts.nunitoTextTheme(),
      dividerColor: Colors.grey,
      scrollbarTheme: ScrollbarThemeData(
        thumbVisibility: MaterialStatePropertyAll(true),
        trackVisibility: MaterialStatePropertyAll(true),
        trackColor: MaterialStatePropertyAll(Colors.grey.shade300),
        thumbColor: MaterialStatePropertyAll(Colors.blue.shade300),
        radius: const Radius.circular(8),
        crossAxisMargin: 2,
        mainAxisMargin: 2,
        minThumbLength: 30,
        thickness: MaterialStatePropertyAll(6),
        interactive: true,
      ));

  ThemeData? _theme;

  ThemeData get theme => _theme ?? defaultTheme;

  set theme(ThemeData theme) {
    debugPrint("set theme");
    _theme = theme;
    debugPrint("set theme");
  }
}
