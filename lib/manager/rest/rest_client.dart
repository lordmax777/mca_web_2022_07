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
}

RestClient restClient() => RestClient(DioClientForRetrofit(
        bearerToken: appStore.state.authState.authRes?.access_token)
    .init());
