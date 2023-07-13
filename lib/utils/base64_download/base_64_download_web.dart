import 'dart:convert';
import 'dart:html' as html;

void base64Download(String data) {
  //this is a web only function
  //task is to download a file from a base64 string, PS: the file is pdf in this case
  final bytes = base64Decode(data);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'checklist.pdf';
  html.document.body!.children.add(anchor);
  anchor.click();
  html.document.body!.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
