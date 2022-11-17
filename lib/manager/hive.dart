import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils/log_tester.dart';

class HiveController extends GetxController {
  static HiveController get to => Get.find();
  static const String userBox = 'userBox';
  static const String userAccessToken = 'userAccessToken';
  static const String userRefreshToken = 'userRefreshToken';

  bool get isUserLoggedIn {
    logger("AuthGuard: isLoggedIn: ${getRefreshToken() != null}");
    return getRefreshToken() != null;
  }

  String? getAccessToken() {
    final Box box = Hive.box(userBox);
    final String? token = box.get(userAccessToken);
    Logger.i("HIVE: getAccessToken: $token");
    return token;
  }

  Future<void> setAccessToken(String token) async {
    final Box box = Hive.box(userBox);
    await box.put(userAccessToken, token);
    Logger.d("HIVE: setAccessToken: $token");
  }

  Future<void> deleteAccessToken() async {
    final Box box = Hive.box(userBox);
    await box.delete(userAccessToken);
    Logger.e("HIVE: deleteAccessToken");
  }

  String? getRefreshToken() {
    final Box box = Hive.box(userBox);
    final String? token = box.get(userRefreshToken);
    Logger.i("HIVE: getRefreshToken: $token");
    return token;
  }

  Future<void> setRefreshToken(String token) async {
    final Box box = Hive.box(userBox);
    await box.put(userRefreshToken, token);
    Logger.d("HIVE: setRefreshToken: $token");
  }

  void deleteRefreshToken() {
    final Box box = Hive.box(userBox);
    box.delete(userRefreshToken);
    Logger.e("HIVE: deleteRefreshToken");
  }

  static Future<void> initHive() async {
    int step = 1;

    Logger.d('[STEP: $step] - Running initFlutter');
    await Hive.initFlutter();
    step++;
    Logger.d('[STEP: $step] - Running Open Box $userBox');
    await Hive.openBox(userBox);
    step++;
  }
}
