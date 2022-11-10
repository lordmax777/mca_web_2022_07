import 'package:google_maps_widget/google_maps_widget.dart';

import '../manager/models/location_item_md.dart';
import '../theme/theme.dart';

class CustomGMapsWidget extends StatefulWidget {
  final LocationItemMd location;
  const CustomGMapsWidget({Key? key, required this.location}) : super(key: key);

  @override
  State<CustomGMapsWidget> createState() => _CustomGMapsWidgetState();
}

class _CustomGMapsWidgetState extends State<CustomGMapsWidget> {
  final List<Circle> circles = [];

  @override
  void initState() {
    super.initState();
    circles.add(Circle(
      circleId: CircleId(widget.location.id.toString()),
      center: LatLng(widget.location.address!.latitude!.toDouble(),
          widget.location.address!.longitude!.toDouble()),
      radius: widget.location.address?.radius?.toDouble() ?? 0,
      fillColor: ThemeColors.red3.withOpacity(0.2),
      strokeWidth: 2,
      strokeColor: ThemeColors.black,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMapsWidget(
      apiKey: Constants.googleMapApiKey,
      sourceLatLng: LatLng(widget.location.address!.latitude!.toDouble(),
          widget.location.address!.longitude!.toDouble()),
      destinationLatLng: LatLng(widget.location.address!.latitude!.toDouble(),
          widget.location.address!.longitude!.toDouble()),
      circles: circles.toSet(),
    );
  }
}
