import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:mca_dashboard/manager/data/data.dart';
import 'package:mca_dashboard/manager/manager.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown.dart';
import 'package:mca_dashboard/presentation/global_widgets/default_dropdown_menu.dart';
import 'package:mca_dashboard/presentation/pages/scheduling_view/data/schedule_models.dart';
import 'package:mca_dashboard/utils/global_functions.dart';

class AddressAutocompleteWidget extends StatefulWidget {
  final ValueChanged<AddressData> onSelected;
  final double? width;
  final String? label;

  const AddressAutocompleteWidget(
      {super.key,
      required this.onSelected,
      this.width,
      this.label = "Search Address"});

  @override
  State<AddressAutocompleteWidget> createState() =>
      _AddressAutocompleteWidgetState();
}

class _AddressAutocompleteWidgetState extends State<AddressAutocompleteWidget> {
  final _debouncer = Debouncer(milliseconds: 500);

  // final googlePlaces = FlutterGooglePlacesSdk(googleSdkKey);

  final items = <DefaultMenuItem>[];

  final controller = TextEditingController();
  bool isLoading = false;
  final GoogleMapsGeocoding geocoding =
      GoogleMapsGeocoding(apiKey: googleMapsApiKey);
  @override
  void initState() {
    super.initState();
    controller.addListener(() async {
      //Can use googlePlaces.find to get predictions
      _debouncer.run(() async {
        if (controller.text.isEmpty) {
          setState(() {
            items.clear();
          });
          return;
        }
        setState(() {
          isLoading = true;
        });

        GeocodingResponse predictions = await geocoding.searchByComponents([
          Component(Component.locality, controller.text),
        ]);

        items.clear();
        for (final item in predictions.results) {
          items.add(DefaultMenuItem(
            id: predictions.results.indexOf(item),
            additionalId: item.placeId,
            title: item.formattedAddress ?? "",
          ));
          logger(items.length, hint: "items.length");
        }
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Return a autocomplete widget with debounce of 500ms
    return DefaultDropdownMenu(
      width: widget.width,
      controller: controller,
      items: items,
      isLoading: isLoading,
      label: widget.label,
      onSelected: (value) async {
        final String? placeId = value.additionalId;
        final AddressData address = AddressData();
        if (placeId != null) {
          final res = await geocoding.searchByPlaceId(placeId);
          if (res.results.isEmpty) return;
          final place = res.results.first;
          final countryCode = place.addressComponents
              .firstWhereOrNull((element) => element.types.contains("country"))
              ?.shortName;
          final postalCode = place.addressComponents
              .firstWhereOrNull(
                  (element) => element.types.contains("postal_code"))
              ?.longName;
          final city = place.addressComponents
              .firstWhereOrNull((element) =>
                  element.types.contains("administrative_area_level_1"))
              ?.longName;
          final road = place.addressComponents
              .firstWhereOrNull((element) => element.types.contains("route"))
              ?.longName;
          final streetNumber = place.addressComponents
              .firstWhereOrNull((element) => element.types.contains("premise"))
              ?.longName;
          final local1 = place.addressComponents
              .firstWhereOrNull(
                  (element) => element.types.contains("sublocality_level_1"))
              ?.longName;
          final local2 = place.addressComponents
              .firstWhereOrNull(
                  (element) => element.types.contains("sublocality_level_2"))
              ?.longName;

          //local1 + locale2 + streetNumber
          final line1 =
              "${road != null ? "$road," : ""}${local1 != null ? "$local1, " : ""}${local2 != null ? "$local2, " : ""}${streetNumber != null ? "$streetNumber, " : ""}";

          address.latitude = place.geometry.location.lat;
          address.longitude = place.geometry.location.lng;
          address.line1 = line1;
          address.city = city ?? "";
          address.postcode = postalCode ?? "";
          address.country = appStore.state.generalState.lists.countries
              .firstWhereOrNull((element) => element.code == countryCode);
          widget.onSelected(address);
        }
      },
    );
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
