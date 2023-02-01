import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../manager/talker_controller.dart';

logger(var str, {String? hint, bool json = false}) {
  final talker = TalkerController.to.talker;
  if (kDebugMode) {
    if (TalkerController.to.isTalkerReady) {
      talker.log(hint != null ? "-----$hint------" : '-------');
      if (json) {
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        talker.log(encoder.convert(str));
      } else {
        talker.log(str.toString());
      }
      talker.log(hint != null ? "-----$hint------" : '-------');
    } else {
      debugPrint(hint != null ? "-----$hint------" : '-------');
      if (json) {
        JsonEncoder encoder = const JsonEncoder.withIndent('  ');
        debugPrint(encoder.convert(str));
      } else {
        debugPrint(str.toString());
      }
      debugPrint(hint != null ? "-----$hint------" : '-------');
    }
  }
}
