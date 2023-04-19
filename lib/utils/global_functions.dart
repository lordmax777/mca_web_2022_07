import 'package:get_ip_address/get_ip_address.dart';

Future<String?> getIpAddress() async {
  String? ipAddress;
  try {
    final IpAddress ip = IpAddress();
    ipAddress = await ip.getIpAddress();
  } on Exception {
    ipAddress = null;
  }
  return ipAddress;
}
