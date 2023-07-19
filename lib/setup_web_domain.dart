import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'manager/manager.dart';

void setupDomain() {
  //1. find the base url

  final domain = kDebugMode
      ? domainDevStr
      :
      // domainDevStr;
      html.window.location.origin;
  String dom = domain.replaceAll("http://", "").replaceAll("https://", "");
  if (dom == "mca-web-2022-07.vercel.app") {
    dom = domainRealStr;
  }
  DependencyManager.instance.db.setDomain(dom);

  logger("SETUP DOMAIN - WEB - setting domain to $domain");
}
