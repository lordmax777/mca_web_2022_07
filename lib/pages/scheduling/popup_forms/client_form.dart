import 'package:auto_route/auto_route.dart';
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

class CreatedClient {
  final String contactName;
  final String companyName;
  final String phoneNumber;
  final String email;
  final String notes;
  final ClientAddressForm address;
  final int currencyId;
  final String countryId;
  final int paymentMethodId;
  final int payingDays;
  final bool isActive;

  CreatedClient({
    required this.contactName,
    required this.companyName,
    required this.phoneNumber,
    required this.email,
    required this.notes,
    required this.address,
    required this.currencyId,
    required this.countryId,
    required this.paymentMethodId,
    required this.payingDays,
    required this.isActive,
  });
}

class ClientAddressForm {
  String? addressLine1;
  String? addressCity;
  String? addressPostcode;
  String? addressCountryId;
  double? latitude;
  double? longitude;
  int? radius;

  ClientAddressForm({
    this.addressLine1,
    this.addressCity,
    this.addressPostcode,
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
  final GoogleMapsGeocoding geocoding =
      GoogleMapsGeocoding(apiKey: Constants.googleMapApiKey);

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

  final TextEditingController contactName = TextEditingController();
  final TextEditingController companyName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController notes = TextEditingController();
  final ClientAddressForm address = ClientAddressForm();
  final TextEditingController ipAddress = TextEditingController();
  String? currentIpAddress;

  int? currencyId;
  int? paymentMethodId;
  int? payingDays;
  bool isActive = true;
  bool isFixedIpAddress = true;
  bool isAnywhere = false;

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
      _onIpLookup();
    });
  }

  Future<void> _onIpLookup() async {
    final ip = await getIpAddress();
    if (ip != null) {
      setState(() {
        currentIpAddress = ip;
      });
    }
  }

  Future<void> lookupAddress() async {
    GeocodingResponse response = await geocoding.searchByComponents([
      if (address.addressCountryId != null)
        Component(Component.country, address.addressCountryId!),
      if (address.addressPostcode != null)
        Component(Component.postalCode, address.addressPostcode!),
    ]);

    if (response.isOkay) {
      final res = response.results.first;
      String long = res.geometry.location.lng.toString();
      String lat = res.geometry.location.lat.toString();
      String? countryCode;
      String? countryName;
      String? city;
      String? addrs;

      for (var element in res.addressComponents) {
        logger("element: ${element.toJson()}");
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
        if (addrs != null) {
          address.addressLine1 = addrs + " " + address.addressPostcode!;
        }
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding:
          const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 2),
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
              labelWithField(
                "Contact Name",
                TextInputWidget(
                  width: 300,
                  controller: contactName,
                  hintText: "Enter name",
                  isRequired: true,
                ),
              ),
              labelWithField(
                "Company Name",
                TextInputWidget(
                  width: 300,
                  isRequired: true,
                  controller: companyName,
                  hintText: "Enter company name",
                ),
              ),
              labelWithField(
                "Phone Number",
                TextInputWidget(
                  width: 300,
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
                  width: 300,
                  controller: email,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "Email is required";
                    }
                    //validate using Regex
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(p0)) {
                      return "Invalid email";
                    }

                    return null;
                  },
                  isRequired: true,
                  hintText: "Enter email",
                ),
              ),
              labelWithField(
                "Notes",
                TextInputWidget(
                  width: 300,
                  controller: notes,
                  maxLines: 4,
                  hintText: "Enter notes",
                ),
              ),
              labelWithField(
                  "Current IP Address: ${currentIpAddress ?? ""}", null),
              labelWithField(
                "IP Addresses",
                SpacedColumn(
                  verticalSpace: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInputWidget(
                      width: 300,
                      maxLines: 3,
                      isRequired: isAnywhere || isFixedIpAddress,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  labelWithField(
                      "Fixed IP Address",
                      toggle(isFixedIpAddress, (value) {
                        setState(() {
                          isFixedIpAddress = value;
                        });
                      })),
                  // labelWithField(
                  //     "Anywhere",
                  //     toggle(isAnywhere, (value) {
                  //       setState(() {
                  //         isAnywhere = value;
                  //       });
                  //     })),
                ],
              ),
              labelWithField(
                "Country",
                DropdownWidgetV2(
                  hasSearchBox: true,
                  hintText: "Select country",
                  dropdownBtnWidth: 300,
                  dropdownOptionsWidth: 300,
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
                        showError(e.toString());
                      }
                    },
                    loadingWidget: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
              labelWithField(
                "City",
                TextInputWidget(
                  width: 300,
                  controller: TextEditingController(text: address.addressCity),
                  hintText: "Enter city",
                  isRequired: true,
                  onChanged: (value) => address.addressCity = value,
                ),
              ),
              labelWithField(
                "Address",
                TextInputWidget(
                  width: 300,
                  controller: TextEditingController(text: address.addressLine1),
                  hintText: "Enter address",
                  isRequired: true,
                  onChanged: (value) => address.addressLine1 = value,
                ),
              ),
              labelWithField(
                "Postcode",
                TextInputWidget(
                  width: 300,
                  controller:
                      TextEditingController(text: address.addressPostcode),
                  hintText: "Enter postcode",
                  isRequired: true,
                  onChanged: (value) => address.addressPostcode = value,
                ),
              ),
              labelWithField(
                "Currency",
                DropdownWidgetV2(
                  hintText: "Select currency",
                  dropdownBtnWidth: 300,
                  isRequired: true,
                  dropdownOptionsWidth: 300,
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
              labelWithField(
                "Payment Method",
                DropdownWidgetV2(
                  hasSearchBox: true,
                  isRequired: true,
                  hintText: "Select payment method",
                  dropdownBtnWidth: 300,
                  dropdownOptionsWidth: 300,
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
              labelWithField(
                "Paying Days",
                TextInputWidget(
                  width: 300,
                  isRequired: true,
                  controller:
                      TextEditingController(text: payingDays?.toString()),
                  hintText: "Enter paying days",
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) => payingDays = int.tryParse(value),
                ),
              ),
              labelWithField(
                  "Active",
                  toggle(isActive, (p0) {
                    setState(() {
                      isActive = p0;
                    });
                  })),
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
                final CreatedClient client = CreatedClient(
                    address: address,
                    companyName: companyName.text,
                    contactName: contactName.text,
                    currencyId: currencyId!,
                    email: email.text,
                    notes: notes.text,
                    phoneNumber: phoneNumber.text,
                    payingDays: payingDays!,
                    countryId: address.addressCountryId!,
                    paymentMethodId: paymentMethodId ?? 1,
                    isActive: isActive);
                Get.showOverlay(
                  asyncFunction: () async {
                    try {
                      final ApiResponse res = await restClient()
                          .createClient(
                            0,
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
                            active: isActive,
                          )
                          .nocodeErrorHandler();
                      if (res.success) {
                        await appStore.dispatch(GetAllParamListAction());
                        context.popRoute(res.data);
                      } else {
                        showError(
                          ApiHelpers.getRawDataErrorMessages(res).isEmpty
                              ? "Error"
                              : ApiHelpers.getRawDataErrorMessages(res),
                        );
                      }
                    } catch (e) {
                      showError("Unknown error");
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
}
