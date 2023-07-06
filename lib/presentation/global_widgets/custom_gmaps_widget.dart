import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:mca_dashboard/presentation/global_widgets/widgets.dart';

import '../../manager/data/db.dart';
import '../../manager/manager.dart';

class CustomGMapsWidget extends StatefulWidget {
  final LocationMd? location;
  const CustomGMapsWidget({super.key, this.location});

  @override
  State<CustomGMapsWidget> createState() => _CustomGMapsWidgetState();
}

class _CustomGMapsWidgetState extends State<CustomGMapsWidget> {
  final List<Circle> circles = [];
  final List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    final List<LocationMd> locs = [...appStore.state.generalState.locations];
    if (widget.location != null) {
      locs.clear();
      locs.add(widget.location!);
    }
    for (var location in locs) {
      circles.add(Circle(
        circleId: CircleId(location.id.toString()),
        center: LatLng(location.address.latitude!.toDouble(),
            location.address.longitude!.toDouble()),
        radius: location.address.radius?.toDouble() ?? 0,
        fillColor: Colors.red.withOpacity(0.2),
        strokeWidth: 2,
        strokeColor: location.active ? Colors.black : Colors.grey,
      ));
      markers.add(Marker(
        markerId: MarkerId(location.id.toString()),
        position: LatLng(location.address.latitude!.toDouble(),
            location.address.longitude!.toDouble()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var location = appStore.state.generalState.locations.first;
    if (widget.location != null) {
      location = widget.location!;
    }
    return GoogleMapsWidget(
      apiKey: googleMapsApiKey,
      sourceLatLng: LatLng(location.address.latitude!.toDouble(),
          location.address.longitude!.toDouble()),
      destinationLatLng: LatLng(location.address.latitude!.toDouble(),
          location.address.longitude!.toDouble()),
      circles: circles.toSet(),
      markers: markers.toSet(),
      defaultCameraZoom: widget.location != null ? 15 : 10,
    );
  }
}

void showMapPopup(BuildContext context, {LocationMd? location}) {
  DependencyManager.instance.navigation.showCustomDialog(
    builder: (ctx) => DefaultDialog(
      title: location?.name ?? "All locations",
      builder: (context) => CustomGMapsWidget(location: location),
    ),
    context: context,
  );
}

Widget _header(BuildContext context, String title) {
  return SpacedRow(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
      ),
      IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.close, color: Colors.grey, size: 20.0)),
    ],
  );
}
