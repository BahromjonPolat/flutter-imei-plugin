## 0.1.0

* Added READ_PRIVILEGED_PHONE_STATE permission for Android 10+ system apps
* Enhanced error messages with clear instructions for different scenarios
* Updated documentation with detailed Android 10+ restrictions and alternatives
* Improved permission handling for both regular and privileged permissions
* Added support for system apps on Android 10+ (with platform signature)

**Breaking Changes**: None

**Android 10+ Support**:
- System apps (with READ_PRIVILEGED_PHONE_STATE): ✅ Full IMEI access
- Regular apps: ❌ SecurityException (use Android ID instead)

## 0.0.1

* Initial release - Android only
* Get single IMEI number on Android 5.0 - 9.0 (API 21-28)
* Get multiple IMEI numbers for dual SIM devices (Android 5.0 - 9.0)
* Modern plugin architecture with Kotlin 2.1.0
* Gradle 8.11.1 with Android Gradle Plugin 8.7.3
* Updated to Flutter 3.24.0+ and Dart 3.5.0+
* Clear error messages for Android 10+ restrictions
* Comprehensive example app with permission handling
* Full documentation with alternatives for Android 10+
* iOS support removed (not available due to Apple privacy policy)

**Important**: Android 10+ (API 29+) restricts IMEI access to system apps only. Regular apps should use Android ID or other alternatives.
