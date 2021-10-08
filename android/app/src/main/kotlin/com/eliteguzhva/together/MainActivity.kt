package com.eliteguzhva.together

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  private val CHANNEL = "com.eliteguzhva/togetherChannel"

  private val notificationChannelID = "notificationChannelID"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine)

    createNotificationChannel()

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      // Note: this method is invoked on the main thread.
      if (call.method == "notify") {
        sendNotification(call.argument<String>("content"))
        result.success("Successfully sent notification!")
      } else {
        result.notImplemented()
      }
    }
  }

  private fun sendNotification(content: String?) {
    val builder = NotificationCompat.Builder(this, notificationChannelID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Together")
            .setContentText(content)
            .setPriority(NotificationCompat.PRIORITY_HIGH)

    with(NotificationManagerCompat.from(this)) {
      // notificationId is a unique int for each notification that you must define
      notify(0, builder.build())
    }
  }

  private fun createNotificationChannel() {
    // Create the NotificationChannel, but only on API 26+ because
    // the NotificationChannel class is new and not in the support library
    val name = "Chat"
    val descriptionText = "Together default notification channel"
    val importance = NotificationManager.IMPORTANCE_HIGH
    val channel = NotificationChannel(notificationChannelID, name, importance).apply {
      description = descriptionText
    }
    channel.enableVibration(true)
    channel.lightColor = 0x0000FF
    channel.enableLights(true)

    // Register the channel with the system
    val notificationManager: NotificationManager =
            getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    notificationManager.createNotificationChannel(channel)
  }
}
