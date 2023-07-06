import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/presentation/pages/users_view/users_view_widgets/user_card.dart';
import 'package:mca_dashboard/utils/global_extensions.dart';
import 'package:mca_dashboard/utils/utils.dart';

class CreateLocationPopup extends StatefulWidget {
  final LocationMd? model;
  const CreateLocationPopup({super.key, this.model});

  @override
  State<CreateLocationPopup> createState() => _CreateLocationPopupState();
}

class _CreateLocationPopupState extends State<CreateLocationPopup>
    with FormsMixin<CreateLocationPopup> {
  bool isCreate = true;
  String? currentIpAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.model != null) {
        logger(widget.model?.toJson());
        logger(widget.model?.phone.toString());
        logger(widget.model?.members.map((e) => e.toString()).toList());
        logger(widget.model?.address.toAddressStr());
        isCreate = false;
        controller1.text = widget.model!.name;
        controller2.text =
            widget.model!.ipaddress.map((e) => e.ipAddress).join(",");
        controller3.text = widget.model!.email;
        controller4.text = widget.model!.phone.mobile;
        controller5.text = widget.model!.phone.landline;
        controller6.text = widget.model!.phone.fax;
        checked1 = widget.model!.active;
        checked2 = widget.model!.anywhere;
        checked3 = widget.model!.fixedipaddress;
        checked4 = widget.model!.sendChecklist;
        controller7.text = widget.model!.address.line1;
        controller8.text = widget.model!.address.line2;
        controller9.text = widget.model!.address.city;
        controller10.text = widget.model!.address.county;
        controller11.text = widget.model!.address.postcode;
        controller12.text = widget.model!.address.latitude.toString();
        controller13.text = widget.model!.address.longitude.toString();
        controller14.text = widget.model!.address.radius.toString();
        final country = widget.model!.address
            .getCountryMd(appStore.state.generalState.lists.countries);
        if (country != null) {
          selected1 = DefaultMenuItem(
              id: 0, title: country.name, additionalId: country.code);
        }
      }
      final ipAddress = await getIpAddress();
      if (mounted) {
        setState(() {
          currentIpAddress = ipAddress;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      isExpanded: true,
      title: "${isCreate ? "Create" : "Edit"} Location",
      builder: (context) => StoreConnector<AppState, ListMd>(
          converter: (store) => store.state.generalState.lists,
          builder: (context, vm) {
            final countries = [...vm.countries];
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: SpacedColumn(
                  verticalSpace: 8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Wrap(
                      spacing: 64,
                      runSpacing: 16,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        SpacedColumn(
                          verticalSpace: 16,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///GENERAL

                            UserCard(
                              title: "General",
                              items: [
                                UserCardItem(
                                  title: "Location Name",
                                  controller: controller1,
                                  isRequired: true,
                                ),
                                UserCardItem(
                                  title: "Current IP Address",
                                  simpleText: currentIpAddress,
                                ),
                                UserCardItem(
                                  title: "IP Address(es)",
                                  isRequired: checked3,
                                  controller: controller2,
                                  maxLines: 4,
                                ),
                                UserCardItem(
                                  title: "Fixed IP Address",
                                  checked: checked3,
                                  onChecked: (value) {
                                    setState(() {
                                      checked3 = value;
                                    });
                                  },
                                ),
                                UserCardItem(
                                  title: "Is Active",
                                  checked: checked1,
                                  onChecked: (value) {
                                    setState(() {
                                      checked1 = value;
                                    });
                                  },
                                ),
                                UserCardItem(
                                  title: "Not Location Bound",
                                  checked: checked2,
                                  onChecked: (value) {
                                    setState(() {
                                      checked2 = value;
                                    });
                                  },
                                ),
                              ],
                            ),

                            ///CONTACT
                            UserCard(
                              title: "Contact Details",
                              items: [
                                UserCardItem(
                                  title: "Email Address",
                                  controller: controller3,
                                  isRequired: true,
                                ),
                                UserCardItem(
                                  title: "Phone Number",
                                  controller: controller4,
                                  isRequired: !checked2,
                                ),
                                UserCardItem(
                                  title: "Phone Landline",
                                  controller: controller5,
                                ),
                                UserCardItem(
                                  title: "Fax Number",
                                  controller: controller6,
                                ),
                                UserCardItem(
                                  title: "Send Checklist",
                                  checked: checked4,
                                  onChecked: (value) {
                                    setState(() {
                                      checked4 = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        SpacedColumn(
                          verticalSpace: 16,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ///ADDRESS
                            UserCard(title: "Address Details", items: [
                              UserCardItem(
                                customWidget: AddressAutocompleteWidget(
                                  width: 450,
                                  onSelected: (value) {
                                    controller7.text = value.line1;
                                    controller8.text = value.line2;
                                    controller9.text = value.city;
                                    controller10.text = value.county;
                                    controller11.text = value.postcode;
                                    if (value.latitude != null) {
                                      controller12.text =
                                          value.latitude.toString();
                                    }
                                    if (value.longitude != null) {
                                      controller13.text =
                                          value.longitude.toString();
                                    }
                                    if (value.country != null) {
                                      selected1 = DefaultMenuItem(
                                          id: 0,
                                          title: value.country!.name,
                                          additionalId: value.country!.code);
                                    }

                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                              UserCardItem(
                                title: "Address Line 1",
                                controller: controller7,
                                isRequired: !checked2,
                              ),
                              UserCardItem(
                                title: "Address Line 2",
                                controller: controller8,
                              ),
                              UserCardItem(
                                title: "City",
                                controller: controller9,
                                isRequired: !checked2,
                              ),
                              UserCardItem(
                                title: "County",
                                controller: controller10,
                              ),
                              UserCardItem(
                                title: "Postcode",
                                controller: controller11,
                                isRequired: !checked2,
                              ),
                              UserCardItem(
                                  title: "Country",
                                  isRequired: !checked2,
                                  dropdown: UserCardDropdown(
                                    items: [
                                      for (int i = 0; i < countries.length; i++)
                                        DefaultMenuItem(
                                            id: i,
                                            title: countries[i].name,
                                            additionalId: countries[i].code),
                                    ],
                                    additionalValueId: selected1?.additionalId,
                                    onChanged: (value) {
                                      selected1 = value;
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    },
                                  )),
                            ]),

                            ///GPS
                            UserCard(
                              title: "GPS Position",
                              items: [
                                UserCardItem(
                                  customWidget: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size(double.infinity, 60)),
                                    onPressed: () async {
                                      final GoogleMapsGeocoding geocoding =
                                          GoogleMapsGeocoding(
                                              apiKey: googleMapsApiKey);
                                      GeocodingResponse response =
                                          await geocoding.searchByComponents([
                                        if (selected1?.additionalId != null)
                                          Component(Component.country,
                                              selected1!.additionalId!),
                                        Component(Component.postalCode,
                                            controller11.text),
                                      ]);
                                      print(response.status);

                                      if (response.isOkay) {
                                        final res = response.results.first;
                                        String long = res.geometry.location.lng
                                            .toString();
                                        String lat = res.geometry.location.lat
                                            .toString();
                                        controller12.text = lat;
                                        controller13.text = long;
                                        context.showSuccess("Location Found");
                                      } else {
                                        context.showError("Location Not Found");
                                      }
                                    },
                                    label: const Text("Lookup GPS Coordinates"),
                                    icon: const Icon(Icons.gps_fixed),
                                  ),
                                ),
                                UserCardItem(
                                  title: "Latitude",
                                  controller: controller12,
                                  isRequired: !checked2,
                                ),
                                UserCardItem(
                                  title: "Longitude",
                                  controller: controller13,
                                  isRequired: !checked2,
                                ),
                                UserCardItem(
                                  title: "Radius",
                                  controller: controller14,
                                  isRequired: !checked2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    SpacedRow(
                      mainAxisAlignment: MainAxisAlignment.end,
                      horizontalSpace: 8,
                      children: [
                        ElevatedButton(
                          onPressed: context.pop,
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (!isFormValid) return;
                            if (selected1 == null) {
                              context.showError("Please select country");
                              return;
                            }
                            context.futureLoading(() async {
                              final success = await dispatch(PostLocationAction(
                                  active: checked1,
                                  anywhere: checked2,
                                  sendChecklist: checked4,
                                  addressData: AddressData(
                                    // locationId: widget.model?.id,
                                    name: controller1.text,
                                    email: controller3.text,
                                    phoneNumber: controller4.text,
                                    postcode: controller11.text,
                                    county: controller10.text,
                                    city: controller9.text,
                                    line1: controller7.text,
                                    country: countries.firstWhereOrNull(
                                        (element) =>
                                            element.code ==
                                            selected1!.additionalId),
                                    longitude:
                                        double.tryParse(controller13.text),
                                    latitude:
                                        double.tryParse(controller12.text),
                                    line2: controller8.text,
                                    ipAddress: controller2.text,
                                    fixedIpAddress: checked3,
                                    radius: double.tryParse(controller14.text),
                                    phoneLandline: controller5.text,
                                    phoneFax: controller6.text,
                                  )));
                              if (success.isRight) {
                                if (success.right.code == 409) {
                                  context.showError(
                                      "Location already exists, cannot be edited!");
                                  return;
                                }
                                context.showError(success.right.message);
                              } else {
                                context.pop(true);
                              }
                            });
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
