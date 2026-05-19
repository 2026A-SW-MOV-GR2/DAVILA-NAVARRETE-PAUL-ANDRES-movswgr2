package com.example.t_clase03

import android.widget.Toast
import android.os.Handler
import android.os.Looper
import android.app.AlertDialog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "t_clase03/toast"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "showToast" -> {
                    val message = call.argument<String>("message") ?: ""
                    Handler(Looper.getMainLooper()).post {
                        try {
                            Toast.makeText(applicationContext, message, Toast.LENGTH_SHORT).show()
                            result.success(null)
                        } catch (e: Exception) {
                            result.error("TOAST_ERROR", e.message, null)
                        }
                    }
                }
                
                else -> result.notImplemented()
            }
        }
    }
}
