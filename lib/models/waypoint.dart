import 'dart:convert';

// waypoint model that helps us to send locations
class WayPoint {
  WayPoint({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  factory WayPoint.fromJson(String str) => WayPoint.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WayPoint.fromMap(Map<String, dynamic> json) => WayPoint(
        latitude: json["Latitude"].toDouble(),
        longitude: json["Longitude"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "Latitude": latitude,
        "Longitude": longitude,
      };
}
