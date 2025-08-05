// android/app/src/main/kotlin/com/example/missionland_app/MainActivity.kt
package com.example.missionland_app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val APP_LAUNCHER_CHANNEL = "app_launcher"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, APP_LAUNCHER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "launchApp" -> {
                        val packageName = call.argument<String>("packageName")
                        val action = call.argument<String>("action")
                        
                        if (packageName != null) {
                            launchApp(packageName, action, result)
                        } else {
                            result.error("INVALID_ARGUMENT", "Package name is required", null)
                        }
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }
    
    private fun launchApp(packageName: String, action: String?, result: MethodChannel.Result) {
        try {
            val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
            
            if (launchIntent != null) {
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                
                if (action != null) {
                    launchIntent.putExtra("action", action)
                }
                
                startActivity(launchIntent)
                result.success(true)
            } else {
                result.error("APP_NOT_FOUND", "App not found", null)
            }
            
        } catch (e: Exception) {
            result.error("LAUNCH_ERROR", "Failed to launch app", null)
        }
    }
}