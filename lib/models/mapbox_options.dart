import 'package:navigation_with_mapbox/models/waypoint.dart';

//
class MapboxOptions {
  //
  WayPoint origin;
  WayPoint destination;
  bool simulateRoute;
  bool setDestinationWithLongTap;
  String? msg;
  String? profile;
  String? style;
  String? voiceUnits;
  String? language;
  bool? alternativeRoute;
  //
  MapboxOptions({
    required this.origin,
    required this.destination,
    required this.simulateRoute,
    required this.setDestinationWithLongTap,
    this.msg,
    this.profile,
    this.style,
    this.voiceUnits,
    this.language,
    this.alternativeRoute,
  });
}
