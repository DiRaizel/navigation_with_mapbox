import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:io' as io;
//
import 'navigation_with_mapbox_init.dart';
import 'models/models.dart';

// ignore: must_be_immutable
class MapboxNavigationView extends StatelessWidget {
  MapboxNavigationView({
    super.key,
    required this.mapboxOptions,
  });

  MapboxOptions mapboxOptions;

  // New Event Channel
  static const EventChannel _mapboxViewChannel =
      EventChannel('mapboxView/events');

  final _navigationWithMapboxPlugin = NavigationWithMapbox();

  starNavigation() async {
    await _navigationWithMapboxPlugin.startNavigation(
        // origin refers to the user's starting point at the time of starting the navigation
        origin: WayPoint(
            latitude: mapboxOptions.origin.latitude,
            longitude: mapboxOptions.origin.longitude),
        // destination refers to the end point or goal for the user at the time of starting the navigation
        destination: WayPoint(
            latitude: mapboxOptions.destination.latitude,
            longitude: mapboxOptions.destination.longitude),
        // if we enable this option we can choose a destination with a sustained tap
        setDestinationWithLongTap: mapboxOptions.setDestinationWithLongTap,
        // if we enable this option we will activate the simulation of the route
        simulateRoute: mapboxOptions.simulateRoute,
        // optional, message that will be displayed when starting the navigation map
        msg: (mapboxOptions.msg != null) ? mapboxOptions.msg : '',
        // unit of measure in which the navigation assistant will speak to us
        // optional, default: metric
        voiceUnits:
            (mapboxOptions.voiceUnits != null) ? mapboxOptions.voiceUnits : '',
        // language in which the navigation assistant will speak to us
        // optional, default: en
        language:
            (mapboxOptions.language != null) ? mapboxOptions.language : '',
        // if we enable this option we can see alternative routes when starting the navigation map
        // optional, default: false
        alternativeRoute: (mapboxOptions.alternativeRoute != null)
            ? mapboxOptions.alternativeRoute
            : false,
        // the style or theme with which the navigation map will be loaded
        // optional, default: streets, others: dark, light, traffic_day, traffic_night, satellite, satellite_streets, outdoors
        style: (mapboxOptions.style != null) ? mapboxOptions.style : '',
        // refers to the navigation mode, the route and time will be calculated depending on this
        // optional, default: driving, others: walking, cycling
        profile: (mapboxOptions.profile != null) ? mapboxOptions.profile : '');
  }

  @override
  Widget build(BuildContext context) {
    Map data = {
      'destination': {
        'Latitude': mapboxOptions.destination.latitude,
        'Longitude': mapboxOptions.destination.longitude
      },
      'origin': {
        'Latitude': mapboxOptions.origin.latitude,
        'Longitude': mapboxOptions.origin.longitude
      },
      'simulateRoute': mapboxOptions.simulateRoute,
      'setDestinationWithLongTap': mapboxOptions.setDestinationWithLongTap,
      // 'msg': (mapboxOptions.msg != null) ? mapboxOptions.msg : '',
      'profile': (mapboxOptions.profile != null) ? mapboxOptions.profile : '',
      'style': (mapboxOptions.style != null) ? mapboxOptions.style : '',
      'voiceUnits':
          (mapboxOptions.voiceUnits != null) ? mapboxOptions.voiceUnits : '',
      'language':
          (mapboxOptions.language != null) ? mapboxOptions.language : '',
      // 'alternativeRoute': (mapboxOptions.alternativeRoute != null) ? mapboxOptions.alternativeRoute : false,
    };
    // This is used in the platform side to register the view.
    const String viewType = 'mapboxView';
    //
    if (io.Platform.isAndroid) {
      Future.delayed(const Duration(milliseconds: 200), () {
        starNavigation();
      });
      //
      return AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: data,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else {
      return UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: data,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }

  // New
  static Stream<int> get getStateMapboxView {
    return _mapboxViewChannel.receiveBroadcastStream().cast();
  }
}
