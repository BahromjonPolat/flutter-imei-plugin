# IMEI Plugin

A Flutter plugin to retrieve IMEI (International Mobile Equipment Identity) numbers from Android devices.

## Platform Support

| Platform | Supported | Notes |
|----------|-----------|-------|
| Android  | Yes       | Requires READ_PHONE_STATE permission |
| iOS      | No        | Apple removed IMEI access for privacy reasons |

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

Add the following permission to your `AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
```

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

### iOS Support
iOS does not support IMEI retrieval. Apple removed access to device identifiers like IMEI and UDID for privacy reasons. On iOS:
- `getImei()` will throw a PlatformException
- `getImeiList()` will return an empty list

If you need to identify iOS devices, consider using:
- `identifierForVendor` (changes when app is reinstalled)
- Device check API for fraud prevention

### Android API Versions
- **API 26+**: Uses `TelephonyManager.getImei()` and `TelephonyManager.getMeid()`
- **API 21-25**: Uses deprecated `TelephonyManager.getDeviceId()`

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
