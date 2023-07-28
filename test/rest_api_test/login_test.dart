import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mca_dashboard/manager/api/api.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart' as dio;

// file which has the getNumberTrivia function
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';

@GenerateMocks([ApiClient, MCADb])
void main() {
  late ApiClient apiClient;

  setUp(() async {
    final db = MCADb();
    await db.initHive();
    final dioClient = DioClient();
    await dioClient.init();
    apiClient = ApiClient(dioClient.dio);
  });

  group("Login Test", () {
    test("/oauth/v2/token ✅", () async {
      when(apiClient.getAccessToken(
              "password",
              domainDevStr,
              clientIdTestStr,
              clientSecretTestStr,
              GlobalConstants.debugusername,
              GlobalConstants.debugpassword))
          .thenAnswer((realInvocation) {
        return Future.value(HttpResponse(
            jsonEncode({
              "access_token":
                  "MmJkMTczYzdmODAzYjJkY2Q2N2U5MTNiYzkxODIzMzBhOWY4NTNlMGRkOTVhMDA4OTBjZTgwZmI4MjkzN2YyNQ",
              "expires_in": 600,
              "token_type": "bearer",
              "scope": null,
              "refresh_token":
                  "YTk2NWZkODlhYmMzMzNlYzE2OTQxNjk4ODYyM2U3NTY2ODdjNjljM2U2YjQ5YjMxZjBjMjYxNjdiNTNjYzllYw"
            }),
            dio.Response(
                requestOptions: dio.RequestOptions(path: "/oauth/v2/token"))));
      });
    });
  });
}
