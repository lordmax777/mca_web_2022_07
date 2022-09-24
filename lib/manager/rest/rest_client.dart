import 'package:dio/dio.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:retrofit/retrofit.dart';

import '../../theme/theme.dart';
import 'dio_client_for_retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: Constants.apiBaseUrlDev, parser: Parser.JsonSerializable)
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @POST("/oauth/v2/token")
  @FormUrlEncoded()
  Future<HttpResponse> getAccessToken(
    @Field() String grant_type,
    @Field() String domain,
    @Field() String client_id,
    @Field() String client_secret,
    @Field() String username,
    @Field() String password,
  );

  @GET("/api/fe/managedusers")
  Future<HttpResponse> getUsersList();

  @GET("/api/fe/locations")
  Future<HttpResponse> getLocationsList();

  @GET("/api/fe/lists")
  Future<HttpResponse> getLists();

  @GET("/api/fe/statuses")
  Future<HttpResponse> getStatusesList();

  @GET("/api/fe/formats")
  Future<HttpResponse> getFormatsList();

  @GET("/api/fe/userdetails/{id}/photos")
  Future<HttpResponse> getUserDetailsPhotos(@Path() String id);

  @GET("/api/fe/userdetails/{id}/contracts")
  Future<HttpResponse> getUserDetailsContracts(@Path() String id);

  @GET("/api/fe/userdetails/{id}/details")
  Future<HttpResponse> getUserDetails(@Path() String id);

  @GET("/api/fe/userdetails/{id}/reviews")
  Future<HttpResponse> getUserDetailsReviews(@Path() String id);

  @GET("/api/fe/userdetails/{id}/visas")
  Future<HttpResponse> getUserDetailsVisas(@Path() String id);

  @GET("/api/fe/userdetails/{id}/preferredshifts")
  Future<HttpResponse> getUserDetailsPreferredShifts(@Path() String id);

  @GET("/api/fe/userdetails/{id}/qualifications")
  Future<HttpResponse> getUserDetailsQalifications(@Path() String id);

  @GET("/api/fe/userdetails/{id}/mobile")
  Future<HttpResponse> getUserDetailsMobile(@Path() String id);

  @GET("/api/fe/userdetails/{id}/status")
  Future<HttpResponse> getUserDetailsStatus(@Path() String id);

  @POST("/api/fe/userdetails/{id}/details")
  @FormUrlEncoded()
  Future<HttpResponse> getSaveUserGeneralDetails(
    @Path() int id, {
    @Field() required String firstName,
    @Field() required String lastName,
    @Field() required String addressLine1,
    @Field() required String addressCity,
    @Field() required String addressPostcode,
    @Field() required int group, //code
    @Field() required int location, //code
    @Field() required String role, //code
    @Field() required String language,
    @Field() String? upass,
    @Field() String? title, //code
    @Field() String? birthday,
    @Field() String? nationality, //code
    @Field() int? religion, //code
    @Field() int? ethnic, //code
    @Field() String? maritalStatus,
    @Field() String? ni,
    @Field() String? phoneLandline,
    @Field() String? phoneMobile,
    @Field() String? nokName,
    @Field() String? nokPhone,
    @Field() String? nokRelation,
    @Field() String? addressLine2,
    @Field() String? addressCounty,
    @Field() String? addressCountry, //code
    @Field() String? payrolCode,
    @Field() String? notes,
    @Field() String? isActive,
    @Field() int? exEmail, //0 - true, 1 - false
    @Field() double? latitude,
    @Field() double? longitude,
    @Field() String? groupAdmin,
    @Field() bool? locationAdmin,
    @Field() String? loginRequired,
    @Field() String? login_methods, //codes
    @Field() String? email,

    ///
  });
}

RestClient restClient() => RestClient(DioClientForRetrofit(
        bearerToken: appStore.state.authState.authRes.data?.access_token)
    .init());
