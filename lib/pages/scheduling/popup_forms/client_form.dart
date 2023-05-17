import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mca_web_2022_07/manager/general_controller.dart';
import 'package:mca_web_2022_07/manager/redux/middlewares/users_middleware.dart';
import 'package:mca_web_2022_07/manager/redux/states/general_state.dart';
import 'package:mca_web_2022_07/manager/rest/nocode_helpers.dart';
import 'package:mca_web_2022_07/manager/rest/rest_client.dart';

import '../../../manager/model_exporter.dart';
import '../../../manager/models/list_all_md.dart';
import '../../../manager/models/location_item_md.dart';
import '../../../manager/redux/sets/app_state.dart';
import '../../../theme/theme.dart';
import '../../../utils/global_functions.dart';
import '../create_shift_popup.dart';

class CreatedClientReturnValue {
  final int? clientId;
  final int? locationId;

  const CreatedClientReturnValue({this.clientId, this.locationId});

  @override
  String toString() {
    return 'CreatedClientReturnValue(clientId: $clientId, locationId: $locationId)';
  }
}

// class ClientAddressForm {
//   String? line1;
//   String? line2;
//   String? city;
//   String? addressCounty;
//   String? postcode;
//   String? country;
//   double? latitude;
//   double? longitude;
//   int? radius;
//
//   ClientAddressForm({
//     this.line1,
//     this.line2,
//     this.city,
//     this.postcode = kDebugMode ? "NW1 8PR" : null,
//     this.country,
//   });
//
//   // from Address
//   ClientAddressForm.fromAddress(Address address) {
//     line1 = address.line1;
//     line2 = address.line2;
//     city = address.city;
//     addressCounty = address.county;
//     postcode = address.postcode;
//     country = address.country;
//     latitude = address.latitude.toDouble();
//     longitude = address.longitude.toDouble();
//     radius = address.radius.toInt();
//   }
// }

enum ClientFormType {
  client,
  location;

  String get label {
    switch (this) {
      case ClientFormType.client:
        return "Create New Client";
      case ClientFormType.location:
        return "Create Location";
    }
  }
}

class ClientForm extends StatefulWidget {
  final AppState state;
  final ClientFormType type;
  final ClientInfoMd? selectedClient;
  final Address? selectedAddress;
  const ClientForm({
    Key? key,
    required this.state,
    this.type = ClientFormType.client,
    this.selectedClient,
    this.selectedAddress,
  }) : super(key: key);

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
  CompanyMd get company => GeneralController.to.companyInfo;
  ClientInfoMd? get selectedClient => widget.selectedClient;
  Address? get selectedAddress => widget.selectedAddress;
  String? get clientEmail => selectedClient?.email;
  String? get clientPhone => selectedClient?.phone;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController contactName = TextEditingController();
  final TextEditingController companyName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController notes = TextEditingController();
  Address address = Address.init(postcode: 'NW1 8PR');
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
      currencyId = currencies
          .firstWhereOrNull((element) => element.code == company.currency.code)
          ?.id;
      address.country = countries
              .firstWhereOrNull((element) => element.code == company.country)
              ?.code ??
          company.country;
      if (kDebugMode) {
        contactName.text = "Client";
        companyName.text = "Company";
        phoneNumber.text = "1234567890";
        email.text = "kom@gmail.com";
        payingDays = 20;
        paymentMethodId = paymentMethods.first.id;
        currencyId = currencies[2].id;
        notes.text = "Client Notes";
        address.line1 = "Address Line 1";
        address.line2 = "Address Line 2";
        address.city = "City";
        address.county = "County";
        address.postcode = "NW1 8PR";
        address.country = "GB";
        address.latitude = 51.5333;
        address.longitude = -0.1333;
        address.radius = 10;
      }
      if (selectedClient != null) {
        currencyId = int.parse(selectedClient!.currencyId);
        contactName.text = selectedClient!.name;
        companyName.text = selectedClient!.company ?? "";
        phoneNumber.text = selectedClient!.phone ?? "";
        email.text = selectedClient!.email ?? "";
        payingDays = selectedClient!.payingDays;
        paymentMethodId = int.tryParse(selectedClient!.paymentMethodId ?? "") ??
            paymentMethods.first.id;
        notes.text = selectedClient!.notes ?? "";
        address = selectedClient!.address;
      }
      if (selectedAddress != null) {
        address = selectedAddress!;
      }
    });
  }

  Future<void> onIpLookup() async {
    final ip = await getIpAddress();
    if (ip != null) {
      if (mounted) {
        setState(() {
          currentIpAddress = ip;
        });
      }
    }
  }

  Future<void> lookupAddress() async {
    final res = await getAddressFromPostCode(address.postcode,
        countryCode: address.country);
    if (res != null) {
      String long = res.geometry.location.lng.toString();
      String lat = res.geometry.location.lat.toString();
      String? country;
      String? countryName;
      String? city;
      String? addrs;

      for (var element in res.addressComponents) {
        if (element.types.contains(Component.country)) {
          country = element.shortName;
          countryName = element.longName;
        }
        if (element.types.contains("postal_town")) {
          city = element.longName;
        }
        if (element.types.contains(Component.route)) {
          addrs = element.longName;
        }
      }
      if (mounted) {
        setState(() {
          address.country = country ?? address.country;
          address.city = city ?? address.city;
          address.latitude = double.tryParse(lat) ?? address.latitude;
          address.longitude = double.tryParse(long) ?? address.longitude;
          address.line1 = addrs ?? address.line1;
        });
      }
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
          Text(type.label),
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
            child: rowOrColumnWrapper(false, [
              SpacedColumn(
                  verticalSpace: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    if (isClient || isLocation)
                      labelWithField(
                        "Phone Number",
                        SpacedColumn(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          verticalSpace: 8,
                          children: [
                            TextInputWidget(
                              width: fieldWidth,
                              controller: phoneNumber,
                              isRequired: isClient,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              hintText: "Enter phone number",
                            ),
                            if (isLocation)
                              KText(
                                  fontWeight: FWeight.medium,
                                  fontSize: 12.0,
                                  textColor: ThemeColors.gray8,
                                  isSelectable: false,
                                  text:
                                      'Leave blank to use client\'s phone number'),
                          ],
                        ),
                      ),
                    if (isClient || isLocation)
                      SpacedColumn(
                        verticalSpace: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithField(
                            "Email",
                            TextInputWidget(
                              width: fieldWidth,
                              controller: email,
                              isRequired: isClient,
                              validator: (p0) {
                                if (p0 != null) {
                                  //validate using Regex
                                  if (!RegExp(
                                          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(p0)) {
                                    return "Invalid email";
                                  }
                                }

                                return null;
                              },
                              hintText: "Enter email",
                            ),
                          ),
                          if (isLocation)
                            KText(
                                fontWeight: FWeight.medium,
                                fontSize: 12.0,
                                textColor: ThemeColors.gray8,
                                isSelectable: false,
                                text: 'Leave blank to use client\'s email'),
                        ],
                      ),
                  ]),
              SpacedColumn(
                verticalSpace: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                ],
              ),
              SpacedColumn(
                verticalSpace: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelWithField(
                    "Address Line 1",
                    TextInputWidget(
                      width: fieldWidth,
                      controller: TextEditingController(text: address.line1),
                      hintText: "Enter address line 1",
                      isRequired: true,
                      onChanged: (value) => address.line1 = value,
                    ),
                  ),
                  labelWithField(
                    "Address Line 2",
                    TextInputWidget(
                      width: fieldWidth,
                      controller: TextEditingController(text: address.line2),
                      hintText: "Enter address line 2",
                      onChanged: (value) => address.line2 = value,
                    ),
                  ),
                  labelWithField(
                    "City",
                    TextInputWidget(
                      width: fieldWidth,
                      controller: TextEditingController(text: address.city),
                      hintText: "Enter city",
                      isRequired: true,
                      onChanged: (value) => address.city = value,
                    ),
                  ),
                  labelWithField(
                    "County",
                    TextInputWidget(
                      width: fieldWidth,
                      controller: TextEditingController(text: address.county),
                      hintText: "Enter county",
                      onChanged: (value) => address.county = value,
                    ),
                  ),
                  labelWithField(
                    "Postcode",
                    TextInputWidget(
                      width: fieldWidth,
                      controller: TextEditingController(text: address.postcode),
                      hintText: "Enter postcode",
                      isRequired: true,
                      onChanged: (value) => address.postcode = value,
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
                                      element.code == address.country)
                                  ?.name ??
                              ""),
                      onChanged: (index) {
                        setState(() {
                          address.country = countries[index].code;
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (!isDeliverAtDifferentLocation)
                ButtonSmall(
                  text: "Lookup Address",
                  onPressed: () {
                    Get.showOverlay(
                      asyncFunction: () async {
                        try {
                          await lookupAddress();
                        } catch (e) {
                          if (address.postcode == null ||
                              address.postcode!.isEmpty) {
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
              if (isClient && isClient || !isLocation)
                if (selectedClient == null)
                  labelWithField(
                      "Service Delivered at a different address",
                      toggle(isDeliverAtDifferentLocation, (value) {
                        setState(() {
                          isDeliverAtDifferentLocation = value;
                        });
                      })),
              if (!isDeliverAtDifferentLocation && isClient || isLocation)
                labelWithField(
                    "Fixed IP Address",
                    toggle(isFixedIpAddress, (value) {
                      setState(() {
                        isFixedIpAddress = value;
                      });
                    })),
              if (!isDeliverAtDifferentLocation && isClient || isLocation)
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
              if (!isDeliverAtDifferentLocation && isClient || isLocation)
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
        if (isDeliverAtDifferentLocation)
          ButtonLarge(
              text: "Add Location",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final CreatedClientReturnValue? data = await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => ClientForm(
                            state: state,
                            type: ClientFormType.location,
                          ));
                  if (data != null && data.locationId != null) {
                    Get.showOverlay(
                      asyncFunction: () async {
                        try {
                          final ApiResponse createdClient =
                              await createClient();
                          if (createdClient.success) {
                            context.popRoute(CreatedClientReturnValue(
                                clientId: createdClient.data,
                                locationId: data.locationId));
                          } else {
                            showError(
                                createdClient.resMessage ?? "Unknown Error");
                          }
                        } catch (e) {
                          showError(e.toString());
                        }
                      },
                      loadingWidget: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                }
              })
        else
          ButtonLarge(
              text: "Save",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  switch (type) {
                    case ClientFormType.client:
                    case ClientFormType.location:
                      if (selectedClient != null) {
                        _handleUpdateClient();
                        return;
                      }
                      if (selectedAddress != null) {
                        _handleUpdateLocation();
                        return;
                      }
                      _handleCreateClient();
                      break;
                    // case ClientFormType.quoteClient:
                    //   _handleCreatequoteClient();
                    //   break;
                    // case ClientFormType.quoteLocation:
                    //   _handleCreatequoteLocation();
                    //   break;
                  }
                }
              }),
      ],
    );
  }

  void _handleCreateClient() async {
    return await Get.showOverlay(
      asyncFunction: () async {
        if (isClient) {
          final ApiResponse createdClient = await createClient();
          if (createdClient.success) {
            context.popRoute(CreatedClientReturnValue(
                clientId: createdClient.data, locationId: null));
          } else {
            showError(
              ApiHelpers.getRawDataErrorMessages(createdClient).isEmpty
                  ? "Error"
                  : ApiHelpers.getRawDataErrorMessages(createdClient),
            );
          }
        }
        if (isLocation) {
          final ApiResponse createdLoc = await createLocation();
          if (createdLoc.success) {
            context.popRoute(
                CreatedClientReturnValue(locationId: createdLoc.data));
          } else {
            //Location already exists
            if (createdLoc.resCode == 409) {
              context.popRoute(
                  CreatedClientReturnValue(locationId: createdLoc.data));
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

  void _handleUpdateClient() async {
    final client = ClientInfoMd(
      creditLimit: 0,
      id: selectedClient!.id,
      name: contactName.text,
      active: selectedClient?.active ?? true,
      address: address,
      payingDays: payingDays ?? 1,
      currencyId: (currencyId ?? 1).toString(),
      notes: notes.text,
      phone: phoneNumber.text,
      company: companyName.text,
      email: email.text,
      paymentMethodId: (paymentMethodId ?? 1).toString(),
    );
    context.popRoute(client);
  }

  void _handleUpdateLocation() async {
    context.popRoute(address);
  }

  Widget rowOrColumnWrapper(bool isRow, List<Widget> children) {
    if (isRow) {
      return SpacedRow(
        horizontalSpace: 32,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      );
    }
    return SpacedColumn(
      verticalSpace: 16,
      children: children,
    );
  }

  Future<ApiResponse> createLocation({bool fetchAllParams = true}) async {
    final ApiResponse res = await restClient()
        .postLocation(
          base: false,
          timelimit: false,
          sendChecklist: email.text.isNotEmpty,
          anywhere: false,
          radius: 100.toString(),
          phoneMobile: phoneNumber.text.isEmpty && selectedClient != null
              ? clientPhone
              : phoneNumber.text,
          email: phoneNumber.text.isEmpty && selectedClient != null
              ? clientEmail
              : phoneNumber.text,
          phoneLandline: "",
          phoneFax: "",
          name: "${address.line1} ${address.postcode}",
          addressCounty: address.county,
          active: true,
          latitude: (address.latitude).toString(),
          longitude: address.longitude.toString(),
          fixedipaddress: isFixedIpAddress,
          addressCity: address.city,
          addressCountry: address.country,
          addressLine1: address.line1,
          addressLine2: address.line2,
          addressPostcode: address.postcode,
          ipaddress: ipAddress.text,
        )
        .nocodeErrorHandler();
    if (res.success) {
      if (fetchAllParams) {
        await appStore.dispatch(GetLocationAddressesAction());
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
          addressLine1: address.line1,
          addressCity: address.city,
          addressPostcode: address.postcode,
          addressCountry: address.country,
          currencyId: currencyId!,
          paymentMethodId: paymentMethodId ?? 1,
          payingDays: payingDays!,
          notes: notes.text,
        )
        .nocodeErrorHandler();
    if (res.success) {
      if (fetchAllParams) {
        await appStore.dispatch(GetClientInfosAction());
      }
    }
    return res;
  }
}
