import 'dart:async';

import 'package:flutter/services.dart';

class Imei {
  static const MethodChannel _channel = MethodChannel('imei');

  /// Get the IMEI number of the device.
  ///
  /// Returns the IMEI number as a String on Android.
  /// On iOS, this will throw a [PlatformException] since Apple doesn't allow
  /// access to IMEI for privacy reasons.
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
  /// Returns a list of IMEI numbers on Android.
  /// On iOS, this will return an empty list since Apple doesn't allow
  /// access to IMEI for privacy reasons.
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