import 'package:auto_route/auto_route.dart';
import 'package:get_ip_address/get_ip_address.dart' as getIp;
import 'package:google_maps_webservice/geocoding.dart';
import 'package:plural_noun/plural_noun.dart';
import '../theme/theme.dart';
import 'constants.dart' as constants;

// import 'package:fingerprintjs/fingerprintjs.dart';

final GoogleMapsGeocoding geocoding =
    GoogleMapsGeocoding(apiKey: constants.Constants.googleMapApiKey);

Future<String?> getIpAddress() async {
  String? ipAddress;
  try {
    final getIp.IpAddress ip = getIp.IpAddress();
    ipAddress = await ip.getIpAddress();
  } on Exception {
    ipAddress = null;
  }
  return ipAddress;
}

Future<GeocodingResult?> getAddressFromPostCode(String postcode,
    {String? countryCode}) async {
  GeocodingResponse response = await geocoding.searchByComponents([
    if (countryCode != null) Component(Component.country, countryCode),
    Component(Component.postalCode, postcode),
  ]);

  if (response.isOkay) {
    return response.results.first;
  } else {
    return null;
  }
}

extension StringExtensions on String {
  String get toPlural {
    final PluralRules pluralRules = PluralRules();
    final plural = pluralRules.convertToPluralNoun(this);
    return plural;
  }

  String get capitalize {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

Future<String?> getBrowserId() async {
  String? browserId;
  try {
    String browserInfo =
        // await Fingerprint.getHash();
        "648030568db8e547ddf664b204e6bda7";
    browserId = browserInfo;
  } on Exception {
    browserId = null;
  }
  return browserId;
}

Future<bool> exit(BuildContext context) {
  return context.popRoute();
}

Future<bool> onWillPop(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard changes?'),
          content: const Text('Are you sure you want to discard changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => context.popRoute(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => context.popRoute(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      )) ??
      false;
}
