import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easylogger/flutter_logger.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Logger.init(kDebugMode,
      isShowFile: false, isShowTime: false, isShowNavigation: false);

  runApp(const McaWebApp());
}
