import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:navigation_with_mapbox/navigation_with_mapbox_method_channel.dart';

void main() {
  MethodChannelNavigationWithMapbox platform =
      MethodChannelNavigationWithMapbox();
  const MethodChannel channel = MethodChannel('navigation_with_mapbox');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.startNavigation({}), '42');
  });
}
