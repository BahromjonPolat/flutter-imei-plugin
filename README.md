# IMEI Plugin

A Flutter plugin to retrieve IMEI (International Mobile Equipment Identity) numbers from Android devices.

## ⚠️ Important Limitations

**Android Only**: This plugin only supports Android devices. iOS does not provide access to IMEI due to Apple's privacy policies.

**Android 10+ Restriction**: IMEI access is heavily restricted on Android 10+ (API 29+) and only available to system apps. This plugin works on Android 5.0 - 9.0 only for regular apps. See [Android 10+ Restrictions](#️-android-10-restrictions) for details and alternatives.

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android  | ✅ Yes    | Requires READ_PHONE_STATE permission |
| iOS      | ❌ No     | Not supported (Apple privacy policy) |

## Features

- Get single IMEI number
- Get multiple IMEI numbers (for dual SIM devices)
- Supports Android API 21+
- Modern null-safety support

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  imei: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Android Setup

The plugin automatically includes the required permissions in its manifest.

For reference, these permissions are:

```xml
<!-- Required for Android 5.0-9.0 -->
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>

<!-- Required for Android 10+ (only granted to system apps) -->
<uses-permission android:name="android.permission.READ_PRIVILEGED_PHONE_STATE"/>
```

**Note**: You don't need to manually add these to your app's `AndroidManifest.xml` - they're included in the plugin.

### Runtime Permission

For Android 6.0 (API level 23) and above, you need to request the permission at runtime. You can use the [permission_handler](https://pub.dev/packages/permission_handler) package:

```dart
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPhonePermission() async {
  final status = await Permission.phone.request();
  if (status.isGranted) {
    // Permission granted
  } else {
    // Permission denied
  }
}
```

## Usage

### Get Single IMEI

```dart
import 'package:imei/imei.dart';

try {
  String? imei = await Imei.getImei();
  if (imei != null) {
    print('IMEI: $imei');
  } else {
    print('IMEI not available or permission denied');
  }
} catch (e) {
  print('Error: $e');
}
```

### Get Multiple IMEIs (Dual SIM)

```dart
import 'package:imei/imei.dart';

try {
  List<String> imeiList = await Imei.getImeiList();
  if (imeiList.isNotEmpty) {
    for (int i = 0; i < imeiList.length; i++) {
      print('IMEI ${i + 1}: ${imeiList[i]}');
    }
  } else {
    print('No IMEI numbers available or permission denied');
  }
} catch (e) {
  print('Error: $e');
}
```

## Example App

See the [example](example/) directory for a complete sample app demonstrating how to use this plugin.

## Important Notes

### ⚠️ Android 10+ Restrictions

**CRITICAL**: Starting from Android 10 (API 29), Google has heavily restricted access to device identifiers including IMEI.

**This plugin will NOT work on Android 10+ devices for regular apps.**

IMEI access on Android 10+ is only available to apps with `READ_PRIVILEGED_PHONE_STATE` permission:
- **System apps** (pre-installed on device with platform signature)
- **Apps with carrier privileges**
- **Default SMS apps**

This plugin includes the `READ_PRIVILEGED_PHONE_STATE` permission declaration, but it will only be granted to system apps. Regular apps installed from Google Play Store or as APKs will receive a SecurityException.

**Recommended Alternatives:**
For device identification on Android 10+, consider using:
- **Android ID**: `Settings.Secure.ANDROID_ID` (resets on factory reset)
- **Firebase Installation ID**: Unique per app installation
- **Advertising ID**: For advertising purposes only
- **UUID**: Generate and store your own unique identifier

### Supported Android Versions
- **Android 5.0 - 9.0 (API 21-28)**: ✅ Full IMEI access with permission
- **Android 10+ (API 29+)**: ❌ Restricted (system apps only)

### Android API Versions
- **API 26-28**: Uses `TelephonyManager.getImei()` and `TelephonyManager.getMeid()`
- **API 21-25**: Uses deprecated `TelephonyManager.getDeviceId()`
- **API 29+**: Throws SecurityException (Android 10+ restrictions)

### Privacy Considerations
IMEI is a sensitive device identifier. Make sure to:
- Clearly explain why you need this permission in your app
- Handle the data securely
- Comply with privacy regulations (GDPR, etc.)
- Only request when necessary

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Bahromjon Polat - [GitHub](https://github.com/BahromjonPolat)
