package com.example.t_clase03

import android.content.Context
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

class MainActivity: FlutterActivity() {
    private val TOAST_CHANNEL = "t_clase03/toast"
    private val DATASTORE_CHANNEL = "t_clase03/datastore"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TOAST_CHANNEL).setMethodCallHandler { call, result ->
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

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DATASTORE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "save" -> {
                    val key = call.argument<String>("key") ?: ""
                    val value = call.argument<String>("value") ?: ""
                    CoroutineScope(Dispatchers.IO).launch {
                        try {
                            applicationContext.dataStore.edit { preferences ->
                                preferences[stringPreferencesKey(key)] = value
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
                            val preferences = applicationContext.dataStore.data.first()
                            result.success(preferences[stringPreferencesKey(key)])
                        } catch (e: Exception) {
                            result.error("DATASTORE_ERROR", e.message, null)
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }
}
