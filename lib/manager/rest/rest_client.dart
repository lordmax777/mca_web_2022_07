import 'package:dio/dio.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:retrofit/retrofit.dart';

import '../../theme/theme.dart';
import 'dio_client_for_retrofit.dart';

part 'rest_client.g.dart';

@RestApi(parser: Parser.JsonSerializable)
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

  @POST("/oauth/v2/token")
  @FormUrlEncoded()
  Future<HttpResponse> refreshToken(
    @Field() String grant_type,
    @Field() String refresh_token,
    @Field() String client_id,
    @Field() String client_secret,
  );

  @GET("/api/fe/managedusers")
  Future<HttpResponse> getUsersList();

  @GET("/api/fe/lists")
  Future<HttpResponse> getLists();

  @GET("/api/fe/statuses")
  Future<HttpResponse> getStatusesList();

  @GET("/api/fe/formats")
  Future<HttpResponse> getFormatsList();

  @GET("/api/fe/details")
  Future<HttpResponse> getLoggedInUserDetails();

  @GET("/api/fe/company")
  Future<HttpResponse> getCompanyInfo();

  @GET("/api/fe/userdetails/{id}/photos")
  Future<HttpResponse> getUserDetailsPhotos(@Path() String id);

  @POST("/api/fe/userdetails/{id}/photos")
  @FormUrlEncoded()
  Future<HttpResponse> addUserDetailsPhotos(
    @Path() String id, {
    @Field() required String photo,
    @Field() String? comment,
  });

  @DELETE("/api/fe/userdetails/{id}/photos")
  @FormUrlEncoded()
  Future<HttpResponse> deleteUserDetailsPhotos(
      @Path() String id, @Query("photoid") int photoId);

  @GET("/api/fe/userdetails/{id}/contracts")
  Future<HttpResponse> getUserDetailsContracts(@Path() String id);

  @POST("/api/fe/userdetails/{id}/contracts")
  @FormUrlEncoded()
  Future<HttpResponse> postUserDetailsContracts(
    @Path() String id, {
    @Field() required String csd,
    @Field() required int contractType,
    @Field() required int hct,
    @Field() required int AHEonYS,
    @Field() required int awh,
    @Field() required int jobTitle,
    @Field() required String wdpw,
    @Field() double? salaryPH,
    @Field() int? contractid,
    @Field() String? ced,
    @Field() String? initHolidays,
    @Field() String? jobDescription,
    @Field() double? salaryPA,
    @Field() double? salaryOT,
    @Field() int? ahe,
    @Field() String? lunchtime,
    @Field() String? lunchtimeUnpaid,
  });

  @DELETE("/api/fe/userdetails/{id}/contracts")
  Future<HttpResponse> deleteUserDetailsContract(
      @Path() String id, @Query("contractid") int contractid);

  @GET("/api/fe/userdetails/{id}/details")
  Future<HttpResponse> getUserDetails(@Path() String id);

  @GET("/api/fe/userdetails/{id}/reviews")
  Future<HttpResponse> getUserDetailsReviews(@Path() String id);

  @DELETE("/api/fe/userdetails/{id}/reviews")
  Future<HttpResponse> deleteUserDetailsReviews(
      @Path() String id, @Query("reviewid") int reviewid);

  @POST("/api/fe/userdetails/{id}/reviews")
  @FormUrlEncoded()
  Future<HttpResponse> postUserDetailsReviews(
    @Path() String id, {
    @Field() required String title,
    @Field() required String date,
    @Field() required int conductedBy,
    @Field() int? reviewid,
    @Field() String? notes,
  });

  @GET("/api/fe/userdetails/{id}/visas")
  Future<HttpResponse> getUserDetailsVisas(@Path() String id);

  @POST("/api/fe/userdetails/{id}/visas")
  @FormUrlEncoded()
  Future<HttpResponse> postUserDetailsVisa(
    @Path() String id, {
    @Field() required String documentNo,
    @Field() required String startDate,
    @Field() required String endDate,
    @Field() required int notExpire,
    @Field() required int visaTypeId,
    @Field() int? visaid,
    @Field() String? notes,
  });

  @DELETE("/api/fe/userdetails/{id}/visas")
  Future<HttpResponse> deleteUserDetailsVisa(
      @Path() String id, @Query("visaid") String visaid);

  @GET("/api/fe/userdetails/{id}/preferredshifts")
  Future<HttpResponse> getUserDetailsPreferredShifts(@Path() String id);

  @POST("/api/fe/userdetails/{id}/preferredshifts")
  @FormUrlEncoded()
  Future<HttpResponse> postUserDetailsPreferredShift(
    @Path() String id, {
    @Field() required int weekId,
    @Field() required int dayId,
    @Field() required int shiftId,
    @Field() int? timingid,
  });

  @DELETE("/api/fe/userdetails/{id}/preferredshifts")
  Future<HttpResponse> deleteUserDetailsPreferredShift(
      @Path() String id, @Query("timingid") int timingid);

  @GET("/api/fe/userdetails/{id}/qualifications")
  Future<HttpResponse> getUserDetailsQalifications(@Path() String id);

  @POST("/api/fe/userdetails/{id}/qualifications")
  @FormUrlEncoded()
  Future<HttpResponse> postUserDetailsQualifs(
    @Path() String id, {
    @Field() int? userqualificationid,
    @Field() required int qualificationId,
    @Field() required int levelId,
    @Field() required String achievementDate,
    @Field() String? expiryDate,
    @Field() required String certificateNumber,
    @Field() String? comments,
  });

  @DELETE("/api/fe/userdetails/{id}/qualifications")
  Future<HttpResponse> deleteUserDetailsQualifs(
      @Path() String id, @Query("userqualificationid") int userqualificationid);

  @GET("/api/fe/userdetails/{id}/mobile")
  Future<HttpResponse> getUserDetailsMobile(@Path() String id);

  @DELETE("/api/fe/userdetails/{id}/mobile")
  @FormUrlEncoded()
  Future<HttpResponse> deleteUserDetailsMobile(@Path() String id);

  @GET("/api/fe/userdetails/{id}/status")
  Future<HttpResponse> getUserDetailsStatus(@Path() String id);

  @POST("/api/fe/userdetails/{id}/status")
  @FormUrlEncoded()
  Future<HttpResponse> postUserDetailsStatus(
    @Path() String id, {
    @Field() required String status,
    @Field() required String shift,
    @Field() required String location,
    @Field() String? comment,
  });

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
    @Field() List<int>? loginmethods, //codes
    @Field() String? email,
  });

  @GET("/api/fe/locations")
  Future<HttpResponse> getLocationsOrSingle({int? id});

  @DELETE("/api/fe/locations/{id}")
  Future<HttpResponse> deleteLocation(@Path() int id);

  @POST("/api/fe/locations")
  @FormUrlEncoded()
  Future<HttpResponse> postLocation({
    @Field() int? id,
    @Field() required String name,
    @Field() required bool active,
    @Field() required bool base, //if the location is in the base
    @Field() required bool timelimit,
    @Field() required String latitude,
    @Field() required String longitude,
    @Field() required String radius,
    @Field() String? phoneLandline,
    @Field() String? phoneMobile,
    @Field() String? phoneFax,
    @Field() String? email,
    @Field() required bool sendChecklist,
    @Field() required bool anywhere, // False
    @Field() String? addressLine1,
    @Field() String? addressLine2,
    @Field() String? addressCity,
    @Field() String? addressCounty,
    @Field() String? addressCountry,
    @Field() String? addressPostcode,
    @Field() required bool fixedipaddress,
    @Field() String? ipaddress, //String separated by comma
  });

  @POST("/api/fe/locations/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> updateLocation({
    @Path() int? id,
    @Field() required String name,
    @Field() required bool active,
    @Field() required bool base, //if the location is in the base
    @Field() required bool timelimit,
    @Field() required String latitude,
    @Field() required String longitude,
    @Field() required String radius,
    @Field() String? phoneLandline,
    @Field() String? phoneMobile,
    @Field() String? phoneFax,
    @Field() String? email,
    @Field() required bool sendChecklist,
    @Field() required bool anywhere, // False
    @Field() String? addressLine1,
    @Field() String? addressLine2,
    @Field() String? addressCity,
    @Field() String? addressCounty,
    @Field() String? addressCountry,
    @Field() String? addressPostcode,
    @Field() required bool fixedipaddress,
    @Field() String? ipaddress, //String separated by comma
  });

  @POST("/api/fe/groups")
  @FormUrlEncoded()
  Future<HttpResponse> postGroup({
    @Field() int? id,
    @Field() required String name,
    @Field() required bool active,
  });

  @DELETE("/api/fe/groups")
  @FormUrlEncoded()
  Future<HttpResponse> deleteGroup(@Query("groupid") int groupid);

  @POST("/api/fe/jobtitles")
  @FormUrlEncoded()
  Future<HttpResponse> postJobTitle({
    @Field() int? id,
    @Field() required String title,
    @Field() required bool active,
  });

  @DELETE("/api/fe/jobtitles")
  @FormUrlEncoded()
  Future<HttpResponse> deleteJobTitle(@Query("jobtitleid") int jobtitleid);

  @POST("/api/fe/qualifications")
  @FormUrlEncoded()
  Future<HttpResponse> postQualif({
    @Field() int? id,
    @Field() String? comments,
    @Field() required String title,
    @Field() required bool active,
    @Field() required bool levels,
    @Field() required bool expire,
  });

  @DELETE("/api/fe/qualifications")
  Future<HttpResponse> deleteQualification(
      @Query("qualificationid") int qualificationid);

  @GET("/api/fe/warehouses")
  Future<HttpResponse> getWarehouses();

  @POST("/api/fe/warehouses/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> postWarehouse({
    @Path() int? id,
    @Field() String? contactEmail,
    @Field() required String name,
    @Field() required String contactName,
    @Field() required bool active,
    @Field() required bool sendReport,
  });

  @DELETE("/api/fe/warehouses/{storageid}")
  Future<HttpResponse> deleteWarehouse(@Path() int storageid);

  @GET("/api/fe/checklisttemplates/{id}/details")

  ///Pass 0 to get all templates
  Future<HttpResponse> getChecklistTemplates(@Path() int id);

  @POST("/api/fe/checklisttemplates/{id}/details")
  @FormUrlEncoded()
  Future<HttpResponse> postChecklistTemplate({
    @Path() int? id,
    @Field() required String name,
    @Field() required String title,
    @Field() required bool active,
  });

  @POST("/api/fe/checklisttemplates/{id}/rooms")
  @FormUrlEncoded()
  Future<HttpResponse> postChecklistTemplateRoom({
    @Path() int? id,
    @Field() required String name,
    @Field() required String items,
    @Field() required bool damage,
  });

  @DELETE("/api/fe/checklisttemplates/{id}/rooms")
  Future<HttpResponse> deleteChecklistTemplateRoom(
      @Path() int id, @Query("name") String name);

  @GET("/api/fe/shifts/{id}/details")
  Future<HttpResponse> getProperties(@Path() String id);

  @POST("/api/fe/shifts/{id}/details")
  @FormUrlEncoded()
  Future<HttpResponse> postPropertie({
    ///to create a new property pass 0
    @Path() int? id,
    @Field() required String title,
    @Field() required int locationId,
    @Field() required int clientId,
    @Field() required int storageId,
    @Field() required int templateId,
    @Field() required String startTime,
    @Field() required String finishTime,
    @Field() String? startBreak,
    @Field() String? finishBreak,
    @Field() String? fpStartTime,
    @Field() String? fpFinishTime,
    @Field() String? fpStartBreak,
    @Field() String? fpFinishBreak,
    @Field() required bool strictBreak,
    @Field() int? minWorkTime,
    @Field() int? minPaidTime,
    @Field() bool? splitTime,
    @Field() required bool checklist,
    @Field() required bool dayMon,
    @Field() required bool dayTue,
    @Field() required bool dayWed,
    @Field() required bool dayThu,
    @Field() required bool dayFri,
    @Field() required bool daySat,
    @Field() required bool daySun,
    @Field() required bool active,
  });

  @DELETE("/api/fe/shifts/{id}/details")
  Future<HttpResponse> deleteProperty(@Path() int id);

  @GET("/api/fe/shifts/{id}/staff")
  Future<HttpResponse> getPropertiesStaff(@Path() String id);

  @POST("/api/fe/shifts/{id}/staff")
  @FormUrlEncoded()
  Future<HttpResponse> postPropertiesStaff({
    @Path() int? id,
    @Field() required int groupId,
    @Field() required int numberOfStaff,
    @Field() int? maxOfStaff,
  });

  @DELETE("/api/fe/shifts/{id}/staff")
  Future<HttpResponse> deletePropertiesStaff(
      @Path('id') int shiftId, @Query("groupId") int groupId);

  @GET("/api/fe/shifts/{id}/qualification")
  Future<HttpResponse> getPropertiesQualification(@Path() String id);

  @POST("/api/fe/handovertypes")
  @FormUrlEncoded()
  Future<HttpResponse> postHandoverTypes({
    @Path() int? id,
    @Field() required String title,
    @Field() required bool active,
  });

  @POST("/api/fe/handovertypes/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> updateHandoverTypes({
    @Path() int? id,
    @Field() required String title,
    @Field() required bool active,
  });

  @DELETE("/api/fe/handovertypes/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> deleteHandoverTypes(@Path() int id);

  @GET("/api/fe/storageitems")
  Future<HttpResponse> getStorageItems();

  @POST("/api/fe/storageitems/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> postStorageItems({
    @Path() int? id,
    @Field() required String name,
    @Field() required int taxId,
    @Field() String? incomingPrice, // Our price
    @Field() String? outgoingPrice, // Customer price
    @Field() required bool service,
    @Field() required bool active,
  });

  @DELETE("/api/fe/storageitems/{id}")
  Future<HttpResponse> deleteStorageItems(@Path() int id);

  @GET("/api/fe/shifts/{id}/specialrate")
  Future<HttpResponse> getShiftSpecialRate(@Path() int id);

  @POST("/api/fe/shifts/{shiftId}/specialrate")
  @FormUrlEncoded()
  Future<HttpResponse> postShiftSpecialRate({
    ///Shift ID, 0 to create new
    @Path() int? shiftId,
    @Field() required String name,
    @Field() required double rate,
    @Field() required int minWorkTime,
    @Field() required int minPaidTime,
    @Field() required bool splitTime,
  });

  @DELETE("/api/fe/shifts/{id}/specialrate")
  Future<HttpResponse> deleteShiftSpecialRate(
      @Path() int shiftId, @Query("specialRateId") int specialRateId);

  @GET(
      "/api/fe/allocations/location/{locationId}/user/{userId}/shift/{shiftId}/date/{date}")
  Future<HttpResponse> getShifts(@Path() int locationId, @Path() int userId,
      @Path() int shiftId, @Path() String date,
      {@Query("until") String? until});

  @POST(
      "/api/fe/allocations/location/{locationId}/user/{userId}/shift/{shiftId}/date/{date}")
  @FormUrlEncoded()
  Future<HttpResponse> postShifts(
    @Path() int locationId,
    @Path() int userId,
    @Path() int shiftId,
    @Path() String date,

    ///Action. Available: add,remove,publish,unpublish,more,less, copy
    @Field() String action, {
    @Field() String? date_until,
    @Field() String? target_date,
    @Field() int? target_location,
    @Field() int? target_user,
    @Field() int? target_shift,
  });

  @GET("/api/fe/availability/{date}")
  Future<HttpResponse> getUnavailableUserList(@Path() String date);

  @POST("/api/fe/clients/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> createClient(
    ///0 to create new, id to update
    @Path() int id, {
    @Field() required String name,
    @Field() required String company,
    @Field() required String phone,
    @Field() required String email,
    @Field() required String addressLine1,
    @Field() required String addressCity,
    @Field() required String addressPostcode,
    //country code
    @Field() required String addressCountry,
    @Field() String? notes,
    @Field() required int currencyId,
    @Field() required int paymentMethodId,
    @Field() required int payingDays,
    @Field() required bool active,
  });

  @GET("/api/fe/clients/{id}/contract/{cid}/shifts/{sid}")

  /// at least one of the parameters must be specified as not 0
  ///
  /// id = client id
  ///
  /// cid = contract id
  ///
  /// sid = shift id
  Future<HttpResponse> getClientContracts(
      @Path() int id, @Path() int cid, @Path() int sid);

  // id = 0 to get all
  @GET("/api/fe/clients/{id}")
  Future<HttpResponse> getClients(@Path() int id);

  // id = 0 to get all
  @GET("/api/fe/quotes/{id}")
  Future<HttpResponse> getQuotes(@Path() int id);

  // @POST("/api/fe/quotes/{id}")
  // @FormUrlEncoded()
  // Future<HttpResponse> createQuote(
  //   ///0 to create new, id to update
  //   @Path() int id, {
  //   @Field() required String email,
  //   @Field() required String name,
  //   @Field() String? company,
  //   @Field() String? phone,
  //   @Field() String? addressLine1,
  //   @Field() String? addressLine2,
  //   @Field() String? addressCity,
  //   @Field() String? addressCounty,
  //   //country code
  //   @Field() String? addressCountry,
  //   @Field() String? addressPostcode,
  //   @Field() String? workAddressLine1,
  //   @Field() String? workAddressLine2,
  //   @Field() String? workAddressCity,
  //   @Field() String? workAddressCounty,
  //   //country code
  //   @Field() String? workAddressCountry,
  //   @Field() String? workAddressPostcode,
  //   @Field() String? notes,
  //   @Field() int? currencyId,
  //   @Field() int? paymentMethodId,
  //   @Field() required int payingDays,
  //   @Field() required bool active,
  //   @Field() String? workStartDate,
  //   @Field() String? altWorkStartDate,
  //   @Field() String? workStartTime,
  //   @Field() String? workFinishTime,
  //   @Field() int? workRepeatId,
  //   @Field() String? quoteComments,
  //   @Field() List<int>? workDays,
  // });

  @GET("/api/fe/approvals")
  Future<HttpResponse> getApprovals();

  @POST("/api/fe/quotestatus/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> updateQuoteStatus(
    @Path() int id, {
    @Field() required String status,
    @Field() required String ip_address,
    @Field() required String browserId,
  });
}

RestClient restClient() => RestClient(
    DioClientForRetrofit(
            bearerToken: appStore.state.authState.authRes.data?.access_token)
        .init(),
    baseUrl: Constants.apiBaseUrl);

Dio restClientWithDio(String contentType) => DioClientForRetrofit(
        bearerToken: appStore.state.authState.authRes.data?.access_token,
        contentType: contentType)
    .init();

RequestOptions setStreamType<T>(RequestOptions requestOptions) {
  if (T != dynamic &&
      !(requestOptions.responseType == ResponseType.bytes ||
          requestOptions.responseType == ResponseType.stream)) {
    if (T == String) {
      requestOptions.responseType = ResponseType.plain;
    } else {
      requestOptions.responseType = ResponseType.json;
    }
  }
  return requestOptions;
}
