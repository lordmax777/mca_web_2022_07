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

const String client = 'c';
const String encryptionKey = 'ek';
const String clientIdTest = 'cdt';
const String clientIdReal = 'cdr';
const String clientSecretTest = 'cst';
const String clientSecretReal = 'csr';
const String tokenBox = 't';
const String accessToken = 'at';
const String refreshToken = 'rt';
const String isTestMode = 'itm';
const String apiBaseUrl = 'abu';
const String domain = 'dmn';
const String etc = 'etc';
const String geoIpifyApiKey = 'geoIpifyApiKey';

class MCADb implements MCADbInterface {
  late final List<int> encryption;

  @override
  Future<void> initHive() async {
    int step = 1;

    logger('[STEP: $step] - Running initFlutter');
    await Hive.initFlutter();
    step++;
    logger('[STEP: $step] - Running Open Box $etc');
    final etcBox = await Hive.openBox(etc);
    //Finding the encryption key [encryptionKey] is used to encrypt and decrypt the box
    final encKeyFromBox = etcBox.get(encryptionKey);
    //If the encryption key is not found, generate a new one and save it to the box
    if (encKeyFromBox == null) {
      encryption = Hive.generateSecureKey();
      await etcBox.put(encryptionKey, encryptionKey);
    } else {
      //If the encryption key is found, use it
      encryption = encKeyFromBox;
    }

    step++;
    logger('[STEP: $step] - Running Open Box $client');
    final clientBox =
        await Hive.openBox(client, encryptionCipher: HiveAesCipher(encryption));
    if (clientBox.get(clientIdTest) == null) {
      await clientBox.put(clientIdTest, clientIdTestStr);
    }
    if (clientBox.get(clientIdReal) == null) {
      await clientBox.put(clientIdReal, clientIdRealStr);
    }
    if (clientBox.get(clientSecretTest) == null) {
      await clientBox.put(clientSecretTest, clientSecretTestStr);
    }
    if (clientBox.get(clientSecretReal) == null) {
      await clientBox.put(clientSecretReal, clientSecretRealStr);
    }
    step++;
    logger('[STEP: $step] - Running Open Box $tokenBox');
    await Hive.openBox(tokenBox, encryptionCipher: HiveAesCipher(encryption));
    step++;
  }

  @override
  String getClientId() {
    final Box box = Hive.box(client);
    final String? id = box.get(getIsTestMode() ? clientIdTest : clientIdReal);
    logger("HIVE: getClientId: $id");
    return id!;
  }

  @override
  String getClientSecret() {
    final Box box = Hive.box(client);
    final String? secret =
        box.get(getIsTestMode() ? clientSecretTest : clientSecretReal);
    logger("HIVE: getClientSecret: $secret");
    return secret!;
  }

  @override
  Future<void> setAccessToken(String t) async {
    final Box box = Hive.box(tokenBox);
    await box.put(accessToken, t);
    logger("HIVE: setAccessToken: $t");
  }

  @override
  String getAccessToken() {
    final Box box = Hive.box(tokenBox);
    final String? t = box.get(accessToken, defaultValue: "");
    logger("HIVE: getAccessToken: $t");
    return t!;
  }

  @override
  Future<void> deleteAccessToken() async {
    final Box box = Hive.box(tokenBox);
    await box.delete(accessToken);
    logger("HIVE: deleteAccessToken");
  }

  @override
  Future<void> setRefreshToken(String t) async {
    final Box box = Hive.box(tokenBox);
    await box.put(refreshToken, t);
    logger("HIVE: setRefreshToken: $t");
  }

  @override
  String getRefreshToken() {
    final Box box = Hive.box(tokenBox);
    final String? t = box.get(refreshToken, defaultValue: "");
    logger("HIVE: getRefreshToken: $t");
    return t!;
  }

  @override
  Future<void> deleteRefreshToken() async {
    final Box box = Hive.box(tokenBox);
    await box.delete(refreshToken);
    logger("HIVE: deleteRefreshToken");
  }

  @override
  Future<void> setIsTestMode(bool isTest) async {
    final Box box = Hive.box(tokenBox);
    await box.put(isTestMode, isTest.toString());
    await box.put(apiBaseUrl, isTest ? apiBaseUrlDevStr : apiBaseUrlProdStr);
    logger("HIVE: setIsTestMode: $isTest");
  }

  @override
  bool getIsTestMode() {
    final Box box = Hive.box(tokenBox);
    final String? isTest = box.get(isTestMode, defaultValue: "true");
    logger("HIVE: getIsTestMode: $isTest");
    return isTest == "true";
  }

  @override
  Future<void> setGeoIpifyApiKey(String apiKey) async {
    final Box box = Hive.box(etc);
    await box.put(geoIpifyApiKey, apiKey);
    logger("HIVE: setGeoIpifyApiKey: $apiKey");
  }

  @override
  String getApiBaseUrl() {
    final Box box = Hive.box(tokenBox);
    final String? url = box.get(apiBaseUrl, defaultValue: apiBaseUrlDevStr);
    return url!;
  }

  @override
  String getDomain() {
    final Box box = Hive.box(tokenBox);
    final String? d = box.get(domain, defaultValue: domainDevStr);
    return d!;
  }

  @override
  Future<void> setDomain(String d) async {
    final Box box = Hive.box(tokenBox);
    await box.put(domain, d);
    logger("HIVE: setDomain: $d");
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
