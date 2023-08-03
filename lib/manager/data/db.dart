import 'package:hive_flutter/hive_flutter.dart';
import 'package:mca_dashboard/utils/utils.dart';

const String apiBaseUrlDevStr = "https://timesheet.skillfill.co.uk";
const String apiBaseUrlProdStr = "https://timesheet.onlinetimeclock.co.uk";

const String domainDevStr = "timesheet.skillfill.co.uk";
const String domainRealStr = "kashiaba.onlinetimeclock.co.uk";

const String clientIdTestStr =
    "1_3bcbxd9e24g0gk4swg0kwgcwg4o8k8g4g888kwc44gcc0gwwk4";
const String clientSecretTestStr =
    "4ok2x70rlfokc8g0wws8c8kwcokw80k44sg48goc0ok4w0so0k";
const String clientIdRealStr =
    "2_7wm1uwliqqkggsg8c08g0wg0okc0cogw4o0gkkg0g0k0g4okc";
const String clientSecretRealStr =
    "3yu326re70w0wog4css8gswowc48okc4g08ocw8cc4wc0o08k8";
const String googleSdkKey = "AIzaSyBD7ZbpM4T6JRYz2B-1NK3XEURGsCa9FWY";
const String googleMapsApiKey = "AIzaSyAJppOsTzcnks6yfcR9WmJk-Cjqfw3zIww";

///client box
const String cBox = 'c';
const String encryptionKey = 'ek';
const String clientIdTestKey = 'cdt';
const String clientIdRealKey = 'cdr';
const String clientSecretTestKey = 'cst';
const String clientSecretRealKey = 'csr';

///token box
const String tBox = 't';
const String accessTokenKey = 'at';
const String refreshTokenKey = 'rt';
const String isTestModeKey = 'itm';
const String apiBaseUrlKey = 'abu';
const String domainKey = 'dmn';

///etc box
const String eBox = 'etc';
const String geoIpifyApiKey = 'geoIpifyApiKey';

class MCADb implements MCADbInterface {
  late final List<int> encryption;

  @override
  Future<void> initHive() async {
    int step = 1;

    logger('[STEP: $step] - Running initFlutter');
    await Hive.initFlutter();
    step++;
    logger('[STEP: $step] - Running Open Box $eBox');
    final etcBox = await Hive.openBox(eBox);
    //Finding the encryption key [encryptionKey] is used to encrypt and decrypt the box
    final encryptedKeyFromEtcBox = etcBox.get(encryptionKey);
    //If the encryption key is not found, generate a new one and save it to the box
    if (encryptedKeyFromEtcBox == null) {
      encryption = Hive.generateSecureKey();
      await etcBox.put(encryptionKey, encryptionKey);
    } else {
      //If the encryption key is found, use it
      encryption = encryptedKeyFromEtcBox;
    }

    step++;
    logger('[STEP: $step] - Running Open Box $cBox');
    final clientBox =
        await Hive.openBox(cBox, encryptionCipher: HiveAesCipher(encryption));
    if (clientBox.get(clientIdTestKey) == null) {
      await clientBox.put(clientIdTestKey, clientIdTestStr);
    }
    if (clientBox.get(clientIdRealKey) == null) {
      await clientBox.put(clientIdRealKey, clientIdRealStr);
    }
    if (clientBox.get(clientSecretTestKey) == null) {
      await clientBox.put(clientSecretTestKey, clientSecretTestStr);
    }
    if (clientBox.get(clientSecretRealKey) == null) {
      await clientBox.put(clientSecretRealKey, clientSecretRealStr);
    }
    step++;
    logger('[STEP: $step] - Running Open Box $tBox');
    await Hive.openBox(tBox, encryptionCipher: HiveAesCipher(encryption));
    step++;
  }

  @override
  String getClientId() {
    final Box box = Hive.box(cBox);
    final String? id =
        box.get(getIsTestMode() ? clientIdTestKey : clientIdRealKey);
    logger("HIVE: getClientId: $id");
    return id!;
  }

  @override
  String getClientSecret() {
    final Box box = Hive.box(cBox);
    final String? secret =
        box.get(getIsTestMode() ? clientSecretTestKey : clientSecretRealKey);
    logger("HIVE: getClientSecret: $secret");
    return secret!;
  }

  @override
  Future<void> setAccessToken(String token) async {
    final Box box = Hive.box(tBox);
    await box.put(accessTokenKey, token);
    logger("HIVE: setAccessToken: $token");
  }

  @override
  String getAccessToken() {
    final Box box = Hive.box(tBox);
    final String? t = box.get(accessTokenKey, defaultValue: "");
    logger("HIVE: getAccessToken: $t");
    return t!;
  }

  @override
  Future<void> deleteAccessToken() async {
    final Box box = Hive.box(tBox);
    await box.delete(accessTokenKey);
    logger("HIVE: deleteAccessToken");
  }

  @override
  Future<void> setRefreshToken(String token) async {
    final Box box = Hive.box(tBox);
    await box.put(refreshTokenKey, token);
    logger("HIVE: setRefreshToken: $token");
  }

  @override
  String getRefreshToken() {
    final Box box = Hive.box(tBox);
    final String? t = box.get(refreshTokenKey, defaultValue: "");
    logger("HIVE: getRefreshToken: $t");
    return t!;
  }

  @override
  Future<void> deleteRefreshToken() async {
    final Box box = Hive.box(tBox);
    await box.delete(refreshTokenKey);
    logger("HIVE: deleteRefreshToken");
  }

  @override
  Future<void> setIsTestMode(bool isTest) async {
    final Box box = Hive.box(tBox);
    await box.put(isTestModeKey, isTest.toString());
    await box.put(apiBaseUrlKey, isTest ? apiBaseUrlDevStr : apiBaseUrlProdStr);
    logger("HIVE: setIsTestMode: $isTest");
  }

  @override
  bool getIsTestMode() {
    final Box box = Hive.box(tBox);
    final String? isTest = box.get(isTestModeKey, defaultValue: "true");
    logger("HIVE: getIsTestMode: $isTest");
    return isTest == "true";
  }

  @override
  Future<void> setGeoIpifyApiKey(String apiKey) async {
    final Box box = Hive.box(eBox);
    await box.put(geoIpifyApiKey, apiKey);
    logger("HIVE: setGeoIpifyApiKey: $apiKey");
  }

  @override
  String getApiBaseUrl() {
    final Box box = Hive.box(tBox);
    final String? url = box.get(apiBaseUrlKey, defaultValue: apiBaseUrlDevStr);
    return url!;
  }

  @override
  String getDomain() {
    final Box box = Hive.box(tBox);
    final String? d = box.get(domainKey, defaultValue: domainDevStr);
    return d!;
  }

  @override
  Future<void> setDomain(String domain) async {
    final Box box = Hive.box(tBox);
    await box.put(domainKey, domain);
    logger("HIVE: setDomain: $domain");
  }
}

abstract class MCADbInterface {
  Future<void> initHive();
  String getClientId();
  String getClientSecret();
  Future<void> setAccessToken(String token);
  String getAccessToken();
  Future<void> deleteAccessToken();
  Future<void> setRefreshToken(String token);
  String getRefreshToken();
  Future<void> deleteRefreshToken();
  Future<void> setIsTestMode(bool isTest);
  bool getIsTestMode();
  Future<void> setGeoIpifyApiKey(String apiKey);
  String getApiBaseUrl();
  String getDomain();
  Future<void> setDomain(String domain);
}
