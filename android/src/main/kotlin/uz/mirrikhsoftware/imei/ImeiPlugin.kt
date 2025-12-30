package uz.mirrikhsoftware.imei

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.telephony.TelephonyManager
import androidx.core.app.ActivityCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ImeiPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "imei")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getImei" -> {
        try {
          val imei = getImei()
          if (imei != null) {
            result.success(imei)
          } else {
            result.error("UNAVAILABLE", "IMEI not available", null)
          }
        } catch (e: Exception) {
          result.error("ERROR", e.message, null)
        }
      }
      "getImeiList" -> {
        try {
          val imeiList = getImeiList()
          result.success(imeiList)
        } catch (e: Exception) {
          result.error("ERROR", e.message, null)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun getImei(): String? {
    if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE)
        != PackageManager.PERMISSION_GRANTED) {
      return null
    }

    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      telephonyManager.imei ?: telephonyManager.meid
    } else {
      @Suppress("DEPRECATION")
      telephonyManager.deviceId
    }
  }

  private fun getImeiList(): List<String> {
    if (ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE)
        != PackageManager.PERMISSION_GRANTED) {
      return emptyList()
    }

    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    val imeiList = mutableListOf<String>()

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      val phoneCount = telephonyManager.phoneCount
      for (i in 0 until phoneCount) {
        try {
          val imei = telephonyManager.getImei(i)
          if (imei != null) {
            imeiList.add(imei)
          }
        } catch (e: Exception) {
          // Ignore if slot is empty
        }
      }
    } else {
      @Suppress("DEPRECATION")
      val deviceId = telephonyManager.deviceId
      if (deviceId != null) {
        imeiList.add(deviceId)
      }
    }

    return imeiList
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
