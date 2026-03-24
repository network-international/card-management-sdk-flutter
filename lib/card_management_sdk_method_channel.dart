import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'card_management_sdk_platform_interface.dart';

/// An implementation of [CardManagementSdkPlatform] that uses method channels.
class MethodChannelCardManagementSdk extends CardManagementSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('card_management_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
