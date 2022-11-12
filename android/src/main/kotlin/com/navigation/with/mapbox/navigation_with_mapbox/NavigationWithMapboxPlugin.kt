package com.navigation.with.mapbox.navigation_with_mapbox

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.mapbox.geojson.Point
import com.navigation.with.mapbox.navigation_with_mapbox.views.Launcher
import com.navigation.with.mapbox.navigation_with_mapbox.views.NativeViewFactory
import com.navigation.with.mapbox.navigation_with_mapbox.views.StatusView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** NavigationWithMapboxPlugin */
class NavigationWithMapboxPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  // We declare our private variables
  private var currentActivity: Activity? = null
  private lateinit var currentContext: Context
  private val wayPoints: MutableList<Point> = mutableListOf()

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "navigation_with_mapbox")
    channel.setMethodCallHandler(this)
    // we register the native android view
    flutterPluginBinding.platformViewRegistry.registerViewFactory("mapboxView", NativeViewFactory())
    // start the native view state listener
    val statusView = EventChannel(flutterPluginBinding.binaryMessenger, "mapboxView/events")
    statusView.setStreamHandler(StatusView())

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "startNavigation") {
      // we clean the points of origin and destination to save the new ones that they send us from the dart
      wayPoints.clear()
      // We store the arguments sent to us by the method in a map variable
      val arguments = call.arguments as? Map<*, *>
      // we store the arguments in their individual variables
      val point = arguments?.get("origin") as HashMap<*, *>
      val latitude = point["Latitude"] as Double
      val longitude = point["Longitude"] as Double
      wayPoints.add(Point.fromLngLat(longitude, latitude))
      val pointD = arguments["destination"] as HashMap<*, *>
      val latitudeD = pointD["Latitude"] as Double
      val longitudeD = pointD["Longitude"] as Double
      wayPoints.add(Point.fromLngLat(longitudeD, latitudeD))
      val simulateR = arguments["simulateRoute"] as Boolean
      val controlTap = arguments["setDestinationWithLongTap"] as Boolean
      val msg = arguments["msg"] as String
      val profile = arguments["profile"] as String
      val style = arguments["style"] as String
      val voiceUni = arguments["voiceUnits"] as String
      val language = arguments["language"] as String
      val alternativeRoute = arguments["alternativeRoute"] as Boolean
      // we send the received arguments to the navigation map initializer
      currentActivity?.let { Launcher.startNavigation(it, wayPoints, msg, profile, style, voiceUni,
        language, alternativeRoute, simulateR, controlTap) }
    } else {
      result.notImplemented()
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
    currentContext = binding.activity.applicationContext
  }

  override fun onDetachedFromActivityForConfigChanges() {
    // To change body of created functions use File | Settings | File Templates.
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    currentActivity = binding.activity
  }

  override fun onDetachedFromActivity() {
    currentActivity!!.finish()
    currentActivity = null
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

}
