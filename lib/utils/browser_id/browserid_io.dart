import 'dart:io';

String getBrowserId() {
  return HttpClient().userAgent ?? "";
}
