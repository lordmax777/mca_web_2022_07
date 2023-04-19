import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';

import '../../../manager/models/list_all_md.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../theme/theme.dart';
import '../../../utils/global_functions.dart';
import '../create_shift_popup.dart';

class CreatedClientReturnValue {
  final int? clientId;
  final int? locationId;

  const CreatedClientReturnValue({this.clientId, this.locationId});
}

class ClientAddressForm {
  String? addressLine1;
  String? addressLine2;
  String? addressCity;
  String? addressCounty;
  String? addressPostcode;
  String? addressCountryId;
  double? latitude;
  double? longitude;
  int? radius;

  ClientAddressForm({
    this.addressLine1,
    this.addressLine2,
    this.addressCity,
    this.addressPostcode = kDebugMode ? "NW1 8PR" : null,
    this.addressCountryId,
  });
}

enum ClientFormType { client, location }

class ClientForm extends StatefulWidget {
  final AppState state;
  final ClientFormType type;
  const ClientForm(
      {Key? key, required this.state, this.type = ClientFormType.client})
      : super(key: key);

  @override
  State<ClientForm> createState() => _ClientFormState();
}

class _ClientFormState extends State<ClientForm> {
  final ScrollController scrollController = ScrollController();

  AppState get state => widget.state;
  List<ListCurrency> get currencies => state.generalState.currencies;
  List<ListCountry> get countries => state.generalState.countries;
  List<ListPaymentMethods> get paymentMethods =>
      state.generalState.paymentMethods;
  ClientFormType get type => widget.type;
  bool get isClient => type == ClientFormType.client;
  bool get isLocation => type == ClientFormType.location;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController contactName =
      TextEditingController(text: kDebugMode ? "testName" : "");
  final TextEditingController companyName =
      TextEditingController(text: kDebugMode ? "testCompany" : "");
  final TextEditingController phoneNumber =
      TextEditingController(text: kDebugMode ? "111111" : "");
  final TextEditingController email =
      TextEditingController(text: kDebugMode ? "test@gmail.com" : "");
  final TextEditingController notes = TextEditingController();
  final ClientAddressForm address = ClientAddressForm();
  final TextEditingController ipAddress = TextEditingController();
  String? currentIpAddress;

  int? currencyId;
  int? paymentMethodId;
  int? payingDays;
  bool isFixedIpAddress = false;

  bool isDeliverAtDifferentLocation = false;

  @override
  void dispose() {
    contactName.dispose();
    companyName.dispose();
    phoneNumber.dispose();
    email.dispose();
    notes.dispose();
    scrollController.dispose();
    ipAddress.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      onIpLookup();
      if (kDebugMode) {
        await lookupAddress();
      }
    });
  }

  Future<void> onIpLookup() async {
    final ip = await getIpAddress();
    if (ip != null) {
      setState(() {
        currentIpAddress = ip;
      });
    }
  }

  Future<void> lookupAddress() async {
    final res = await getAddressFromPostCode(address.addressPostcode!);
    if (res != null) {
      String long = res.geometry.location.lng.toString();
      String lat = res.geometry.location.lat.toString();
      String? countryCode;
      String? countryName;
      String? city;
      String? addrs;

      for (var element in res.addressComponents) {
        if (element.types.contains(Component.country)) {
          countryCode = element.shortName;
          countryName = element.longName;
        }
        if (element.types.contains("postal_town")) {
          city = element.longName;
        }
        if (element.types.contains(Component.route)) {
          addrs = element.longName;
        }
      }
      setState(() {
        address.addressCountryId = countryCode;
        address.addressCity = city;
        address.latitude = double.tryParse(lat);
        address.longitude = double.tryParse(long);
        address.addressLine1 = addrs;
      });
      showError(
          "Location Found\n"
          "Country: $countryName\n"
          "Latitude: $lat\n"
          "Longitude: $long\n"
          "City: $city",
          titleMsg: "Success");
    } else {
      showError("Location Not Found");
    }
  }

  final fieldWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding:
          const EdgeInsets.only(left: 60, top: 20, bottom: 20, right: 50),
      title: Row(
        children: [
          if (type == ClientFormType.client)
            const Text("Create new client")
          else if (type == ClientFormType.location)
            const Text("Create new location"),
          const Spacer(),
          IconButton(
            onPressed: () {
              onWillPop(context).then((value) {
                if (value) {
                  context.popRoute();
                }
              });
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: RawScrollbar(
        thumbVisibility: true,
        trackVisibility: true,
        trackColor: Colors.grey.withOpacity(0.6),
        thickness: 10,
        thumbColor: ThemeColors.MAIN_COLOR.withOpacity(0.7),
        controller: scrollController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(right: 20),
          controller: scrollController,
          child: Form(
            key: _formKey,
            child: SpacedColumn(verticalSpace: 16, children: [
              if (isClient)
                labelWithField(
                  "Contact Name",
                  TextInputWidget(
                    width: fieldWidth,
                    controller: contactName,
                    hintText: "Enter name",
                    isRequired: true,
                  ),
                ),
              if (isClient)
                labelWithField(
                  "Company Name",
                  TextInputWidget(
                    width: fieldWidth,
                    isRequired: true,
                    controller: companyName,
                    hintText: "Enter company name",
                  ),
                ),
              labelWithField(
                "Phone Number",
                TextInputWidget(
                  width: fieldWidth,
                  controller: phoneNumber,
                  isRequired: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  hintText: "Enter phone number",
                ),
              ),
              labelWithField(
                "Email",
                TextInputWidget(
                  width: fieldWidth,
                  controller: email,
                  isRequired: true,
                  validator: (p0) {
                    if (p0 != null) {
                      //validate using Regex
                      if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(p0)) {
                        return "Invalid email";
                      }
                    }

                    return null;
                  },
                  hintText: "Enter email",
                ),
              ),
              if (isClient)
                labelWithField(
                  "Payment terms",
                  TextInputWidget(
                    width: fieldWidth,
                    isRequired: true,
                    controller:
                        TextEditingController(text: payingDays?.toString()),
                    hintText: "Enter payment terms",
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) => payingDays = int.tryParse(value),
                  ),
                ),
              if (isClient)
                labelWithField(
                  "Currency",
                  DropdownWidgetV2(
                    hintText: "Select currency",
                    dropdownBtnWidth: fieldWidth,
                    isRequired: true,
                    dropdownOptionsWidth: fieldWidth,
                    items: currencies
                        .map((e) => CustomDropdownValue(name: e.sign))
                        .toList(),
                    value: CustomDropdownValue(
                        name: currencies
                            .firstWhereOrNull(
                                (element) => element.id == currencyId)
                            ?.sign),
                    onChanged: (index) {
                      setState(() {
                        currencyId = currencies[index].id;
                      });
                    },
                  ),
                ),
              if (isClient)
                labelWithField(
                  "Payment Method",
                  DropdownWidgetV2(
                    hasSearchBox: true,
                    isRequired: true,
                    hintText: "Select payment method",
                    dropdownBtnWidth: fieldWidth,
                    dropdownOptionsWidth: fieldWidth,
                    items: paymentMethods
                        .map((e) => CustomDropdownValue(name: e.name))
                        .toList(),
                    value: CustomDropdownValue(
                        name: paymentMethods
                            .firstWhereOrNull(
                                (element) => element.id == paymentMethodId)
                            ?.name),
                    onChanged: (index) {
                      setState(() {
                        paymentMethodId = paymentMethods[index].id;
                      });
                    },
                  ),
                ),
              if (isClient)
                labelWithField(
                  "Notes",
                  TextInputWidget(
                    width: fieldWidth,
                    controller: notes,
                    maxLines: 4,
                    hintText: "Enter notes",
                  ),
                ),
              labelWithField(
                "Address Line 1",
                TextInputWidget(
                  width: fieldWidth,
                  controller: TextEditingController(text: address.addressLine1),
                  hintText: "Enter address line 1",
                  isRequired: true,
                  onChanged: (value) => address.addressLine1 = value,
                ),
              ),
              labelWithField(
                "Address Line 2",
                TextInputWidget(
                  width: fieldWidth,
                  controller: TextEditingController(text: address.addressLine2),
                  hintText: "Enter address line 2",
                  isRequired: true,
                  onChanged: (value) => address.addressLine2 = value,
                ),
              ),
              labelWithField(
                "City",
                TextInputWidget(
                  width: fieldWidth,
                  controller: TextEditingController(text: address.addressCity),
                  hintText: "Enter city",
                  isRequired: true,
                  onChanged: (value) => address.addressCity = value,
                ),
              ),
              labelWithField(
                "City",
                TextInputWidget(
                  width: fieldWidth,
                  controller: TextEditingController(text: address.addressCity),
                  hintText: "Enter city",
                  isRequired: true,
                  onChanged: (value) => address.addressCity = value,
                ),
              ),
              labelWithField(
                "County",
                TextInputWidget(
                  width: fieldWidth,
                  controller:
                      TextEditingController(text: address.addressCounty),
                  hintText: "Enter county",
                  isRequired: true,
                  onChanged: (value) => address.addressCounty = value,
                ),
              ),
              labelWithField(
                "Postcode",
                TextInputWidget(
                  width: fieldWidth,
                  controller:
                      TextEditingController(text: address.addressPostcode),
                  hintText: "Enter postcode",
                  isRequired: true,
                  onChanged: (value) => address.addressPostcode = value,
                ),
              ),
              labelWithField(
                "Country",
                DropdownWidgetV2(
                  hasSearchBox: true,
                  hintText: "Select country",
                  dropdownBtnWidth: fieldWidth,
                  dropdownOptionsWidth: fieldWidth,
                  isRequired: true,
                  items: countries
                      .map((e) => CustomDropdownValue(name: e.name))
                      .toList(),
                  value: CustomDropdownValue(
                      name: countries
                              .firstWhereOrNull((element) =>
                                  element.code == address.addressCountryId)
                              ?.name ??
                          ""),
                  onChanged: (index) {
                    setState(() {
                      address.addressCountryId = countries[index].code;
                    });
                  },
                ),
              ),
              ButtonSmall(
                text: "Lookup Address",
                onPressed: () {
                  Get.showOverlay(
                    asyncFunction: () async {
                      try {
                        await lookupAddress();
                      } catch (e) {
                        if (address.addressPostcode == null ||
                            address.addressPostcode!.isEmpty) {
                          showError("Postcode is required");
                        }
                      }
                    },
                    loadingWidget: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              labelWithField(
                  "Service Delivered at a different address",
                  toggle(isDeliverAtDifferentLocation, (value) {
                    setState(() {
                      isDeliverAtDifferentLocation = value;
                    });
                  })),
              if (!isDeliverAtDifferentLocation)
                labelWithField(
                    "Fixed IP Address",
                    toggle(isFixedIpAddress, (value) {
                      setState(() {
                        isFixedIpAddress = value;
                      });
                    })),
              if (!isDeliverAtDifferentLocation)
                Column(
                  children: [
                    labelWithField(
                        "Current IP Address: ${currentIpAddress ?? ""}", null),
                    if (currentIpAddress != null)
                      ButtonSmall(
                        text: "Use Current IP Address",
                        onPressed: () {
                          ipAddress.text = currentIpAddress!;
                        },
                      ),
                  ],
                ),
              if (!isDeliverAtDifferentLocation)
                labelWithField(
                  "IP Addresses",
                  SpacedColumn(
                    verticalSpace: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextInputWidget(
                        width: fieldWidth,
                        maxLines: 3,
                        isRequired: isFixedIpAddress,
                        controller: ipAddress,
                      ),
                      KText(
                          fontWeight: FWeight.medium,
                          fontSize: 12.0,
                          textColor: ThemeColors.gray8,
                          isSelectable: false,
                          text:
                              'Multiple IP addresses can be separated by a comma(,)'),
                    ],
                  ),
                ),
            ]),
          ),
        ),
      ),
      actions: [
        ButtonLarge(
            text: "Cancel",
            onPressed: () {
              onWillPop(context).then((value) {
                if (value) {
                  context.popRoute();
                }
              });
            }),
        ButtonLarge(
            text: "Save",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Get.showOverlay(
                  asyncFunction: () async {
                    if (isClient) {
                      final ApiResponse createdClient =
                          await createClient(fetchAllParams: false);
                      if (createdClient.success) {
                        final ApiResponse createdLocation =
                            await createLocation();
                        if (createdLocation.success) {
                          context.popRoute(CreatedClientReturnValue(
                              clientId: createdClient.data,
                              locationId: createdLocation.data));
                        } else {
                          await appStore.dispatch(GetAllParamListAction());
                          //Location already exists
                          if (createdLocation.resCode == 409) {
                            context.popRoute(CreatedClientReturnValue(
                                clientId: createdClient.data,
                                locationId: createdLocation.data));
                            return;
                          }
                          showError(ApiHelpers.getRawDataErrorMessages(
                                      createdLocation)
                                  .isEmpty
                              ? "Error"
                              : ApiHelpers.getRawDataErrorMessages(
                                  createdLocation));
                        }
                      } else {
                        showError(
                          ApiHelpers.getRawDataErrorMessages(createdClient)
                                  .isEmpty
                              ? "Error"
                              : ApiHelpers.getRawDataErrorMessages(
                                  createdClient),
                        );
                      }
                    }
                    if (isLocation) {
                      final ApiResponse createdLoc = await createLocation();
                      if (createdLoc.success) {
                        context.popRoute(CreatedClientReturnValue(
                            locationId: createdLoc.data));
                      } else {
                        //Location already exists
                        if (createdLoc.resCode == 409) {
                          context.popRoute(CreatedClientReturnValue(
                              locationId: createdLoc.data));
                          return;
                        }
                        showError(
                          ApiHelpers.getRawDataErrorMessages(createdLoc).isEmpty
                              ? "Error"
                              : ApiHelpers.getRawDataErrorMessages(createdLoc),
                        );
                      }
                    }
                  },
                  loadingWidget: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      ],
    );
  }

  Future<ApiResponse> createLocation({bool fetchAllParams = true}) async {
    final ApiResponse res = await restClient()
        .postLocation(
          base: false,
          timelimit: false,
          sendChecklist: true,
          anywhere: false,
          radius: 100.toString(),
          phoneLandline: "",
          phoneFax: "",
          name: "${address.addressLine1} ${address.addressPostcode}",
          addressLine2: address.addressLine2,
          addressCounty: address.addressCounty,
          active: true,
          latitude: address.latitude.toString(),
          longitude: address.latitude.toString(),
          fixedipaddress: isFixedIpAddress,
          addressCity: address.addressCity!,
          addressCountry: address.addressCountryId!,
          addressLine1: address.addressLine1!,
          phoneMobile: phoneNumber.text,
          email: email.text,
          addressPostcode: address.addressPostcode!,
          ipaddress: ipAddress.text,
        )
        .nocodeErrorHandler();
    if (res.success) {
      if (fetchAllParams) {
        await appStore.dispatch(GetAllParamListAction());
      }
    }
    return res;
  }

  Future<ApiResponse> createClient({bool fetchAllParams = true}) async {
    final ApiResponse res = await restClient()
        .createClient(
          0,
          active: true,
          name: contactName.text,
          company: companyName.text,
          phone: phoneNumber.text,
          email: email.text,
          addressLine1: address.addressLine1!,
          addressCity: address.addressCity!,
          addressPostcode: address.addressPostcode!,
          addressCountry: address.addressCountryId!,
          currencyId: currencyId!,
          paymentMethodId: paymentMethodId ?? 1,
          payingDays: payingDays!,
        )
        .nocodeErrorHandler();
    if (res.success) {
      if (fetchAllParams) {
        await appStore.dispatch(GetAllParamListAction());
      }
    }
    return res;
  }
}
