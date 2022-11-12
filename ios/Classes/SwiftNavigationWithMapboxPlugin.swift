import Flutter
import UIKit

public class SwiftNavigationWithMapboxPlugin: NSObject, FlutterPlugin {
    //NavigationFactory
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = FLNativeViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "mapboxView")
        
        let mapboxEventsChannel = FlutterEventChannel(name: "mapboxView/events", binaryMessenger: registrar.messenger())
        let MapboxEventsStreamHandler = MapboxEventsStreamHandler()
        mapboxEventsChannel.setStreamHandler(MapboxEventsStreamHandler)
    }

}
