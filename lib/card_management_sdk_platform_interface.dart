import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'card_management_sdk_method_channel.dart';

abstract class CardManagementSdkPlatform extends PlatformInterface {
  /// Constructs a CardManagementSdkPlatform.
  CardManagementSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static CardManagementSdkPlatform _instance = MethodChannelCardManagementSdk();

  /// The default instance of [CardManagementSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelCardManagementSdk].
  static CardManagementSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CardManagementSdkPlatform] when
  /// they register themselves.
  static set instance(CardManagementSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
