import 'dart:async';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'rest_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @POST("/oauth/v2/token")
  @FormUrlEncoded()
  Future<HttpResponse> getAccessToken(
    @Field("grant_type") String grantType,
    @Field() String domain,
    @Field("client_id") String clientId,
    @Field('client_secret') String clientSecret,
    @Field() String username,
    @Field() String password,
  );

  @POST("/oauth/v2/token")
  @FormUrlEncoded()
  Future<HttpResponse> getRefreshToken(
    @Field('grant_type') String grantType,
    @Field('refresh_token') String refreshToken,
    @Field('client_id') String clientId,
    @Field('client_secret') String clientSecret,
  );

  @GET("/api/fe/formats")
  Future<HttpResponse> getFormats();

  @GET("/api/fe/managedusers")
  Future<HttpResponse> getUsers();

  @GET("/api/fe/lists")
  Future<HttpResponse> getLists();

  @GET("/api/fe/userdetails/{userId}/details")
  Future<HttpResponse> getUserDetails(@Path() String userId);

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

  @GET("/api/fe/userdetails/{id}/photos")
  Future<HttpResponse> getUserDetailsPhotos(@Path() String id);

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
  Future<HttpResponse> getUserDetailsQualifications(@Path() String id);

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

    ///base64 encoded file
    @Field() String? file,
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

  @GET("/api/fe/locations/{id}")
  Future<HttpResponse> getLocation(@Path() String id);

  @GET("/api/fe/storageitems/{id}")
  Future<HttpResponse> getStorageItems(@Path() String id);

  @GET("/api/fe/clients")
  Future<HttpResponse> getClients(@Path() String id);

  @GET("/api/fe/shifts/{id}/details")
  Future<HttpResponse> getProperties(@Path() String id);

  @GET("/api/fe/quotes/{id}")
  Future<HttpResponse> getQuotes(
    @Path() String id, {
    @Query("date") String? date,
    @Query("location_id") int? location_id,
    @Query("shift_id") int? shift_id,
  });

  @GET("/api/fe/warehouses")
  Future<HttpResponse> getWarehouses();

  @GET("/api/fe/company")
  Future<HttpResponse> getCompanyInfo();

  @GET(
      "/api/fe/allocations/location/{locationId}/user/{userId}/shift/{shiftId}/date/{date}")
  Future<HttpResponse> getAllocations(@Path() String date,
      @Path() int locationId, @Path() int userId, @Path() int shiftId,
      {@Query("until") String? until});

  @POST(
      "/api/fe/allocations/location/{locationId}/user/{userId}/shift/{shiftId}/date/{date}")
  @FormUrlEncoded()
  Future<HttpResponse> postAllocation(
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

  @POST("/api/fe/storageitems/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> postStorageItem({
    @Path() int? id,
    @Field() required String name,
    @Field() required int taxId,
    @Field() String? incomingPrice, // Our price
    @Field() String? outgoingPrice, // Customer price
    @Field() required bool service,
    @Field() required bool active,
  });

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

  @POST("/api/fe/clients/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> postClient(
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

  @POST("/api/fe/quotestatus/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> changeQuoteStatus(
    @Path() int id, {
    ///pending, accept, decline
    @Field() required String status,
    @Field() required String ip_address,

    ///HTTP_USER_AGENT
    @Field() required String browser,
  });

  @POST("/api/fe/quotesend/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> sendEmailToQuote(@Path() int id);

  @GET("/api/fe/clients/{clientId}/shifts/{shiftId}/date/{date}")
  Future<HttpResponse> getClientContractItems(
      @Path() int clientId, @Path() int shiftId, @Path() String date);

  @GET("/api/fe/shifts/{shiftId}/propertydetails")
  Future<HttpResponse> getPropertyDetails(@Path() int shiftId);

  @POST("/api/fe/shifts/{shiftId}/propertydetails")
  @FormUrlEncoded()
  Future<HttpResponse> updatePropertyDetails(
    @Path() int shiftId, {
    @Field() required int bedrooms,
    @Field() required int bathrooms,
    @Field() required int min_sleeps,
    @Field() required int max_sleeps,
    @Field() required String? notes,
  });

  @POST("/api/fe/userdetails/{userId}/details")
  @FormUrlEncoded()
  Future<HttpResponse> postUserDetails(
    ///0 to create new, id to update
    @Path() int userId, {
    @Field() required String firstName,
    @Field() required String lastName,
    @Field() required String addressLine1,
    @Field() required String addressCity,
    @Field() required String addressPostcode,

    ///Department id
    @Field() int? group, //code
    ///Location id
    @Field() int? location, //code
    @Field() required String role, //code
    ///Language code
    @Field() String? language,

    ///Mandatory for new user
    @Field() String? upass,

    /// User title code
    @Field() String? title, //code
    @Field() String? birthday,

    ///Country code
    @Field() String? nationality, //code
    ///Religion id
    @Field() int? religion, //code
    ///Ethnics id
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

    ///If true 1 - false 0
    @Field() String? isActive,

    ///If true 1 - false 0
    @Field() int? exEmail,
    @Field() double? latitude,
    @Field() double? longitude,

    ///If true 1 - false 0
    @Field() String? groupAdmin,

    ///If true 1 - false 0
    @Field() String? locationAdmin,
    @Field() String? loginRequired,
    @Field() String? loginmethods, //List<int>().toString()
    @Field() String? email,
  });

  @GET("/api/fe/details")
  Future<HttpResponse> getDetails();

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

  @POST("/api/fe/handovertypes/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> postHandoverTypes({
    @Path() int? id,
    @Field() required String title,
    @Field() required bool active,
  });

  @DELETE("/api/fe/handovertypes/{id}")
  @FormUrlEncoded()
  Future<HttpResponse> deleteHandoverTypes(@Path() int id);

  @DELETE("/api/fe/locations/{id}")
  Future<HttpResponse> deleteLocation(@Path() int id);

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
    @Field() required bool damages,
  });

  @DELETE("/api/fe/checklisttemplates/{id}/rooms")
  Future<HttpResponse> deleteChecklistTemplateRoom(
      @Path() int id, @Query("name") String name);

  @DELETE("/api/fe/shifts/{id}/details")
  Future<HttpResponse> deleteProperty(@Path() int id);

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

  @GET("/api/fe/shifts/{id}/specialrate")
  Future<HttpResponse> getPropertySpecialRate(@Path() int id);

  @POST("/api/fe/shifts/{shiftId}/specialrate")
  @FormUrlEncoded()
  Future<HttpResponse> postPropertySpecialRate({
    ///Shift ID, 0 to create new
    @Path() int? shiftId,
    @Field() required String name,
    @Field() required double rate,
    @Field() required int minWorkTime,
    @Field() required int minPaidTime,
    @Field() required bool splitTime,
  });

  @DELETE("/api/fe/shifts/{id}/specialrate")
  Future<HttpResponse> deletePropertySpecialRate(
      @Path() int id, @Query("specialRateId") int specialRateId);

  @GET("/api/fe/shifts/{id}/staff")
  Future<HttpResponse> getPropertyStaff(@Path() int id);

  @POST("/api/fe/shifts/{id}/staff")
  @FormUrlEncoded()
  Future<HttpResponse> postPropertyStaff({
    @Path() int? id,
    @Field() required int groupId,
    @Field() required int numberOfStaff,
    @Field() int? maxOfStaff,
  });

  @DELETE("/api/fe/shifts/{id}/staff")
  Future<HttpResponse> deletePropertyStaff(
      @Path('id') int shiftId, @Query("groupId") int groupId);

  @GET("/api/fe/shifts/{id}/qualification")
  Future<HttpResponse> getPropertyQualification(@Path() int id);

  @POST("/api/fe/shifts/{id}/qualification")
  @FormUrlEncoded()
  Future<HttpResponse> postPropertyQualification({
    @Path() int? id,
    @Field() required int qualificationId,
    @Field() required int numberOfStaff,
    @Field() int? levelId,
  });

  @DELETE("/api/fe/shifts/{id}/qualification")
  Future<HttpResponse> deletePropertyQualification(
      @Path('id') int shiftId, @Query("qualificationId") int qualificationId);

  @GET("/api/fe/approvals")
  Future<HttpResponse> getApprovals();

  @POST("/api/fe/approvals")
  @FormUrlEncoded()
  Future<HttpResponse> postApprovals({
    @Field() required int id,

    ///true or false
    @Field() required bool status,
    @Field() required String? comment,
  });

  //get current stock list
  @GET("/api/fe/stocklist/{warehouseId}/current")
  Future<HttpResponse> getStockList(@Path() int warehouseId);

  //approve user qualification
  @POST("/api/fe/userdetails/{userId}/userqualificationapprove")
  @FormUrlEncoded()
  Future<HttpResponse> approveUserQualification(
    @Path() int userId, {
    @Field() required int userqualificationId,
  });

  //shiftrelease
  @POST("/api/fe/shiftrelease/{allocationId}")
  @FormUrlEncoded()
  Future<HttpResponse> postShiftRelease(
    @Path() int allocationId, {
    /// approve, deny, reset, publish, unpublish
    @Field() required String action,
    @Field() String? comment,
  });

  //get checklist
  @GET("/api/fe/checklists")
  Future<HttpResponse> getChecklists(
      {@Query('page') required int page,
      @Query('page_size') int? pageSize,
      @Query("filters") String? filters});

  //get checklist pdf
  @GET("/api/fe/checklist/{id}/pdf")
  Future<HttpResponse> getChecklistPdfs(
      {
      ///if multiple ids, separate with comma
      @Path() required String id});

  //get checklist images
  @GET("/api/fe/checklist/{id}/images")
  Future<HttpResponse> getChecklistImages(
      {
      ///if multiple ids, separate with comma
      @Path() required String id});

  //get stock history
  @GET("/api/fe/stockhistory/{storageid}/{itemid}")
  Future<HttpResponse> getStockHistory(
      {@Path() required int storageid, @Path() required int itemid});

  //todo:
  //get account user availability
  @GET("/api/fe/userdetails/{id}/availability")
  Future<HttpResponse> getAccountUserAvailability(@Path() String id);

  //todo:
  //delete account user availability
  @DELETE("/api/fe/userdetails/{id}/availability")
  Future<HttpResponse> deleteAccountUserAvailability(@Path() String id);

  //todo:
  //create account user availability: startDate, endDate, startTime, endTime, isFullDay, comment
  @POST("/api/fe/userdetails/{id}/availability")
  @FormUrlEncoded()
  Future<HttpResponse> createAccountUserAvailability({
    @Field() required String startDate,
    @Field() String? endDate,
    @Field() String? startTime,
    @Field() String? endTime,
    @Field() required bool isFullDay,
    @Field() String? comment,
  });
}
