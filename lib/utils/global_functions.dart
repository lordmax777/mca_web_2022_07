import 'package:get_ip_address/get_ip_address.dart' as getIp;
import 'package:google_maps_webservice/geocoding.dart';
import 'package:plural_noun/plural_noun.dart';

import 'constants.dart' as constants;

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