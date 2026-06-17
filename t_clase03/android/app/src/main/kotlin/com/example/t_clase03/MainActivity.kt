package com.example.t_clase03

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.widget.Toast
import androidx.datastore.preferences.core.edit
import androidx.datastore.preferences.core.stringPreferencesKey
import androidx.datastore.preferences.preferencesDataStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

private val Context.dataStore by preferencesDataStore(name = "t_clase03_datastore")

class MainActivity : FlutterActivity() {
    private val TOAST_CHANNEL = "t_clase03/toast"
    private val DATASTORE_CHANNEL = "t_clase03/datastore"
    private val INTENT_CHANNEL = "t_clase03/intents"

    private var intentChannel: MethodChannel? = null

    // Buffer para el intent inicial (antes de que Flutter esté listo)
    private var pendingSharedData: Map<String, Any?>? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        pendingSharedData = extractSharedData(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val data = extractSharedData(intent) ?: return
        // Si Flutter ya está corriendo, enviar directamente
        Handler(Looper.getMainLooper()).post {
            intentChannel?.invokeMethod("onSharedData", data)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Canal de Toast
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TOAST_CHANNEL)
            .setMethodCallHandler { call, result ->
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

        // Canal de DataStore
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DATASTORE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "save" -> {
                        val key = call.argument<String>("key") ?: ""
                        val value = call.argument<String>("value") ?: ""
                        CoroutineScope(Dispatchers.IO).launch {
                            try {
                                applicationContext.dataStore.edit { prefs ->
                                    prefs[stringPreferencesKey(key)] = value
                                }
                                result.success(null)
                            } catch (e: Exception) {
                                result.error("DATASTORE_ERROR", e.message, null)
                            }
                        }
                    }
                    "read" -> {
                        val key = call.argument<String>("key") ?: ""
                        CoroutineScope(Dispatchers.IO).launch {
                            try {
                                val prefs = applicationContext.dataStore.data.first()
                                result.success(prefs[stringPreferencesKey(key)])
                            } catch (e: Exception) {
                                result.error("DATASTORE_ERROR", e.message, null)
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // Canal de Intents entrantes
        intentChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INTENT_CHANNEL)
        intentChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialIntent" -> {
                    result.success(pendingSharedData)
                    pendingSharedData = null
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun extractSharedData(intent: Intent): Map<String, Any?>? {
        if (intent.action != Intent.ACTION_SEND) return null
        val type = intent.type ?: return null
        return when {
            type == "text/plain" -> {
                val text = intent.getStringExtra(Intent.EXTRA_TEXT) ?: return null
                mapOf("type" to "text", "data" to text)
            }
            type.startsWith("image/") -> {
                val uri: Uri? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
                } else {
                    @Suppress("DEPRECATION")
                    intent.getParcelableExtra(Intent.EXTRA_STREAM)
                }
                if (uri == null) return null
                try {
                    val bytes = contentResolver.openInputStream(uri)?.readBytes() ?: return null
                    mapOf("type" to "image", "data" to bytes)
                } catch (e: Exception) {
                    null
                }
            }
            else -> null
        }
    }
}
