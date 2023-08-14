// //Write a mock class using the Mockito package for Hive db
//
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hive/hive.dart';
// import 'package:mca_dashboard/manager/data/data.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'mca_db_test.mocks.dart';
// import 'mock_data.dart';
//
// class MocHive extends Mock implements HiveInterface {}
//
// class MockBox extends Mock implements Box {}
//
// //String getClientId();
// //   String getClientSecret();
// //   Future<void> setAccessToken(String token);
// //   String getAccessToken();
// //   Future<void> deleteAccessToken();
// //   Future<void> setRefreshToken(String token);
// //   String getRefreshToken();
// //   Future<void> deleteRefreshToken();
// //   Future<void> setIsTestMode(bool isTest);
// //   bool getIsTestMode();
// //   Future<void> setGeoIpifyApiKey(String apiKey);
// //   String getApiBaseUrl();
// //   String getDomain();
// //   Future<void> setDomain(String domain);
//
// @GenerateMocks([MCADb])
// void main() {
//   //initHive
//   final db = MockMCADb();
//   final mockedHive = MocHive();
//
//   setUp(() async {
//     mockedHive.init(null);
//     final PostExpectation<Box> res = when<Box>(await mockedHive.openBox(client))
//       ..thenReturn(MockBox());
//
//     // final clientBox = await mockedHive.openBox();
//
//     // when(mockedHive.box(client)).thenReturn(clientBox);
//     // when(mockedHive.box(token)).thenReturn(MockBox());
//     // when(mockedHive.box(etc)).thenReturn(MockBox());
//     when(db.getClientId()).thenAnswer((realInvocation) {
//       return mockedHive.box(client).get(clientIdTest, defaultValue: mockedTci);
//     });
//   });
//
//   group("MCADb Testing", () {
//     test("set test client id", () {});
//
//     test("returns test client id test", () {
//       final db = MockMCADb();
//       expect(db.getClientId(), mockedTci);
//     });
//   });
//
//   // //getClientSecret
//   // test("returns test client secret test", () {
//   //   final db = MockMCADb();
//   //   when(db.getClientSecret()).thenReturn(clientSecretTestStr);
//   //   expect(db.getClientSecret(), clientSecretTestStr);
//   // });
// //
// //   //setAccessToken
// //   test("setAccessToken test", () async {
// //     final db = MockMCADb();
// //     await db.setAccessToken(mockedAt);
// //     verify(db.setAccessToken(mockedAt));
// //   });
// //
// //   //getAccessToken
// //   test("getAccessToken test", () {
// //     final db = MockMCADb();
// //     when(db.getAccessToken()).thenReturn(mockedAt);
// //     expect(db.getAccessToken(), mockedAt);
// //   });
// //
// //   //deleteAccessToken
// //   test("deleteAccessToken test", () async {
// //     final db = MockMCADb();
// //     await db.deleteAccessToken();
// //     verify(db.deleteAccessToken());
// //   });
// //
// //   //setRefreshToken
// //   test("setRefreshToken test", () async {
// //     final db = MockMCADb();
// //     await db.setRefreshToken(mockedRt);
// //     verify(db.setRefreshToken(mockedRt));
// //   });
// //
// //   //getRefreshToken
// //   test("getRefreshToken test", () {
// //     final db = MockMCADb();
// //     when(db.getRefreshToken()).thenReturn(mockedRt);
// //     expect(db.getRefreshToken(), mockedRt);
// //   });
// //
// // //deleteRefreshToken
// //   test("deleteRefreshToken test", () async {
// //     final db = MockMCADb();
// //     await db.deleteRefreshToken();
// //     verify(db.deleteRefreshToken());
// //   });
// //
// //   // //setIsTestMode
// //   // test("setIsTestMode test", () async {
// //   //   final db = MockMCADb();
// //   //   when(db.setIsTestMode(true)).thenAnswer());
// //   // });
// }
