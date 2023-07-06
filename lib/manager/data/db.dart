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

class MCADb {
  late final List<int> encryptionKey;

  static const String _client = 'c';
  static const String _encryptionKey = 'ek';
  static const String _clientIdTest = 'cdt';
  static const String _clientIdReal = 'cdr';
  static const String _clientSecretTest = 'cst';
  static const String _clientSecretReal = 'csr';

  static const String _token = 't';
  static const String _accessToken = 'at';
  static const String _refreshToken = 'rt';
  static const String _isTestMode = 'itm';
  static const String _apiBaseUrl = 'abu';
  static const String _domain = 'dmn';

  static const String _etc = 'etc';
  static const String _geoIpifyApiKey = 'geoIpifyApiKey';

  Future<void> initHive() async {
    int step = 1;

    logger('[STEP: $step] - Running initFlutter');
    await Hive.initFlutter();
    step++;
    logger('[STEP: $step] - Running Open Box $_etc');
    final etcBox = await Hive.openBox(_etc);
    //Finding the encryption key [encryptionKey] is used to encrypt and decrypt the box
    final encKeyFromBox = etcBox.get(_encryptionKey);
    //If the encryption key is not found, generate a new one and save it to the box
    if (encKeyFromBox == null) {
      encryptionKey = Hive.generateSecureKey();
      await etcBox.put(_encryptionKey, encryptionKey);
    } else {
      //If the encryption key is found, use it
      encryptionKey = encKeyFromBox;
    }

    step++;
    logger('[STEP: $step] - Running Open Box $_client');
    final clientBox = await Hive.openBox(_client,
        encryptionCipher: HiveAesCipher(encryptionKey));
    if (clientBox.get(_clientIdTest) == null) {
      await clientBox.put(_clientIdTest, clientIdTestStr);
    }
    if (clientBox.get(_clientIdReal) == null) {
      await clientBox.put(_clientIdReal, clientIdRealStr);
    }
    if (clientBox.get(_clientSecretTest) == null) {
      await clientBox.put(_clientSecretTest, clientSecretTestStr);
    }
    if (clientBox.get(_clientSecretReal) == null) {
      await clientBox.put(_clientSecretReal, clientSecretRealStr);
    }
    step++;
    logger('[STEP: $step] - Running Open Box $_token');
    await Hive.openBox(_token, encryptionCipher: HiveAesCipher(encryptionKey));
    step++;
  }

  String getClientId() {
    final Box box = Hive.box(_client);
    final String? id = box.get(getIsTestMode() ? _clientIdTest : _clientIdReal);
    logger("HIVE: getClientId: $id");
    return id!;
  }

  String getClientSecret() {
    final Box box = Hive.box(_client);
    final String? secret =
        box.get(getIsTestMode() ? _clientSecretTest : _clientSecretReal);
    logger("HIVE: getClientSecret: $secret");
    return secret!;
  }

  Future<void> setAccessToken(String token) async {
    final Box box = Hive.box(_token);
    await box.put(_accessToken, token);
    logger("HIVE: setAccessToken: $token");
  }

  String getAccessToken() {
    final Box box = Hive.box(_token);
    final String? token = box.get(_accessToken, defaultValue: "");
    logger("HIVE: getAccessToken: $token");
    return token!;
  }

  Future<void> deleteAccessToken() async {
    final Box box = Hive.box(_token);
    await box.delete(_accessToken);
    logger("HIVE: deleteAccessToken");
  }

  Future<void> setRefreshToken(String token) async {
    final Box box = Hive.box(_token);
    await box.put(_refreshToken, token);
    logger("HIVE: setRefreshToken: $token");
  }

  String getRefreshToken() {
    final Box box = Hive.box(_token);
    final String? token = box.get(_refreshToken, defaultValue: "");
    logger("HIVE: getRefreshToken: $token");
    return token!;
  }

  Future<void> deleteRefreshToken() async {
    final Box box = Hive.box(_token);
    await box.delete(_refreshToken);
    logger("HIVE: deleteRefreshToken");
  }

  Future<void> setIsTestMode(bool isTest) async {
    final Box box = Hive.box(_token);
    await box.put(_isTestMode, isTest.toString());
    await box.put(_apiBaseUrl, isTest ? apiBaseUrlDevStr : apiBaseUrlProdStr);
    logger("HIVE: setIsTestMode: $isTest");
  }

  bool getIsTestMode() {
    final Box box = Hive.box(_token);
    final String? isTest = box.get(_isTestMode, defaultValue: "true");
    logger("HIVE: getIsTestMode: $isTest");
    return isTest == "true";
  }

  Future<void> setGeoIpifyApiKey(String apiKey) async {
    final Box box = Hive.box(_etc);
    await box.put(_geoIpifyApiKey, apiKey);
    logger("HIVE: setGeoIpifyApiKey: $apiKey");
  }

  String getApiBaseUrl() {
    final Box box = Hive.box(_token);
    final String? url = box.get(_apiBaseUrl, defaultValue: apiBaseUrlDevStr);
    return url!;
  }

  String getDomain() {
    final Box box = Hive.box(_token);
    final String? domain = box.get(_domain, defaultValue: domainDevStr);
    return domain!;
  }

  Future<void> setDomain(String domain) async {
    final Box box = Hive.box(_token);
    await box.put(_domain, domain);
    logger("HIVE: setDomain: $domain");
  }
}
