import 'package:flutter/foundation.dart';

logger(var str, {String? hint}) {
  if (kDebugMode) {
    debugPrint(hint ?? 'LOGGER');
    debugPrint(str.toString());
    debugPrint(hint ?? 'LOGGER');
  }
}
