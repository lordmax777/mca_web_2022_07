import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:mca_web_2022_07/comps/show_overlay_popup.dart';
import 'package:mca_web_2022_07/pages/locations/controllers/locations_controller.dart';

import '../app.dart';
import '../manager/models/location_item_md.dart';
import '../theme/theme.dart';

class CustomGMapsWidget extends StatefulWidget {
  final LocationItemMd? location;
  final bool isSingle;

  ///If single location must be provided, otherwise all locations will be shown
  const CustomGMapsWidget({super.key, this.location, this.isSingle = true});

  @override
  State<CustomGMapsWidget> createState() => _CustomGMapsWidgetState();
}

class _CustomGMapsWidgetState extends State<CustomGMapsWidget> {
  final List<Circle> circles = [];
  final List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    final List<LocationItemMd> locs = [...LocationsController.to.departments];
    if (widget.isSingle) {
      locs.clear();
      locs.add(widget.location!);
    }
    for (var location in locs) {
      circles.add(Circle(
        circleId: CircleId(location.id.toString()),
        center: LatLng(location.address!.latitude!.toDouble(),
            location.address!.longitude!.toDouble()),
        radius: location.address?.radius?.toDouble() ?? 0,
        fillColor: ThemeColors.red3.withOpacity(0.2),
        strokeWidth: 2,
        strokeColor: ThemeColors.black,
      ));
      markers.add(Marker(
        markerId: MarkerId(location.id.toString()),
        position: LatLng(location.address!.latitude!.toDouble(),
            location.address!.longitude!.toDouble()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var location = LocationsController.to.departments.first;
    if (widget.isSingle) {
      location = widget.location!;
    }
    return GoogleMapsWidget(
      apiKey: Constants.googleMapApiKey,
      sourceLatLng: LatLng(location.address!.latitude!.toDouble(),
          location.address!.longitude!.toDouble()),
      destinationLatLng: LatLng(location.address!.latitude!.toDouble(),
          location.address!.longitude!.toDouble()),
      circles: circles.toSet(),
      markers: markers.toSet(),
      defaultCameraZoom: widget.isSingle ? 15 : 10,
    );
  }
}

void showMapPopup({LocationItemMd? location, bool isSingle = true}) {
  showOverlayPopup(
    horizontalPadding: 24.0,
    paddingBottom: 24.0,
    paddingTop: 24.0,
    margin: const EdgeInsets.symmetric(horizontal: 200.0),
    body: SpacedColumn(
      verticalSpace: 16.0,
      children: [
        _header(location?.name ?? "All locations"),
        const Divider(height: 1, thickness: 1, color: ThemeColors.gray11),
        SizedBox(
          height: 500.0,
          width:
              MediaQuery.of(appRouter.navigatorKey.currentContext!).size.width,
          child: CustomGMapsWidget(
            location: location,
            isSingle: isSingle,
          ),
        ),
      ],
    ),
    context: appRouter.navigatorKey.currentContext!,
  );
}

Widget _header(String title) {
  return SpacedRow(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      KText(
        text: title,
        fontSize: 18.0,
        fontWeight: FWeight.bold,
        isSelectable: false,
        textColor: ThemeColors.gray2,
      ),
      IconButton(
          onPressed: () {
            appRouter.pop();
          },
          icon: const HeroIcon(HeroIcons.x,
              color: ThemeColors.gray2, size: 20.0)),
    ],
  );
}
