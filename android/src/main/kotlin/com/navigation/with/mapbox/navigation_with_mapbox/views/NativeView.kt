package com.navigation.with.mapbox.navigation_with_mapbox.views

import android.content.Context
import android.view.View
import io.flutter.plugin.platform.PlatformView
import android.widget.TextView

internal class NativeView(context: Context, id: Int, creationParams: Map<*, *>?) : PlatformView {

private val textView: TextView

    override fun getView(): View {
        return textView
    }

    override fun dispose() {}

    init {
        textView = TextView(context)
        textView.textSize = 72f
        textView.text = " "
    }
}