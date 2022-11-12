import 'package:navigation_with_mapbox/models/models.dart';

import 'navigation_with_mapbox_platform_interface.dart';

class NavigationWithMapbox {
  Future<dynamic> startNavigation({
    required WayPoint origin,
    required WayPoint destination,
    required bool simulateRoute,
    required bool setDestinationWithLongTap,
    String? msg,
    String? profile,
    String? style,
    String? voiceUnits,
    String? language,
    bool? alternativeRoute,
  }) {
    // The data we receive is stored in a variable type map
    Map data = {
      'destination': {
        'Latitude': destination.latitude,
        'Longitude': destination.longitude
      },
      'origin': {'Latitude': origin.latitude, 'Longitude': origin.longitude},
      'simulateRoute': simulateRoute,
      'setDestinationWithLongTap': setDestinationWithLongTap,
      'msg': (msg != null) ? msg : '',
      'profile': (profile != null) ? profile : '',
      'style': (style != null) ? style : '',
      'voiceUnits': (voiceUnits != null) ? voiceUnits : '',
      'language': (language != null) ? language : '',
      'alternativeRoute': (alternativeRoute != null) ? alternativeRoute : false,
    };
    // then we send the data to the method that starts the map
    return NavigationWithMapboxPlatform.instance.startNavigation(data);
  }
}
