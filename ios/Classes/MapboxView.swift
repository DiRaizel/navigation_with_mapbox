import Foundation
import UIKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections
import MapboxMaps

var stateView: Int = 1

class FLNativeView: NSObject, FlutterPlatformView, NavigationMapViewDelegate, NavigationViewControllerDelegate  {

    private var _view: UIView
    var arguments: NSDictionary?
    var _language: String = "en"
    var _origin: NSDictionary?
    var _destination: NSDictionary?
    var _voiceUnits: String = "metric"
    var _simulateRoute: Bool = false
    var _navigationMode: String = "drivingWithTraffic"
    var _style: String = ""
    var _longPressDestinationEnabled: Bool = false
    
    var routeOptions: NavigationRouteOptions?
    var navigationViewController: NavigationViewController?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        self.arguments = args as! NSDictionary?
        _view = UIView()
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView){
        //
        var originLat = 0.0
        var originLng = 0.0
        var destinationLat = 0.0
        var destinationLng = 0.0
        //
        if(self.arguments != nil){
            _language = arguments?["language"] as? String ?? _language
            let origin = arguments?["origin"] as? NSDictionary
            let destination = arguments?["destination"] as? NSDictionary
            originLat = origin?["Latitude"] as? Double ?? 37.77440680146262
            originLng = origin?["Longitude"] as? Double ?? -122.43539772352648
            destinationLat = destination?["Latitude"] as? Double ?? 37.76556957793795
            destinationLng = destination?["Longitude"] as? Double ?? -122.42409811526268
            _navigationMode = arguments?["profile"] as? String ?? "drivingWithTraffic"
            _simulateRoute = arguments?["simulateRoute"] as? Bool ?? _simulateRoute
            _voiceUnits = arguments?["voiceUnits"] as? String ?? _voiceUnits
            _style = arguments?["style"] as? String ?? _style
            _longPressDestinationEnabled = arguments?["setDestinationWithLongTap"] as? Bool ?? _longPressDestinationEnabled
        }

        var mode: ProfileIdentifier = .automobileAvoidingTraffic

        if (_navigationMode == "cycling")
        {
            mode = .cycling
        }
        else if(_navigationMode == "driving")
        {
            mode = .automobile
        }
        else if(_navigationMode == "walking")
        {
            mode = .walking
        }

        self.routeOptions = NavigationRouteOptions(coordinates: [
            CLLocationCoordinate2DMake(originLat, originLng),
            CLLocationCoordinate2DMake(destinationLat, destinationLng)
        ], profileIdentifier: mode)

        self.routeOptions!.distanceMeasurementSystem =  _voiceUnits == "imperial" ? .imperial : .metric
        self.routeOptions!.locale = Locale(identifier: _language)

        Directions.shared.calculate(self.routeOptions!) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let strongSelf = self else {
                    return
                }
                let navLocationManager = self!._simulateRoute ? SimulatedLocationManager(route: response.routes!.first!) : NavigationLocationManager()
                // For demonstration purposes, simulate locations if the Simulate Navigation option is on.
                let navigationService = MapboxNavigationService(routeResponse: response,
                                                                routeIndex: 0,
                                                                routeOptions: self!.routeOptions!,
                                                                customRoutingProvider: NavigationSettings.shared.directions,
                                                                credentials: NavigationSettings.shared.directions.credentials,
                                                                locationSource: navLocationManager,
                                                                simulating: self!._simulateRoute ? .always : .onPoorGPS)
                let navigationOptions = NavigationOptions(navigationService: navigationService)
                strongSelf.navigationViewController = NavigationViewController(for: response,
                                                                                  routeIndex: 0,
                                                                                  routeOptions: self!.routeOptions!,
                                                                                  navigationOptions: navigationOptions)

                strongSelf.navigationViewController?.modalPresentationStyle = .fullScreen
                // Render part of the route that has been traversed with full transparency, to give the illusion of a disappearing route.
                strongSelf.navigationViewController?.routeLineTracksTraversal = true
                strongSelf.navigationViewController?.delegate = strongSelf

                if (self!._style == "dark") {
                    strongSelf.navigationViewController!.navigationMapView!.mapView.mapboxMap.style.uri = StyleURI.navigationNight
                } else if(self!._style == "light"){
                    strongSelf.navigationViewController!.navigationMapView!.mapView.mapboxMap.style.uri = StyleURI.navigationDay
                }
        
                if(self!._longPressDestinationEnabled){
                    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self?.handleLongPress(_:)))
                    strongSelf.navigationViewController?.navigationMapView?.addGestureRecognizer(gesture)
                }

                strongSelf._view.addSubview(strongSelf.navigationViewController!.view)

            }
        }
    }
}

extension FLNativeView {
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .ended else { return }
        let location = navigationViewController!.navigationMapView!.mapView.mapboxMap.coordinate(for: gesture.location(in: navigationViewController!.navigationMapView!.mapView))
        requestRoute(destination: location)
    }
    
    func requestRoute(destination: CLLocationCoordinate2D) {
        
        guard let userLocation = navigationViewController!.navigationMapView!.mapView.location.latestLocation else { return }
        let location = CLLocation(latitude: userLocation.coordinate.latitude,
                                  longitude: userLocation.coordinate.longitude)
        let userWaypoint = Waypoint(location: location, heading: userLocation.heading, name: "Current Location")
        let destinationWaypoint = Waypoint(coordinate: destination)
        
        let routeOptions = NavigationRouteOptions(waypoints: [userWaypoint, destinationWaypoint])
        
        Directions.shared.calculate(routeOptions) { [weak self] (session, result) in
            
            if let strongSelf = self {
                
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let response):
                    guard let routes = response.routes, let route = response.routes?.first else {
                        return
                    }
                    strongSelf.routeOptions = routeOptions
                    strongSelf.navigationViewController!.navigationMapView!.show(routes)
                    strongSelf.navigationViewController!.navigationMapView!.showWaypoints(on: route)
                }
                
            }
        }
    }
    
    // Never reroute internally. Instead,
    // 1. Fetch a route from your server
    // 2. Map Match the coordinates from your server
    // 3. Set the route on your server
    func navigationViewController(_ navigationViewController: NavigationViewController, shouldRerouteFrom location: CLLocation) -> Bool {

        // Here, we are simulating a custom server.
        let routeOptions = NavigationRouteOptions(waypoints: [Waypoint(location: location), self.routeOptions!.waypoints.last!])
        Directions.shared.calculate(routeOptions) { [weak self] (_, result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let response):
                guard let routeShape = response.routes?.first?.shape else {
                    return
                }

                //
                // ❗️IMPORTANT❗️
                // Use `Directions.calculateRoutes(matching:completionHandler:)` for navigating on a map matching response.
                //
                let matchOptions = NavigationMatchOptions(coordinates: routeShape.coordinates)

                // By default, each waypoint separates two legs, so the user stops at each waypoint.
                // We want the user to navigate from the first coordinate to the last coordinate without any stops in between.
                // You can specify more intermediate waypoints here if you’d like.
                for waypoint in matchOptions.waypoints.dropFirst().dropLast() {
                    waypoint.separatesLegs = false
                }

                Directions.shared.calculateRoutes(matching: matchOptions) { [weak self] (_, result) in
                    switch result {
                    case .failure(let error):
                        print(error.localizedDescription)
                    case .success(let response):
                        guard !(response.routes?.isEmpty ?? true) else {
                            return
                        }

                        // Convert matchOptions to `RouteOptions`
                        let routeOptions = RouteOptions(matchOptions: matchOptions)
                        
                        // Set the route
                        self!.navigationViewController?.navigationService.router.updateRoute(with: .init(routeResponse: response, routeIndex: 0),
                                                                                             routeOptions: routeOptions,
                                                                                             completion: nil)
                    }
                }
            }
        }

        return true
    }
 
    func navigationViewControllerDidDismiss(_ navigationViewController: NavigationViewController, byCanceling canceled: Bool) {
        
        stateView = 2
        
        self.navigationViewController?.navigationService.endNavigation(feedback: nil)
        self.navigationViewController?.view.removeFromSuperview()
        self.navigationViewController = nil
    }

}

class MapboxEventsStreamHandler: NSObject, FlutterStreamHandler{
    var sink: FlutterEventSink?
    var timer: Timer?
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        sink = events
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(sendStatusView), userInfo: nil, repeats: true)
        return nil
    }
    
    @objc func sendStatusView() {
        guard let sink = sink else { return }

        sink(stateView)
        
        if(stateView == 2) {
            stateView = 1
        }
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sink = nil
        timer?.invalidate()
        return nil
    }
}
