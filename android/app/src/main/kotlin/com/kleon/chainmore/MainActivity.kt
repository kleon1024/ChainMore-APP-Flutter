package com.kleon.chainmore

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import vn.hunghd.flutterdownloader.FlutterDownloaderPlugin
import io.flutter.plugins.UpdateVersionPlugin

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
    UpdateVersionPlugin.registerWith(registrarFor("iwubida.com/update_version"))
  }
}
