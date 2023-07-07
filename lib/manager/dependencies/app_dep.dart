import 'package:flutter/cupertino.dart';
import 'package:mca_dashboard/presentation/theme/app_theme.dart';

class AppDep {
  //create singleton
  static final AppDep _singleton = AppDep._internal();

  //create factory constructor
  factory AppDep() {
    return _singleton;
  }

  //create private constructor
  AppDep._internal();

  //create getter for singleton
  static AppDep get instance => _singleton;

  /// runs setState of the MaterialApp
  late final VoidCallback restart;

  ///App theme
  final appTheme = AppTheme();
}
