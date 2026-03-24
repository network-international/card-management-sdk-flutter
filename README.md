# Network International Card Management SDK Flutter Plugin

The Network International Card Management SDK Flutter Plugin allows you to integrate with Network International standard APIs for card management. (https://developer.network.ae).

The plugin exposes methods to:

- initialize the SDK session
- fetch card details
- set a card PIN
- verify a PIN
- change a PIN

The plugin currently provides platform implementations for Android and iOS.

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

## Notes

- Do not hardcode production tokens or sensitive card data in source code.
- Ensure no sensitive data (PIN, clear pan, ...) leaked or logged anywhere between app UI layer and the SDK

