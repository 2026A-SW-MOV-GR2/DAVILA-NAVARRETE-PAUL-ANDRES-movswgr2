package com.example.t_clase02

import android.content.res.Configuration
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
	private val CHANNEL = "resources_channel"
	private lateinit var methodChannel: MethodChannel

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
		methodChannel.setMethodCallHandler { call, result ->
			when (call.method) {
				"getResources" -> result.success(getResourcesMap())
				else -> result.notImplemented()
			}
		}
	}

	private fun getResourcesMap(): Map<String, Any> {
		val text = getString(R.string.app_text)
		val textColorInt = ContextCompat.getColor(this, R.color.text_color)
		val bgColorInt = ContextCompat.getColor(this, R.color.bg_color)
		val textColorHex = String.format("#%06X", 0xFFFFFF and textColorInt)
		val bgColorHex = String.format("#%06X", 0xFFFFFF and bgColorInt)
		return mapOf(
			"text" to text,
			"textColor" to textColorHex,
			"bgColor" to bgColorHex
		)
	}

	override fun onConfigurationChanged(newConfig: Configuration) {
		super.onConfigurationChanged(newConfig)
		// Notify Flutter that resources may have changed.
		if (::methodChannel.isInitialized) {
			try {
				methodChannel.invokeMethod("resourcesChanged", null)
			} catch (e: Exception) {
				// ignore failures delivering the message
			}
		}
	}
}
