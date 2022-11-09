import 'dart:convert';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mca_web_2022_07/app.dart';
import 'package:mca_web_2022_07/manager/model_exporter.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/sets/app_state.dart';
import 'package:mca_web_2022_07/manager/router/router.gr.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/locations_controller.dart';
import 'package:mca_web_2022_07/theme/theme.dart';
import '../../../comps/dropdown_widget1.dart';
import '../../../manager/redux/sets/state_value.dart';

import 'package:google_maps_webservice/geocoding.dart';

import '../../../manager/redux/states/general_state.dart';
import '../../../manager/rest/nocode_helpers.dart';
import '../../../manager/rest/rest_client.dart';

class NewLocationController extends GetxController {
  static NewLocationController get to => Get.find();

  static final GoogleMapsGeocoding geocoding =
      GoogleMapsGeocoding(apiKey: Constants.googleMapApiKey);

  //General
  final RxInt _id = RxInt(-1);
  int get id => _id.value;
  set setId(int value) => _id.value = value;
  bool get isUpdate => _id.value != -1;

  GlobalKey<FormState> generalFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final Rx<CodeMap> _status = CodeMap(name: null, code: null).obs;
  CodeMap get status => _status.value;
  set setStatus(CodeMap value) => _status.value = value;
  final RxBool _isLocationBound = false.obs;
  bool get isLocationBound => _isLocationBound.value;
  set setIsLocationBound(bool value) => _isLocationBound.value = value;
  final TextEditingController ipAddressesController = TextEditingController();
  List<String> get ipAddressesList => ipAddressesController.text.split(',');
  final RxBool _isFixedIpAddress = false.obs;
  bool get isFixedIpAddress => _isFixedIpAddress.value;
  final RxString _ipAddress = ''.obs;
  String get ipAddress => _ipAddress.value;
  set setIpAddress(String value) => _ipAddress.value = value;

  //Contact
  GlobalKey<FormState> contactFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController landlineController = TextEditingController();
  final TextEditingController faxController = TextEditingController();
  final RxBool _isSendChecklist = false.obs;
  bool get isSendChecklist => _isSendChecklist.value;
  set setIsSendChecklist(bool value) => _isSendChecklist.value = value;

  //Address
  GlobalKey<FormState> addressFormKey = GlobalKey<FormState>();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countyController = TextEditingController();
  final Rx<CodeMap> _country = CodeMap(name: null, code: null).obs;
  CodeMap get country => _country.value;
  set setCountry(CodeMap value) => _country.value = value;
  final RxBool _isPostCodeError = false.obs;
  bool get isPostCodeError => _isPostCodeError.value;
  set setPostCodeError(bool value) => _isPostCodeError.value = value;

  //GPS
  GlobalKey<FormState> gpsFormKey = GlobalKey<FormState>();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  @override
  void onClose() {
    nameController.clear();
    ipAddressesController.clear();
    emailController.clear();
    phoneController.clear();
    landlineController.clear();
    faxController.clear();
    streetController.clear();
    postCodeController.clear();
    cityController.clear();
    countyController.clear();
    latitudeController.clear();
    longitudeController.clear();
    radiusController.clear();

    setStatus = CodeMap(name: null, code: null);
    setCountry = CodeMap(name: null, code: null);
    setIsLocationBound = false;
    setPostCodeError = false;
    setIsSendChecklist = false;

    super.onClose();
  }

  //FUNCTIONS
  @override
  void onInit() async {
    super.onInit();
    await _onIpLookup();

    // if (kDebugMode) {
    //   nameController.text = "Test Location Name 1";
    //   _status.value = CodeMap(name: "Active", code: "true");
    //   onLocationBoundChange(true);
    //   ipAddressesController.text = ipAddress;
    //   emailController.text = "test@mail.ru";
    //   phoneController.text = "123456789";
    //   landlineController.text = "123456789";
    //   faxController.text = "123456789";
    //   onSendChecklistChange(true);
    //   streetController.text = "Test Street";
    //   postCodeController.text = "NW1 8PR";
    //   cityController.text = "London";
    //   countyController.text = "London";
    //   setCountry = CodeMap(name: "United Kingdom", code: "GB");
    //   radiusController.text = "300";
    //   await onGpsLookupPress();
    // }
  }

  void onStatusChange(DpItem value) {
    _status.value = CodeMap(name: value.name, code: value.item.key.toString());
    logger(status.toJson());
  }

  void onLocationBoundChange(bool? value) {
    if (value != null) {
      _isLocationBound.value = value;
    }
  }

  void onFixedIpChange(bool? value) {
    if (value != null) {
      _isFixedIpAddress.value = value;
    }
  }

  void onSendChecklistChange(bool? value) {
    if (value != null) {
      _isSendChecklist.value = value;
    }
  }

  void onCountryChange(DpItem value) {
    setCountry =
        CodeMap(name: value.name, code: (value.item as ListCountry).code);
  }

  Future<void> onGpsLookupPress() async {
    setPostCodeError = false;
    if (postCodeController.text.isEmpty) {
      setPostCodeError = true;
      return;
    }
    await searchByPostCode();
  }

  Future<void> _onIpLookup() async {
    final ip = await Ipify.ipv4();
    if (ip.isNotEmpty) {
      setIpAddress = ip;
      update(['general']);
    }
  }

  Future<void> _createNewLocation() async {
    showLoading();
    final ApiResponse response = await restClient()
        .postLocation(
          id: id,
          name: nameController.text,
          active: status.code == 'true',
          latitude: latitudeController.text,
          longitude: longitudeController.text,
          anywhere: isLocationBound,
          radius: radiusController.text,
          base: false,
          fixedipaddress: isFixedIpAddress,
          sendChecklist: isSendChecklist,
          timelimit: false,
          email: emailController.text,
          phoneLandline: landlineController.text,
          phoneMobile: phoneController.text,
          addressPostcode: postCodeController.text,
          addressLine1: streetController.text,
          addressCity: cityController.text,
          addressCountry: country.code,
          addressCounty:
              countyController.text.isEmpty ? null : countyController.text,
          ipaddress: ipAddressesController.text.isEmpty
              ? null
              : ipAddressesController.text,
          phoneFax: faxController.text.isEmpty ? null : faxController.text,
        )
        .nocodeErrorHandler();

    if (response.success) {
      logger(response.data);
      LocationsController.to.gridStateManager.toggleAllRowChecked(false);
      LocationsController.to.setDeleteBtnOpacity = 0.5;
      LocationsController.to.searchController.clear();
      await appStore.dispatch(GetAllLocationsAction());
      await closeLoading();
      appRouter.navigate(const LocationsListRoute());
    } else {
      await closeLoading();
      showError(jsonDecode(response.data)['errors']
          .values
          .first
          .join(",")
          .toString());
    }
  }

  Future<void> onSave() async {
    if (ipAddress.isEmpty) {
      showError("Please check your internet connection");
      return;
    }

    if (generalFormKey.currentState!.validate() &&
        contactFormKey.currentState!.validate() &&
        addressFormKey.currentState!.validate() &&
        gpsFormKey.currentState!.validate()) {
      await _createNewLocation();
    }
  }

  Future<void> searchByPostCode() async {
    GeocodingResponse response = await geocoding.searchByComponents([
      if (country.code != null) Component(Component.country, country.code!),
      Component(Component.postalCode, postCodeController.text),
    ]);

    if (response.isOkay) {
      final res = response.results.first;
      String long = res.geometry.location.lng.toString();
      String lat = res.geometry.location.lat.toString();
      String? countryCode;
      String? countryName;

      for (var element in res.addressComponents) {
        if (element.types.contains(Component.country)) {
          countryCode = element.shortName;
          countryName = element.longName;
        }
      }
      CodeMap country = CodeMap(name: countryName, code: countryCode);

      setCountry = country;
      latitudeController.text = lat;
      longitudeController.text = long;

      showError("Location Found", titleMsg: "Success");
    } else {
      showError("Location Not Found");
    }
  }
}
