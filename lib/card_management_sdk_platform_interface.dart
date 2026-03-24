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

  Future<void> initialize({
    required String token,
    required String rootUrl,
    required String bankCode,
    required String cardIdentifierId,
    required String cardIdentifierType,
    bool debugLogToConsole = false,
    Map<String, String>? extraNetworkHeaders,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getCardDetails() {
    throw UnimplementedError('getCardDetails() has not been implemented.');
  }

  Future<Map<String, dynamic>?> setPin(String pin) {
    throw UnimplementedError('setPin() has not been implemented.');
  }

  Future<Map<String, dynamic>?> verifyPin(String pin) {
    throw UnimplementedError('verifyPin() has not been implemented.');
  }

  Future<Map<String, dynamic>?> changePin(String oldPin, String newPin) {
    throw UnimplementedError('changePin() has not been implemented.');
  }

  Future<String?> getPin() {
    throw UnimplementedError('getPin() has not been implemented.');
  }
}

