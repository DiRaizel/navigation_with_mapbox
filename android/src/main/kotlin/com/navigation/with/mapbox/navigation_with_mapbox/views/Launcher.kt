package com.navigation.with.mapbox.navigation_with_mapbox.views

import android.app.Activity
import android.content.Intent
import com.mapbox.geojson.Point
import java.io.Serializable

open class Launcher {
    companion object {

        fun startNavigation(activity: Activity, wayPoints: List<Point?>?, msg: String,
                            profile: String, style: String, voiceUni: String, language: String,
                            alternativeRoute: Boolean, simulateR: Boolean, controlTap: Boolean) {
            val navigationIntent = Intent(activity, FullscreenActivity::class.java)
            // we send the received arguments to our mapActivity
            navigationIntent.putExtra("waypoints", wayPoints as Serializable?)
            navigationIntent.putExtra("simulateRoute", simulateR)
            navigationIntent.putExtra("controlTap", controlTap)
            navigationIntent.putExtra("msg", msg)
            navigationIntent.putExtra("profile", profile)
            navigationIntent.putExtra("style", style)
            navigationIntent.putExtra("voiceUnits", voiceUni)
            navigationIntent.putExtra("language", language)
            navigationIntent.putExtra("alternativeRoute", alternativeRoute)
            // we start navigation
            activity.startActivity(navigationIntent)
        }
    }
}