import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mca_web_2022_07/manager/talker_controller.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../utils/log_tester.dart';

class HiveController extends GetxController {
  static HiveController get to => Get.find();
  static const String userBox = 'userBox';
  static const String dbBox = 'dbBox';
  static const String userAccessToken = 'userAccessToken';
  static const String userRefreshToken = 'userRefreshToken';
  static const String dbVersion = 'dbVersion';

  Talker get talker => TalkerController.to.talker;

  final int appDbVersion = Constants.mj + Constants.mn + Constants.up;

  ///////////USER BOX START //////////////////
  bool get isUserLoggedIn {
    logger("AuthGuard: isLoggedIn: ${getRefreshToken() != null}");
    return getRefreshToken() != null;
  }

  String? getAccessToken() {
    final Box box = Hive.box(userBox);
    final String? token = box.get(userAccessToken);
    talker.good("HIVE: getAccessToken: $token");
    return token;
  }

  Future<void> setAccessToken(String token) async {
    final Box box = Hive.box(userBox);
    await box.put(userAccessToken, token);
    talker.info("HIVE: setAccessToken: $token");
  }

  Future<void> deleteAccessToken() async {
    final Box box = Hive.box(userBox);
    await box.delete(userAccessToken);
    talker.error("HIVE: deleteAccessToken");
  }

  String? getRefreshToken() {
    final Box box = Hive.box(userBox);
    final String? token = box.get(userRefreshToken);
    talker.good("HIVE: getRefreshToken: $token");
    return token;
  }

  Future<void> setRefreshToken(String token) async {
    final Box box = Hive.box(userBox);
    await box.put(userRefreshToken, token);
    talker.info("HIVE: setRefreshToken: $token");
  }

  Future<void> deleteRefreshToken() async {
    final Box box = Hive.box(userBox);
    await box.delete(userRefreshToken);
    talker.error("HIVE: deleteRefreshToken");
  }

  Future<void> deleteTokens() async {
    await deleteAccessToken();
    await deleteRefreshToken();
    talker.error("HIVE: deleteTokens");
  }
  ///////////USER BOX END //////////////////

  ///////////DB BOX START //////////////////

  int getDbVersion() {
    final Box<int> box = Hive.box<int>(dbBox);
    final int ver = box.get(dbVersion, defaultValue: 1)!;
    talker.good("HIVE: oldBbVersion: $ver");
    talker.good("HIVE: appDbVersion: $appDbVersion");
    return ver;
  }

  Future<void> setAppDbVersion() async {
    final Box<int> box = Hive.box<int>(dbBox);
    await box.put(dbVersion, appDbVersion);
    talker.info("HIVE: setAppDbVersion: ${getDbVersion()}");
    talker.info("HIVE: setAppDbVersion: $appDbVersion");
  }

  ///////////DB BOX END //////////////////

  static Future<void> initHive() async {
    int step = 1;
    final t = TalkerController.to.talker;
    t.info('[STEP: $step] - Running initFlutter');
    await Hive.initFlutter();
    step++;
    t.info('[STEP: $step] - Running Open Box $userBox');
    await Hive.openBox(userBox);
    step++;
    t.info('[STEP: $step] - Running Open Box $dbBox');
    await Hive.openBox<int>(dbBox);
    step++;
  }
}
