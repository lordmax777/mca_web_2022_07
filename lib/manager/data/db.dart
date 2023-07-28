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

class MCADb extends MCADbInterface {
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
    logger('[STEP: $step] - Running Open Box $token');
    await Hive.openBox(token, encryptionCipher: HiveAesCipher(encryption));
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
  Future<void> setAccessToken(String token) async {
    final Box box = Hive.box(token);
    await box.put(accessToken, token);
    logger("HIVE: setAccessToken: $token");
  }

  @override
  String getAccessToken() {
    final Box box = Hive.box(this.token);
    final String? token = box.get(accessToken, defaultValue: "");
    logger("HIVE: getAccessToken: $token");
    return token!;
  }

  @override
  Future<void> deleteAccessToken() async {
    final Box box = Hive.box(token);
    await box.delete(accessToken);
    logger("HIVE: deleteAccessToken");
  }

  @override
  Future<void> setRefreshToken(String token) async {
    final Box box = Hive.box(token);
    await box.put(refreshToken, token);
    logger("HIVE: setRefreshToken: $token");
  }

  @override
  String getRefreshToken() {
    final Box box = Hive.box(this.token);
    final String? token = box.get(refreshToken, defaultValue: "");
    logger("HIVE: getRefreshToken: $token");
    return token!;
  }

  @override
  Future<void> deleteRefreshToken() async {
    final Box box = Hive.box(token);
    await box.delete(refreshToken);
    logger("HIVE: deleteRefreshToken");
  }

  @override
  Future<void> setIsTestMode(bool isTest) async {
    final Box box = Hive.box(token);
    await box.put(isTestMode, isTest.toString());
    await box.put(apiBaseUrl, isTest ? apiBaseUrlDevStr : apiBaseUrlProdStr);
    logger("HIVE: setIsTestMode: $isTest");
  }

  @override
  bool getIsTestMode() {
    final Box box = Hive.box(token);
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
    final Box box = Hive.box(token);
    final String? url = box.get(apiBaseUrl, defaultValue: apiBaseUrlDevStr);
    return url!;
  }

  @override
  String getDomain() {
    final Box box = Hive.box(token);
    final String? domain = box.get(this.domain, defaultValue: domainDevStr);
    return domain!;
  }

  @override
  Future<void> setDomain(String domain) async {
    final Box box = Hive.box(token);
    await box.put(domain, domain);
    logger("HIVE: setDomain: $domain");
  }
}

abstract class MCADbInterface {
  final String client = 'c';
  final String encryptionKey = 'ek';
  final String clientIdTest = 'cdt';
  final String clientIdReal = 'cdr';
  final String clientSecretTest = 'cst';
  final String clientSecretReal = 'csr';

  final String token = 't';
  final String accessToken = 'at';
  final String refreshToken = 'rt';
  final String isTestMode = 'itm';
  final String apiBaseUrl = 'abu';
  final String domain = 'dmn';

  final String etc = 'etc';
  final String geoIpifyApiKey = 'geoIpifyApiKey';

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
