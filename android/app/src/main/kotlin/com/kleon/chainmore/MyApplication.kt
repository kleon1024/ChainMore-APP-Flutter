package com.kleon.chainmore

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugins.GeneratedPluginRegistrant
import vn.hunghd.flutterdownloader.FlutterDownloaderPlugin

internal class MyApplication : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun registerWith(registry: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith(registry)
    }
}