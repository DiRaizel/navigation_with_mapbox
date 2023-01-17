import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
//
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
      'profile': (mapboxOptions.profile != null) ? mapboxOptions.profile : '',
      'style': (mapboxOptions.style != null) ? mapboxOptions.style : '',
      'voiceUnits':
          (mapboxOptions.voiceUnits != null) ? mapboxOptions.voiceUnits : '',
      'language':
          (mapboxOptions.language != null) ? mapboxOptions.language : '',
    };
    // This is used in the platform side to register the view.
    const String viewType = 'mapboxView';
    //
    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: data,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }

  // New
  static Stream<int> get getStateMapboxView {
    return _mapboxViewChannel.receiveBroadcastStream().cast();
  }
}
