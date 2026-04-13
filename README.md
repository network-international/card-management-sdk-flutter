# Network International Card Management SDK Flutter Plugin

The Network International Card Management SDK Flutter Plugin allows you to integrate with Network International standard APIs for card management. (https://developer.network.ae).

## Features

- **SDK Initialization**: Initialize the SDK session with authentication and configuration
- **Card Details**: Fetch comprehensive card information (PAN, expiry, cardholder details, etc.)
- **PIN Management**: Set, verify, change, and retrieve card PINs securely
- **Flexible Configuration**: Support for custom network headers and debug logging
- **Multi-Platform**: Native implementations for both Android and iOS
- **Type-Safe**: Full Dart typing with proper error handling

## Supported Platforms

- **Android** API level 24+
- **iOS** 15.0+
- **Flutter** 3.3.0 or higher
- **Dart** 3.11.1 or higher

## Installation

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
	card_management_sdk: ^<latest_version>
```

Then install packages:

```bash
flutter pub get
```

## SDK Configuration

Create an SDK instance once (for example in your service layer or app startup)
and call `initialize` before any other operation.

```dart
import 'package:card_management_sdk/card_management_sdk.dart';

final sdk = CardManagementSdk();

Future<void> configureSdk() async {
	await sdk.initialize(
		token: '<access_token>',
		rootUrl: 'https://<your-api-host>/api/v2/sdk/v2',
		bankCode: '<bank_code>',
		cardIdentifierId: '<card_identifier_id>',
		cardIdentifierType: '<card_identifier_type>',
		debugLogToConsole: false,
		extraNetworkHeaders: {
			'x-custom-header': 'value',
		},
	);
}
```

### `initialize` Parameters

- `token`: Authorization token used by SDK API calls - shold be generated on your Middleware the same way as for standard API calls.
- `rootUrl`: Base URL for your SDK backend endpoint, example `https://api-uat.network.global/sdk/v2` - SDK will use it as a base URL path for creating necessary requests, final requests will be created by concatenating path components to the rootUrl. #Note: rootUrl can be used to route all SDK requests through your Middleware (in this case it will be used as a proxy) to NI services - for the full controll of SDK requests flow.
- `bankCode`: FI code.
- `cardIdentifierId`: Card identifier value.
- `cardIdentifierType`: Type for the identifier (for example, `EXID`).
- `debugLogToConsole`: Optional; enables SDK debug logs in console.
- `extraNetworkHeaders`: Optional; extra headers to attach to network calls.

## Usage Examples

Check `example` directory for impmemenattion details.

Always call `initialize` successfully before invoking these methods.

### Fetch Card Details

```dart
Future<Map<String, dynamic>?> fetchCardDetails() async {
	try {
		final details = await sdk.getCardDetails();
		return details;
	} catch (e) {
		// Handle SDK/platform errors in your app flow.
		rethrow;
	}
}
```

### Set PIN

```dart
Future<Map<String, dynamic>?> setPin(String pin) async {
	try {
		final result = await sdk.setPin(pin);
		return result;
	} catch (e) {
		rethrow;
	}
}
```

### Verify PIN

```dart
Future<Map<String, dynamic>?> verifyPin(String pin) async {
	try {
		final result = await sdk.verifyPin(pin);
		return result;
	} catch (e) {
		rethrow;
	}
}
```

### Change PIN

```dart
Future<Map<String, dynamic>?> changePin(String oldPin, String newPin) async {
	try {
		final result = await sdk.changePin(oldPin, newPin);
		return result;
	} catch (e) {
		rethrow;
	}
}
```

### Get PIN

```dart
Future<String?> getPin() async {
	try {
		final pin = await sdk.getPin();
		return pin;
	} catch (e) {
		// Handle SDK/platform errors in your app flow.
		rethrow;
	}
}
```

## Error Handling

All methods throw exceptions that should be caught and handled appropriately in your application:

```dart
try {
	await sdk.initialize(...);
} on PlatformException catch (e) {
	print('Platform error: ${e.code} - ${e.message}');
	// Handle platform-specific errors
} catch (e) {
	print('Unexpected error: $e');
	// Handle other errors
}
```

## Public API

```dart
class CardManagementSdk {
	Future<void> initialize({...});
	Future<Map<String, dynamic>?> getCardDetails();
	Future<Map<String, dynamic>?> setPin(String pin);
	Future<Map<String, dynamic>?> verifyPin(String pin);
	Future<Map<String, dynamic>?> changePin(String oldPin, String newPin);
	Future<String?> getPin();
}
```

## Android Integration: ProGuard / R8

If your Android app enables minification (`minifyEnabled true`) for release builds,
add ProGuard/R8 rules to avoid stripping required SDK classes.

In your host app module (`android/app/proguard-rules.pro`), add:

```pro
-dontwarn javax.naming.**

-keep class org.bouncycastle.** { *; }

# Keep classes from the underlying Android Card Management SDK.
-keep class ae.network.nicardmanagementsdk.** { *; }
-keepclassmembers class ae.network.nicardmanagementsdk.** { *; }
```

And confirm your app `build.gradle(.kts)` release build type points to this file,
for example:

```kotlin
buildTypes {
	release {
		isMinifyEnabled = true
		proguardFiles(
			getDefaultProguardFile("proguard-android-optimize.txt"),
			"proguard-rules.pro"
		)
	}
}
```

If minification is disabled, these rules are not required.

## iOS Integration

### Platform Requirements

- **iOS Deployment Target**: 15.0 or higher
- **Swift Version**: 5.0+
- **CocoaPods**: Required for dependency management

### Configuration

The plugin is automatically registered in your Flutter app. No additional platform configuration is required beyond the standard Flutter setup.

Ensure your `ios/Podfile` includes the correct minimum platform version:

```ruby
platform :ios, '15.0'
```

### Privacy Manifest

This plugin includes a privacy manifest (`PrivacyInfo.xcprivacy`) to comply with Apple's Privacy Manifest requirements. No additional action is needed unless your app has custom privacy requirements.

## Troubleshooting

### Initialization Failures

**Problem**: `initialize()` throws an error  
**Solution**:
- Verify your token is valid and not expired
- Check that `rootUrl` points to the correct API endpoint for your environment
- Ensure `bankCode`, `cardIdentifierId`, and `cardIdentifierType` are correctly provided
- Confirm network connectivity to the backend

### Android: Method Not Found Errors

**Problem**: `MissingMethodException` on Android  
**Solution**:
- Verify ProGuard/R8 rules are correctly configured if minification is enabled
- Clean and rebuild: `flutter clean && flutter pub get && flutter run`
- Check that `ae.network.nicardmanagementsdk` package is properly resolved

### iOS: Pod Installation Issues

**Problem**: Pod installation fails  
**Solution**:
- Update CocoaPods: `pod repo update`
- Clean and reinstall: `rm -rf ios/Pods ios/Podfile.lock && flutter pub get`
- Verify iOS deployment target matches Podfile settings (15.0+)

### Network Errors

**Problem**: `SocketException` or connection timeouts  
**Solution**:
- Verify app has internet connectivity
- Check that `rootUrl` is accessible in your network environment
- Confirm no firewall/proxy is blocking SDK API calls
- Try with `debugLogToConsole: true` to see detailed logs

## Notes

- Do not hardcode production tokens or sensitive card data in source code.
- Ensure no sensitive data (PIN, clear PAN, etc.) is logged anywhere between app UI layer and the SDK
- Always initialize the SDK before calling other methods
- The SDK is designed for single-session use; create a new instance if you need to switch authentication contexts

## Contributing

We welcome contributions to improve this plugin. To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

Please ensure:
- Code follows Dart/Flutter best practices
- All tests pass: `flutter test`
- Code is formatted: `dart format .`
- No linting issues: `flutter analyze`

## Support

For support and questions:

- **Documentation**: See [Network International Developer Portal](https://developer.network.ae)
- **Issues**: Report issues on [GitHub Issues](https://github.com/network-international/card-management-sdk-flutter/issues)
- **Email**: Contact Network International support team

## License

This plugin is licensed under the MIT License. See [LICENSE](LICENSE) file for details.

## Copyright

Copyright (c) 2024 Network International


