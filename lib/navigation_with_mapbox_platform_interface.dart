import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'navigation_with_mapbox_method_channel.dart';

abstract class NavigationWithMapboxPlatform extends PlatformInterface {
  /// Constructs a NavigationWithMapboxPlatform.
  NavigationWithMapboxPlatform() : super(token: _token);

  static final Object _token = Object();

  static NavigationWithMapboxPlatform _instance =
      MethodChannelNavigationWithMapbox();

  /// The default instance of [NavigationWithMapboxPlatform] to use.
  ///
  /// Defaults to [MethodChannelNavigationWithMapbox].
  static NavigationWithMapboxPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NavigationWithMapboxPlatform] when
  /// they register themselves.
  static set instance(NavigationWithMapboxPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future startNavigation(data) {
    throw UnimplementedError('Error starting navigation.');
  }
}
