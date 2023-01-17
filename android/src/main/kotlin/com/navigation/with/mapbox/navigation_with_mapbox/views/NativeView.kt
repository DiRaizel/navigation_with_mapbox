package com.navigation.with.mapbox.navigation_with_mapbox.views

import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.FrameLayout
import io.flutter.plugin.platform.PlatformView
import com.mapbox.geojson.Point
import java.io.Serializable

internal class NativeView(context: Context, id: Int, creationParams: Map<*, *>?) : PlatformView {

    //
    private val ctx: Context = context
    private val viewId: Int = id
    //
    private val wayPoints: MutableList<Point> = mutableListOf()
    // we store the arguments in their individual variables
    private val point = creationParams?.get("origin") as HashMap<*, *>
    private val latitude = point["Latitude"] as Double
    private val longitude = point["Longitude"] as Double
    private val pointD = creationParams?.get("destination") as HashMap<*, *>
    private val latitudeD = pointD["Latitude"] as Double
    private val longitudeD = pointD["Longitude"] as Double
    private val simulateR = creationParams?.get("simulateRoute") as Boolean
    private val controlTap = creationParams?.get("setDestinationWithLongTap") as Boolean
    private val msg = creationParams?.get("msg") as String
    private val profile = creationParams?.get("profile") as String
    private val style = creationParams?.get("style") as String
    private val voiceUni = creationParams?.get("voiceUnits") as String
    private val language = creationParams?.get("language") as String
    private val alternativeRoute = creationParams?.get("alternativeRoute") as Boolean

    override fun getView(): View {
        wayPoints.add(Point.fromLngLat(longitude, latitude))
        wayPoints.add(Point.fromLngLat(longitudeD, latitudeD))
        val navigationIntent = Intent(ctx, FullscreenActivity::class.java)
        navigationIntent.putExtra("waypoints", wayPoints as Serializable?)
        navigationIntent.putExtra("simulateRoute", simulateR)
        navigationIntent.putExtra("controlTap", controlTap)
        navigationIntent.putExtra("msg", msg)
        navigationIntent.putExtra("profile", profile)
        navigationIntent.putExtra("style", style)
        navigationIntent.putExtra("voiceUnits", voiceUni)
        navigationIntent.putExtra("language", language)
        navigationIntent.putExtra("alternativeRoute", alternativeRoute)
        val view = FrameLayout(ctx)
        view.id = viewId
        ctx.startActivity(navigationIntent)
        return view
    }

    override fun dispose() {}

    init {
        //
    }
}