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
    // Check for READ_PRIVILEGED_PHONE_STATE (system apps) or READ_PHONE_STATE
    val hasPrivilegedPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      ActivityCompat.checkSelfPermission(context, "android.permission.READ_PRIVILEGED_PHONE_STATE") == PackageManager.PERMISSION_GRANTED
    } else {
      false
    }

    val hasPhoneStatePermission = ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED

    if (!hasPhoneStatePermission && !hasPrivilegedPermission) {
      throw SecurityException("READ_PHONE_STATE or READ_PRIVILEGED_PHONE_STATE permission not granted")
    }

    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager

    return try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        // Android 10+ requires READ_PRIVILEGED_PHONE_STATE for regular IMEI access
        if (!hasPrivilegedPermission) {
          throw SecurityException(
            "IMEI access is restricted on Android 10+. " +
            "Requires READ_PRIVILEGED_PHONE_STATE permission (system apps only). " +
            "Regular apps should use Android ID or other alternatives."
          )
        }
        // Try to get IMEI with privileged permission
        telephonyManager.imei ?: telephonyManager.meid
      } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        telephonyManager.imei ?: telephonyManager.meid
      } else {
        @Suppress("DEPRECATION")
        telephonyManager.deviceId
      }
    } catch (e: SecurityException) {
      throw e
    } catch (e: Exception) {
      throw SecurityException("Failed to get IMEI: ${e.message}")
    }
  }

  private fun getImeiList(): List<String> {
    // Check for READ_PRIVILEGED_PHONE_STATE (system apps) or READ_PHONE_STATE
    val hasPrivilegedPermission = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      ActivityCompat.checkSelfPermission(context, "android.permission.READ_PRIVILEGED_PHONE_STATE") == PackageManager.PERMISSION_GRANTED
    } else {
      false
    }

    val hasPhoneStatePermission = ActivityCompat.checkSelfPermission(context, Manifest.permission.READ_PHONE_STATE) == PackageManager.PERMISSION_GRANTED

    if (!hasPhoneStatePermission && !hasPrivilegedPermission) {
      throw SecurityException("READ_PHONE_STATE or READ_PRIVILEGED_PHONE_STATE permission not granted")
    }

    val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
    val imeiList = mutableListOf<String>()

    try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        // Android 10+ requires READ_PRIVILEGED_PHONE_STATE for regular IMEI access
        if (!hasPrivilegedPermission) {
          throw SecurityException(
            "IMEI access is restricted on Android 10+. " +
            "Requires READ_PRIVILEGED_PHONE_STATE permission (system apps only). " +
            "Regular apps should use Android ID or other alternatives."
          )
        }
        // Try to get IMEI list with privileged permission
        val phoneCount = telephonyManager.phoneCount
        for (i in 0 until phoneCount) {
          try {
            val imei = telephonyManager.getImei(i)
            if (imei != null) {
              imeiList.add(imei)
            }
          } catch (e: Exception) {
            // Ignore if slot is empty or access denied
          }
        }
      } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val phoneCount = telephonyManager.phoneCount
        for (i in 0 until phoneCount) {
          try {
            val imei = telephonyManager.getImei(i)
            if (imei != null) {
              imeiList.add(imei)
            }
          } catch (e: Exception) {
            // Ignore if slot is empty or access denied
          }
        }
      } else {
        @Suppress("DEPRECATION")
        val deviceId = telephonyManager.deviceId
        if (deviceId != null) {
          imeiList.add(deviceId)
        }
      }
    } catch (e: SecurityException) {
      throw e
    } catch (e: Exception) {
      throw SecurityException("Failed to get IMEI list: ${e.message}")
    }

    return imeiList
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
