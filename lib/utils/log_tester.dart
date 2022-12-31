import 'dart:convert';

import 'package:flutter/foundation.dart';

logger(var str, {String? hint, bool json = false}) {
  if (kDebugMode) {
    debugPrint(hint ?? 'LOGGER');
    if (json) {
      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      debugPrint(encoder.convert(str));
    } else {
      debugPrint(str.toString());
    }
    debugPrint(hint ?? 'LOGGER');
  }
}
