import 'dart:html' as html;
import 'package:mca_web_2022_07/theme/theme.dart';

void setupDomain() {
  //1. find the base url
  logger("WEB - window.location.origin: ${html.window.location.origin}");
  final domain =
      // "kashiaba.onlinetimeclock.co.uk";
      Constants.isDebug ? Constants.domain : html.window.location.origin;
  Constants.domain = domain;
  logger('WEB - baseUrl: ${Constants.domain}');
}
