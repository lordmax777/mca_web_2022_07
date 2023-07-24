import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mca_dashboard/manager/api/api.dart';
import 'package:mca_dashboard/manager/dependencies/dependencies.dart';
import 'package:mockito/annotations.dart';
import 'package:dio/dio.dart' as dio;
// file which has the getNumberTrivia function
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:retrofit/dio.dart';

@GenerateMocks([ApiClient])
void main() {
  late ApiClient apiClient;

  setUp(() {
    apiClient = DependencyManager.instance.apiClient;
  });

  group("Lists Test", () {
    test("api/fe/lists ✅", () async {
      when(apiClient.getLists()).thenAnswer((realInvocation) {
        return Future.value(HttpResponse(
            jsonEncode({"data": []}),
            dio.Response(
                requestOptions: dio.RequestOptions(path: "api/fe/lists"))));
      });
    });
  });
}
