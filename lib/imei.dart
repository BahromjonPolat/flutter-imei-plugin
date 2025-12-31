import 'dart:async';

import 'package:flutter/services.dart';

class Imei {
  static const MethodChannel _channel = MethodChannel('imei');

  /// Get the IMEI number of the device.
  ///
  /// **Android Only**: Returns the IMEI number as a String.
  ///
  /// Requires READ_PHONE_STATE permission on Android.
  ///
  /// Returns null if permission is not granted or IMEI is not available.
  static Future<String?> getImei() async {
    try {
      final String? imei = await _channel.invokeMethod('getImei');
      return imei;
    } on PlatformException catch (e) {
      throw Exception('Failed to get IMEI: ${e.message}');
    }
  }

  /// Get list of all IMEI numbers (for dual SIM devices).
  ///
  /// **Android Only**: Returns a list of IMEI numbers.
  ///
  /// Requires READ_PHONE_STATE permission on Android.
  ///
  /// Returns empty list if permission is not granted.
  static Future<List<String>> getImeiList() async {
    try {
      final List<dynamic>? imeiList = await _channel.invokeMethod('getImeiList');
      return imeiList?.cast<String>() ?? [];
    } on PlatformException catch (e) {
      throw Exception('Failed to get IMEI list: ${e.message}');
    }
  }
}