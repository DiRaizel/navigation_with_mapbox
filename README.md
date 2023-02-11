# navigation_with_mapbox

Add Turn By Turn Navigation to Your Flutter Application Using MapBox.

<details>
<summary>ANDROID Configuration</summary>

1. Mapbox APIs and vector tiles require a Mapbox account and API access token. Add your token in strings.xml file of your android apps res/values/ path. The string key should be "mapbox_access_token". You can obtain an access token from the [Mapbox account page](https://account.mapbox.com/access-tokens/).

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="mapbox_access_token" translatable="false">ADD_MAPBOX_ACCESS_TOKEN_HERE</string>
</resources>
```

2. Add the following permissions to the app level Android Manifest

```xml
<manifest>
    ...
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    ...
</manifest>
```

3. Add the MapBox Downloads token with the `downloads:read` scope to your gradle.properties file in Android folder to enable downloading the MapBox binaries from the repository. To secure this token from getting checked into source control, you can add it to the gradle.properties of your GRADLE_HOME which is usually at $USER_HOME/.gradle for Mac. This token can be retrieved from your [MapBox Dashboard](https://account.mapbox.com/access-tokens/). You can review the [Token Guide](https://docs.mapbox.com/accounts/guides/tokens/) to learn more about download tokens

```text
MAPBOX_DOWNLOADS_TOKEN=sk.xxxxx
```

After adding the above, your gradle.properties file may look something like this:

```text
org.gradle.jvmargs=-Xmx1536M
android.useAndroidX=true
android.enableJetifier=true
MAPBOX_DOWNLOADS_TOKEN=sk.xxxxx
```

</details>

<details>
<summary>IOS Configuration</summary>

1. Go to your [Mapbox account dashboard](https://account.mapbox.com/) and create an access token that has the `DOWNLOADS:READ` scope. **PLEASE NOTE: This is not the same as your production Mapbox API token. Make sure to keep it private and do not insert it into any Info.plist file.** Create a file named `.netrc` in your home directory if it doesn’t already exist, then add the following lines to the end of the file:
   ```
   machine api.mapbox.com
     login mapbox
     password PRIVATE_MAPBOX_API_TOKEN
   ```
   where _PRIVATE_MAPBOX_API_TOKEN_ is your Mapbox API token with the `DOWNLOADS:READ` scope.
2. Mapbox APIs and vector tiles require a Mapbox account and API access token. In the project editor, select the application target, then go to the Info tab. Under the “Custom iOS Target Properties” section, set `MBXAccessToken` to your access token. You can obtain an access token from the [Mapbox account page](https://account.mapbox.com/access-tokens/).

3. In order for the SDK to track the user’s location as they move along the route, set `NSLocationWhenInUseUsageDescription` to:

   > Shows your location on the map and helps improve OpenStreetMap.

4. Users expect the SDK to continue to track the user’s location and deliver audible instructions even while a different application is visible or the device is locked. Go to the Capabilities tab. Under the Background Modes section, enable “Audio, AirPlay, and Picture in Picture” and “Location updates”. (Alternatively, add the `audio` and `location` values to the `UIBackgroundModes` array in the Info tab.)

</details>

## ANDROID

```dart

  // create an instance of the plugin
  final _navigationWithMapboxPlugin = NavigationWithMapbox();

  () async {
    // we start the navigation
    await _navigationWithMapboxPlugin.startNavigation(
        // origin refers to the user's starting point at the time of starting the navigation
        origin: WayPoint(latitude: 4.809432, longitude: -75.700660),
        // destination refers to the end point or goal for the user at the time of starting the navigation
        destination: WayPoint(latitude: 4.759335, longitude: -75.923914),
        // if we enable this option we can choose a destination with a sustained tap
        setDestinationWithLongTap: true,
        // if we enable this option we will activate the simulation of the route
        simulateRoute: false,
        // if we enable this option we can see alternative routes when starting the navigation map ONLY ANDROID
        // optional, default: false
        alternativeRoute: true,
        // the style or theme with which the navigation map will be loaded
        // optional, default: streets, others: dark, light, traffic_day, traffic_night, satellite, satellite_streets, outdoors
        style: 'traffic_night',
        // language in which the navigation assistant will speak to us
        // optional, default: en
        language: 'es',
        // refers to the navigation mode, the route and time will be calculated depending on this
        // optional, default: driving, others: walking, cycling
        profile: 'driving',
        // unit of measure in which the navigation assistant will speak to us
        // optional, default: metric
        voiceUnits: 'imperial',
        // optional, message that will be displayed when starting the navigation map ONLY ANDROID
        msg: '¡Buen viaje, disfruta de tu recorrido!');
  }

```

## IOS

```dart

  // Variable for Navigation Map Options 
  MapboxOptions? _options;
  // Variables Stream to listen for events 
  late Stream<int> listenEvents;
  late StreamSubscription _statusViewSubscription;
  // Control variable for map widget 
  bool _controlView = false;

  @override
  void initState() {
    ...
    // we instantiate the stream getStateMapboxView IOS
    listenEvents = MapboxNavigationView.getStateMapboxView;
  }

  () {

    // we set the map options
    var options = MapboxOptions(
      // origin refers to the user's starting point at the time of starting the navigation
      origin: WayPoint(latitude: 4.809432, longitude: -75.700660),
      // destination refers to the end point or goal for the user at the time of starting the navigation
      destination: WayPoint(latitude: 4.759335, longitude: -75.923914),
      // if we enable this option we can choose a destination with a sustained tap
      setDestinationWithLongTap: false,
      // if we enable this option we will activate the simulation of the route
      simulateRoute: false,
      // optional, message that will be displayed when starting the navigation map ONLY ANDROID
      msg: '¡Buen viaje, disfruta de tu recorrido!',
      // unit of measure in which the navigation assistant will speak to us
      // optional, default: metric
      voiceUnits: 'imperial',
      // language in which the navigation assistant will speak to us
      // optional, default: en
      language: 'es',
      // if we enable this option we can see alternative routes when starting the navigation map ONLY ANDROID
      // optional, default: false 
      alternativeRoute: true,
      // the style or theme with which the navigation map will be loaded
      // optional ANDROID, default: streets, others: dark, light, traffic_day, traffic_night, satellite, satellite_streets, outdoors
      // optional IOS, default: streets, others: dark, light
      style: 'traffic_night',
      // refers to the navigation mode, the route and time will be calculated depending on this
      // optional ANDROID, default: driving, others: walking, cycling 
      // optional IOS, default: drivingWithTraffic, others: driving, walking, cycling 
      profile: '',
    );
    // we save the options and go on to show the map view
    setState(() {
      _options = options;
      _controlView = true;
    });
    // we start listening to the state of the map view
    _statusViewSubscription = listenEvents.listen(_statusView);
  }

  // When the condition is met we show the navigation map with mapbox
  if (_controlView) MapboxNavigationView(mapboxOptions: _options!),

  // function that listens to the state of the map
  _statusView(event) {
    // when we close the map we go to hide the view of the map and stop listening to its state
    if (event == 2) {
      // we hide the map view
      setState(() {
        _controlView = false;
      });
      // we stopped listening to the state of the map
      _statusViewSubscription.cancel();
    }
  }

```

#### Screenshots

| ![Image text](https://raw.githubusercontent.com/DiRaizel/navigation_with_mapbox/main/images/android.jpg) | ![Image text](https://raw.githubusercontent.com/DiRaizel/navigation_with_mapbox/main/images/ios.png) |
| :---------------------------------------------------------: | :---------------------------------------------: |
|                        Android View                         |                    IOS View                     |
