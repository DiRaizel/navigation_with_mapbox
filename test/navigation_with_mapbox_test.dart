import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigation_with_mapbox/navigation_with_mapbox.dart';
import 'package:navigation_with_mapbox/navigation_with_mapbox_init.dart';
import 'package:navigation_with_mapbox/navigation_with_mapbox_platform_interface.dart';
import 'package:navigation_with_mapbox/navigation_with_mapbox_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNavigationWithMapboxPlatform with MockPlatformInterfaceMixin implements NavigationWithMapboxPlatform {
  @override
  Future startNavigation(data) {
    debugPrint(data);
    throw UnimplementedError();
  }
}

void main() {
  final NavigationWithMapboxPlatform initialPlatform = NavigationWithMapboxPlatform.instance;

  test('$MethodChannelNavigationWithMapbox is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNavigationWithMapbox>());
  });

  test('getPlatformVersion', () async {
    NavigationWithMapbox navigationWithMapboxPlugin = NavigationWithMapbox();
    MockNavigationWithMapboxPlatform fakePlatform = MockNavigationWithMapboxPlatform();
    NavigationWithMapboxPlatform.instance = fakePlatform;

    expect(
        await navigationWithMapboxPlugin.startNavigation(
            origin: WayPoint(latitude: 4.809432, longitude: -75.700660),
            destination: WayPoint(latitude: 4.759335, longitude: -75.923914),
            setDestinationWithLongTap: false,
            simulateRoute: false),
        '42');
  });
}
