import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'navigation_with_mapbox_platform_interface.dart';

/// An implementation of [NavigationWithMapboxPlatform] that uses method channels.
class MethodChannelNavigationWithMapbox extends NavigationWithMapboxPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('navigation_with_mapbox');

  @override
  Future startNavigation(data) async {
    final version =
        await methodChannel.invokeMethod<String>('startNavigation', data);
    return version;
  }
}
